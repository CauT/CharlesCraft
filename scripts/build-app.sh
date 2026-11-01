#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="${LENS_APP_OUTPUT:-$ROOT/CharlesCraft.app}"
VERSION="$(cat "$ROOT/VERSION")"
BUILD_NUMBER="${LENS_BUILD_NUMBER:-10}"
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ && "$BUILD_NUMBER" =~ ^[0-9]+$ ]] || { echo "Invalid version/build number" >&2; exit 1; }
RUNTIME="$(find "$ROOT/.python" -maxdepth 1 -type d -name 'cpython-3.13.12-macos-*-none' | head -1)"
if [[ -z "$RUNTIME" || ! -x "$ROOT/.runtime/bin/python" ]]; then
  echo "Run scripts/bootstrap.sh first to prepare the private Python runtime." >&2
  exit 1
fi
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" "$ROOT/.build/ModuleCache"
swiftc -swift-version 5 -parse-as-library -O -module-cache-path "$ROOT/.build/ModuleCache" \
  -target "$(uname -m)-apple-macosx14.0" \
  -framework SwiftUI -framework AppKit \
  "$ROOT"/Sources/Lens/*.swift -o "$APP/Contents/MacOS/CharlesCraft"
swiftc -swift-version 5 -parse-as-library -O -module-cache-path "$ROOT/.build/ModuleCache" \
  -target "$(uname -m)-apple-macosx14.0" \
  "$ROOT/Sources/PeerIdentity/ProcessIdentityReader.swift" \
  "$ROOT/Sources/PeerIdentity/PeerIdentityMain.swift" -o "$APP/Contents/Resources/peer-process-identities"
cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>CharlesCraft</string>
<key>CFBundleIdentifier</key><string>dev.lens.proxy</string>
<key>CFBundleName</key><string>CharlesCraft</string>
<key>CFBundleDisplayName</key><string>CharlesCraft</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleIconFile</key><string>CharlesCraft</string>
<key>CFBundleShortVersionString</key><string>0.0.0</string>
<key>CFBundleVersion</key><string>0</string>
<key>LSMinimumSystemVersion</key><string>14.0</string>
<key>NSHighResolutionCapable</key><true/>
<key>NSHumanReadableCopyright</key><string>CharlesCraft — independent network inspection tool. MIT licensed.</string>
<key>NSLocalNetworkUsageDescription</key><string>CharlesCraft forwards and inspects requests you explicitly send through its local proxy.</string>
</dict></plist>
PLIST
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION" "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "$APP/Contents/Info.plist"
if [[ ! -f "$ROOT/.build/CharlesCraft.icns" || "$ROOT/scripts/make-icon.swift" -nt "$ROOT/.build/CharlesCraft.icns" ]]; then
  swift -module-cache-path "$ROOT/.build/ModuleCache" "$ROOT/scripts/make-icon.swift" "$ROOT/.build/CharlesCraft.iconset"
  iconutil -c icns "$ROOT/.build/CharlesCraft.iconset" -o "$ROOT/.build/CharlesCraft.icns"
fi
cp "$ROOT/.build/CharlesCraft.icns" "$APP/Contents/Resources/CharlesCraft.icns"
# The standalone CPython distribution is relocatable. No dependency on Homebrew
# or this checkout remains in the resulting app.
if [[ ! -x "$APP/Contents/Resources/python/bin/python3" ]]; then
  ditto --norsrc --noextattr "$RUNTIME" "$APP/Contents/Resources/python"
fi
ditto --norsrc --noextattr "$ROOT/.runtime/lib/python3.13/site-packages" "$APP/Contents/Resources/site-packages"
mkdir -p "$APP/Contents/Resources/engine"
rm -f "$APP/Contents/Resources/engine/tcp_forwarding.py"
cp "$ROOT"/engine/*.py "$APP/Contents/Resources/engine/"
cp "$ROOT/LICENSE" "$APP/Contents/Resources/CharlesCraft-LICENSE.txt"
if [[ -f "$ROOT/THIRD_PARTY_NOTICES.md" ]]; then cp "$ROOT/THIRD_PARTY_NOTICES.md" "$APP/Contents/Resources/"; fi
codesign --force --deep --sign - "$APP"
codesign --verify --deep --strict --verbose=2 "$APP"
echo "$APP"
