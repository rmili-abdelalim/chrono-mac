#!/bin/bash
# Installe un chronomètre dans la barre des menus du Mac
set -e
echo "⏱  Installation du chronomètre..."

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Il faut d'abord installer les outils de développement d'Apple (gratuit)."
  xcode-select --install || true
  echo "👉 Une fenêtre vient de s'ouvrir : clique sur « Installer », attends la fin,"
  echo "   puis relance exactement la même commande."
  exit 0
fi

APP="$HOME/Applications/Chrono.app"
mkdir -p "$APP/Contents/MacOS"
TMP=$(mktemp -d)

SRC="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd)/Chrono.swift"
if [ -f "$SRC" ]; then
  cp "$SRC" "$TMP/Chrono.swift"
else
  curl -fsSL https://raw.githubusercontent.com/rmili-abdelalim/chrono-mac/main/Chrono.swift -o "$TMP/Chrono.swift"
fi

echo "Compilation en cours (quelques secondes)..."
swiftc -O "$TMP/Chrono.swift" -o "$APP/Contents/MacOS/Chrono"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>Chrono</string>
  <key>CFBundleIdentifier</key><string>fr.perso.chrono</string>
  <key>CFBundleExecutable</key><string>Chrono</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleVersion</key><string>1.0</string>
  <key>LSUIElement</key><true/>
</dict>
</plist>
PLIST

rm -rf "$TMP"
pkill -x Chrono 2>/dev/null || true
open "$APP"
echo ""
echo "✅ C'est fait ! Le chronomètre est dans ta barre des menus, en haut."
echo "   Pour le placer à côté du logo Claude : maintiens ⌘ (Cmd) et fais-le glisser."
