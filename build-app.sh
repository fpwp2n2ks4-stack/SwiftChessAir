#!/bin/bash
# build-app.sh
# Rôle : compile SwiftChessAir en release et empaquette une application macOS
# « SwiftChess Air » avec l'Info.plist déclarant l'accès Bluetooth (NSBluetoothAlwaysUsageDescription),
# indispensable pour que le scan/l'échiquier SwiftChessAir fonctionne.

set -euo pipefail
cd "$(dirname "$0")"

swift build -c release

BIN_DIR="$(swift build -c release --show-bin-path)"
APP="SwiftChessAir.app"
CONTENTS="$APP/Contents"
MACOS="$CONTENTS/MacOS"

rm -rf "$APP"
mkdir -p "$MACOS" "$CONTENTS/Resources"

cp "$BIN_DIR/SwiftChessAir" "$MACOS/SwiftChessAir"
# Icône de l'app : requise par CFBundleIconFile, sinon le Dock et le panneau
# « À propos » affichent l'icône générique.
cp "Resources/AppIcon.icns" "$CONTENTS/Resources/AppIcon.icns"
# Le bundle de ressources doit se trouver là où resource_bundle_accessor le cherche
# (Bundle.main.bundleURL appending "SwiftChessAir_SwiftChessAir.bundle").
cp -R "$BIN_DIR/SwiftChessAir_SwiftChessAir.bundle" "$APP/SwiftChessAir_SwiftChessAir.bundle"

cat > "$CONTENTS/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>SwiftChess Air</string>
    <key>CFBundleDisplayName</key>
    <string>SwiftChess Air</string>
    <key>CFBundleExecutable</key>
    <string>SwiftChessAir</string>
    <key>CFBundleIdentifier</key>
    <string>app.swiftchessair.air</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon.icns</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2026 SwiftChess Air contributors · Licence MIT</string>
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>L'accès Bluetooth est utilisé pour détecter, se connecter et communiquer avec votre échiquier SwiftChessAir.</string>
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>L'accès Bluetooth est utilisé pour détecter, se connecter et communiquer avec votre échiquier SwiftChessAir.</string>
</dict>
</plist>
PLIST

echo "Créé : $(pwd)/$APP"
