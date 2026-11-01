"""Owned, fixed-path HTTP setup page and public-CA bootstrap; no private keys."""
from cryptography import x509
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.serialization import Encoding
from mitmproxy import http


PAGE = """<!doctype html>
<html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Connected to CharlesCraft</title><style>
:root{color-scheme:light;--ink:#192b3c;--teal:#087f89;--muted:#58707f}
*{box-sizing:border-box}body{font:16px/1.65 -apple-system,BlinkMacSystemFont,system-ui,sans-serif;margin:0;background:#edf4f6;color:var(--ink)}
main{max-width:680px;margin:32px auto;padding:32px;background:white;border:1px solid #dce7eb;border-radius:24px;box-shadow:0 12px 48px #123a4b09}
.brand{font-size:12px;font-weight:750;letter-spacing:2px;color:var(--teal)}
h1{font-size:30px;line-height:1.2;letter-spacing:-.8px;margin:20px 0 14px}h2{font-size:19px;margin-top:30px}
p{color:var(--muted)}code{display:inline;overflow-wrap:anywhere;font:13px/1.7 ui-monospace,monospace;color:var(--ink)}
p:has(>code:only-child){padding:16px;background:#f2f7f8;border-radius:12px;border:1px solid #dce7eb}
a.download{display:inline-flex;justify-content:center;padding:12px 22px;background:var(--teal);color:white;border-radius:10px;text-decoration:none;font-weight:650}
a.download:focus-visible,summary:focus-visible{outline:3px solid #68d1cf;outline-offset:4px}
details{margin-top:12px;padding:16px 18px;background:#f7fafb;border:1px solid #dce7eb;border-radius:12px}summary{cursor:pointer;font-weight:650}
small{display:block;color:var(--muted);font-size:13px;border-top:1px solid #dce7eb;margin-top:24px;padding-top:20px}
@media(max-width:700px){main{margin:0;padding:26px 20px;border-radius:0;min-height:100vh;border:0}h1{font-size:27px}}
</style><main>
<div class="brand">CHARLESCRAFT · DEVICE SETUP</div>
<h1 id="lens-connected">✓ Connected to CharlesCraft</h1>
<p>This HTTP request passed through the CharlesCraft proxy. On your Mac, find <code>http://lens.invalid/</code> in the traffic list.</p>
<h2>01 · Set up HTTPS inspection</h2>
<p>Compare this CA SHA-256 fingerprint with the one shown in CharlesCraft on your Mac before downloading and installing the certificate.</p>
<p><code>__SHA256__</code></p><a class="download" href="/certificate.cer">Download CharlesCraft CA</a>
<details open><summary>Android</summary><p>In Settings, find Install a certificate / CA certificate and install the downloaded file.
The certificate may be named mitmproxy, and menus vary by device. Some apps do not trust user CAs and need their developer to configure debug CA trust.</p></details>
<details><summary>iPhone / iPad</summary><p>Download the certificate in Safari. Install the profile in Settings → General → VPN &amp; Device Management,
then enable full trust for the root in General → About → Certificate Trust Settings. Installing the profile alone is not enough.</p></details>
<h2>02 · Verify your capture</h2><p>Open an HTTPS page or target app. In CharlesCraft on your Mac, select the request and inspect both Request and Response headers and bodies.
A CONNECT tunnel alone does not prove HTTPS decryption. This HTTP page cannot confirm that the certificate is installed or trusted.</p>
<small>Apps that pin certificates or ignore the Wi-Fi proxy may reject inspection. When finished, set the device Wi-Fi proxy to None / Off and remove any test certificates you no longer use.</small>
</main></html>"""


def response(path, public_certificate):
    if path not in ("/", "/certificate.cer"):
        return http.Response.make(404, b"Use http://lens.invalid/ for CharlesCraft setup")
    try:
        certificate = x509.load_pem_x509_certificate(public_certificate.read_bytes())
    except (OSError, ValueError):
        return http.Response.make(503, b"CharlesCraft public CA certificate is unavailable")
    headers = {"Cache-Control": "no-store", "X-Content-Type-Options": "nosniff"}
    if path == "/certificate.cer":
        headers.update({"Content-Type": "application/x-x509-ca-cert",
                        "Content-Disposition": 'attachment; filename="CharlesCraft-CA.cer"'})
        return http.Response.make(200, certificate.public_bytes(Encoding.DER), headers)
    headers.update({"Content-Type": "text/html; charset=utf-8",
                    "Content-Security-Policy": "default-src 'none'; style-src 'unsafe-inline'"})
    return http.Response.make(200, PAGE.replace("__SHA256__", certificate.fingerprint(hashes.SHA256()).hex()).encode(), headers)
