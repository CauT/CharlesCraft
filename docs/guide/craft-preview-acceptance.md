# CharlesCraft 0.3.0 preview acceptance

Checked on macOS / Apple Silicon, 2026-11-01. Version 0.3.0, build 10, minimum
macOS 14. This is a preview; scoped checks are not a complete Charles parity claim.

Implementation commit: `b79ef5a04596e569e1971f97b3f1bd32bb0c46f9`.
Actual-window candidate: `.build/charlescraft-0.3.0-selection/CharlesCraft.app`.
Ad-hoc candidate executable SHA-256:
`ab4824c158a6cccfb4ebc2c5a2a1212db6781ed34bafe248539cb1b081031ce3`.
Packaged `engine.py` SHA-256:
`b364788f5d9a0bd43600062c956f899e84a3c85b9be0e76860e807e6893bbbf2`.
Developer ID signing changes executable signature bytes; final distribution
identities and notarization belong to the accompanying release receipts.

| Journey | Actual result and scope |
| --- | --- |
| Normal launch, existing profile | Passed; listener and recording states visible; banner explicitly says Mac traffic is not connected |
| Controlled new request | Passed; explicitly proxied loopback POST, 173-byte JSON request, 290-byte gzip response, 737 decoded bytes |
| Request/Response inspection | Passed; headers and JSON tree visible, exact `9007199254740993` and duplicate members preserved |
| Traffic layout | Passed at 584- and 492-point traffic pane widths; Method/Status/Host/Path remain visible |
| Selection contrast | Passed; Method/Status readable when focused and after selecting Response in the inspector |
| Setup and tool windows | Connection chooser, Access Lists, network settings, Compose, Repeat, TCP and UDP windows readable |
| Stop and Save and Quit | Passed; stopped state visible, controlled workspace saved, normal shutdown completed |
| Host configuration | Existing host proxy/VPN route and certificate trust unchanged; no network settings applied |
| Fresh-profile ordinary Mac browser routing | Unverified in this release run |
| Physical Android/iOS HTTPS trust and capture | Unverified in this release run |
| Intel / clean-Mac downloaded installation | Unverified in this release run |

The source checks passed an optimized native build, 11 bootstrap/access-policy
checks, 57 JSON/body/multipart/layout groups, 26 access-list/breakpoint checks and
seven distribution packaging tests. Packaging tests establish their controlled
fixtures, not final release notarization or downloaded-app launch.

The screenshots contain only synthetic localhost traffic and original app UI.
The request path used an explicit client proxy; it does not establish automatic
Mac routing. HTTPS additionally requires client trust and matching host scope.
Certificate-pinned clients may refuse inspection.
