# CharlesCraft 0.3.0 redesign record

CharlesCraft is an independent network debugging application. This release
continues Lens with original Craft branding and a redesigned native workspace.
It does not include Charles Proxy code or artwork and does not claim complete
feature parity.

## Surface coverage

| Surface | Change |
| --- | --- |
| Main workspace | Branded capture header, persistent navigation sidebar, connection status strip, inset session controls and distinct traffic/inspector panes |
| Traffic list | Clear column header, request count and colored method badges; pane-width column budgeting keeps Method/Status/Host/Path visible, with Time/Size added in wide panes; existing filtering and selection retained |
| Empty and failure states | Existing state-specific stopped, listening, paused, failed and Mac-routing explanations presented in the new workspace; device actions retain their full labels |
| Inspector | Request summary, status/duration badges, overview cards and headers cards; existing tabs and body controls retained |
| JSON and WebSocket viewers | New toolbar/card surfaces; lossless JSON model, text layout, hex, forms, multipart, XML and Protobuf readers retained |
| Connection and settings | Shared Craft heading, typography and surfaces in the connection guide, network settings and client certificate editor |
| Traffic tools | Shared Craft heading/surfaces in Compose, Repeat, breakpoint editing, rules, Access Lists, TCP and UDP tools; rule/job/list cards |
| Session tools | Shared headings/surfaces in session actions, comparison and export tools; native file and confirmation dialogs retained |
| Device setup page | Responsive white cards, navy/teal styling, numbered steps and keyboard focus states; existing certificate fingerprint and setup endpoint retained |
| App and distribution | Original geometric icon, CharlesCraft app/executable/display names, matching DMG names and install instructions |

Bundle ID `dev.lens.proxy`, `~/Library/Application Support/Lens`, preference keys,
workspace formats, CA storage and `http://lens.invalid/` remain compatible with
existing installations. Build environment variables retain their `LENS_` names.

## Acceptance plan

Normally launch the packaged app with the existing profile and an isolated fresh
profile. Verify actionable connection/recording states, then generate a new
controlled JSON POST through the explicitly configured loopback client with
ordinary compression negotiation. Inspect Request and Response headers and
body in the actual window, including narrow-width layout. Open the setup,
settings, rules and request tools, save a session, Stop, Quit and relaunch.
Preserve existing proxy/VPN settings and trust throughout these checks.

The controlled client path establishes explicit-proxy behavior only. Ordinary
browser system routing, physical phone trust and downloaded-app installation
require separate authorization/environment and evidence.

## Executed source checks

- Optimized native build and strict deep ad-hoc signature verification passed.
- Public bootstrap and access policy: 11 tests passed.
- JSON, body, multipart and hosted text layout: 57 groups passed.
- Access list and breakpoint integration: 26 tests passed with loopback fixtures.
- Distribution packaging: seven tests passed, including actual DMG mount/copy,
  archive extraction, byte/mode/symlink equality and signature checks.
- Shell syntax, changed Python source parsing and diff whitespace checks passed.

An early 0.3.0 preview was inspected in an actual 1480 × 920 window: the workspace
and connection guide were readable, listening without Mac routing was explicit,
and Stop displayed the stopped state. This exposed a truncated device action;
the final candidate fixes its intrinsic width and improves toolbar accessibility
labels. A subsequent candidate showed correct Request/Response JSON and gzip
decoding, but native table columns overflowed the standard traffic pane. The
revised candidate budgets content widths from the actual pane and hides optional
Time/Size columns below 760 points; those values remain in the inspector.
Actual-window review then passed four-column visibility at 584- and 492-point
traffic pane widths. It identified low contrast in selected Method/Status cells;
these now inherit the native selection foreground in both table layouts.
Final-candidate selected-row contrast, controlled Request/Response inspection,
setup/tool windows and Stop/Save and Quit passed actual-window review. See the
[current acceptance record](craft-preview-acceptance.md). Distribution signing
is recorded by the release process and is not inferred from these UI checks.

The host's existing Clash route was preserved during the controlled checks.
No new physical Android/iOS, ordinary system-routed browser, Intel or clean-Mac
download acceptance is established by this redesign record. Earlier Lens
verification keeps its original artifact scope.
