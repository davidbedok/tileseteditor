create-dmg \
  --volname "Yet Another TileSet Editor" \
  --volicon "yate-512.png" \
  --background "background.png" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "tileseteditor.app" 200 190 \
  --hide-extension "tileseteditor.app" \
  --app-drop-link 600 185 \
  --codesign "XYZ" \
  "YATE-Installer.dmg" \
  "../../application/build/macos/Build/Products/Release/tileseteditor.app"