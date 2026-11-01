# Current verification scope

The current source is CharlesCraft 0.3.0 / build 10. Its Craft redesign is a new
UI acceptance surface; earlier Lens checks below retain their original artifact
scope. Signing and download acceptance are tied to the specific release receipt,
not inferred from compilation or historical Lens builds.

See the [current preview acceptance](craft-preview-acceptance.md) and the [Craft redesign record](craft-redesign.md) for the current source changes and checks.

## Previous Lens checks (historical)

- Lossless JSON model: seven smoke groups cover source order, duplicate members,
  exact numeric/string lexemes, Unicode, RFC 6901 pointers, errors and bounds.
- Shared body and multipart format checks: 17 and 32 groups passed.
- Full optimized native application build and strict deep signature passed.
- Packaged-engine onboarding integration exercised LAN HTTP/HTTPS, certificate
  bootstrap, inspectable details and owned shutdown without host proxy access.
- Actual build 7 windows verified Request/Response trees, search, next-match
  navigation, selected-value/pointer copy, duplicate ambiguity and short-body
  Pretty/Source. The English Get Started window and Android/iPhone steps were
  inspected. Controlled traffic used normal gzip negotiation.
- Development DMG checks passed read-only mount, copied app byte/mode/symlink
  equality, absence of AppleDouble metadata and strict deep signature.
- The resumed 2026-10-29 packaged E2E run passed 307 tests without skips,
  including 17 actual Android 15 Activity checks and eight macOS Foundation
  checks. These are network/client tests, not physical-device or iOS claims.
  Native workspace/startup/quit boundaries passed 20 groups in addition to the
  57 JSON/body/multipart/layout groups.

## Final build 9 window acceptance — 2026-10-30

Builds 7 and 8 showed clipped characters at the right edge of a wrapped long
JSON line. The resumed build 8 run confirmed the other JSON interactions,
malformed/truncated fallback, binary Hex, pause forwarding and Stop/Quit, but
still failed wrapped text. The former isolated AppKit check missed a hosted
ruler overlay and is insufficient proof of this behavior.

Build 9 excludes the ruler's actual overlap from wrapped layout width. A new
production-shaped NSHostingView regression fails against build 8 and passes
after the fix at narrow and wide sizes. Normal build 9 launch with the existing
manual-client profile now also passes actual-window inspection of new controlled
traffic: Request/Response headers, Tree, Pretty and Source; search/navigation and
pointer copy; duplicate pointer protection; long-line wrap at approximately 350,
494 and 680-pixel inspector widths; horizontal scrolling; malformed JSON, bounded
large-body preview and binary Hex. Ordinary gzip negotiation was preserved.
Pause forwards without recording; Stop retains inspectable bodies; Save and Quit
retains exact response bytes, including the complete 2,097,493-byte JSON body.
Normal relaunch starts the loopback listener and explains that Mac traffic is
not connected. Quit releases the listener. Android/iOS and existing-proxy guide
states were inspected without applying network settings.

A follow-up actual-window run also passed Replay, a three-request Repeat job,
Compose into a new session and switching between retained sessions. Save and Quit
preserved both sessions with five and one entries; all six responses and five
POST bodies matched their controlled fixtures byte-for-byte.

## Remaining acceptance limits

The controlled UI request used an explicit client proxy. Fresh-profile ordinary
browser capture through the Mac system route, physical Android/iOS, and iOS
simulator acceptance remain unverified. The previous Android Activity and protocol
suite results retain their narrower scope. This is not a stable-release readiness
or exhaustive all-menu UI claim.

Ad-hoc integrity does not establish Developer ID signing, notarization,
Gatekeeper/download installation, Intel compatibility or physical-device HTTPS
trust. Existing proxy/VPN routing and certificate trust were not changed during
the controlled checks. Unicode fixtures remain in the tests as escape sequences
to keep source text English while preserving the tested bytes and values.
