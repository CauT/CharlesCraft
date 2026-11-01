# Image provenance

- `charlescraft-icon.png`: original CharlesCraft 0.3.0 geometric icon, rendered
  from `scripts/make-icon.swift` on 2026-11-01. It contains no reference-product
  artwork.

- `charlescraft-workspace.png`: actual CharlesCraft 0.3.0/build 10 workspace,
  captured on 2026-11-01 with a synthetic localhost JSON POST and gzip response.
- `charlescraft-setup.png`: actual connection chooser from that same candidate.
  Neither screenshot establishes ordinary Mac routing or physical-device trust.
  The existing host proxy and certificate trust were unchanged.

## Historical Lens screenshots

- `lens-icon.png`: original Lens application icon, from this project's icon generator.
- `setup-guide-english.jpg`: real Lens 0.2.4/build 7 native Get Started window.
- `phone-setup-english.jpg`: the actual English bootstrap response rendered in
  Chrome on loopback, with Android and iPhone instructions expanded.

Captured on 2026-10-23 without a mock UI or image generation. The page render is
not a device-path acceptance test. No private capture or CA key is included.
Neither image establishes automatic Mac routing or physical-phone HTTPS trust.
The displayed CA fingerprint is public certificate identity, not a private key.

Earlier local screenshot variants are preserved in the development checkout but
excluded from the English-only public source export. The application icon is
the project's original asset.
