#!/bin/bash
# ──────────────────────────────────────────────────────────────
#  Artnbrilho — Cria um aplicativo nativo para macOS
#  SEM Electron, SEM downloads, SEM Node. Usa só o Chrome/Edge/Brave
#  que já está instalado e comandos nativos do macOS.
# ──────────────────────────────────────────────────────────────
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HTML_SRC="$REPO_DIR/index.html"
APP_DIR="$HOME/Desktop/Artnbrilho.app"

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║   Artnbrilho — Criar aplicativo para macOS   ║"
echo "╚════════════════════════════════════════════╝"
echo ""

if [ ! -f "$HTML_SRC" ]; then
  echo "❌ Não encontrei o index.html em: $REPO_DIR"
  echo "   Rode este script de dentro da pasta do projeto."
  exit 1
fi

# Remove versão anterior (se existir) e recria do zero
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Copia o sistema (HTML único) para dentro do aplicativo
cp "$HTML_SRC" "$APP_DIR/Contents/Resources/app.html"

# ── Info.plist (faz o macOS reconhecer a pasta como um app) ──
cat > "$APP_DIR/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>Artnbrilho</string>
  <key>CFBundleDisplayName</key><string>Artnbrilho</string>
  <key>CFBundleIdentifier</key><string>com.artnbrilho.app</string>
  <key>CFBundleVersion</key><string>1.0</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleExecutable</key><string>Artnbrilho</string>
  <key>LSMinimumSystemVersion</key><string>10.13</string>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST

# ── Launcher: abre o HTML em modo "app" (janela limpa, sem barra) ──
cat > "$APP_DIR/Contents/MacOS/Artnbrilho" <<'LAUNCH'
#!/bin/bash
DIR="$(cd "$(dirname "$0")/../Resources" && pwd)"
URL="file://$DIR/app.html"
PROFILE="$HOME/Library/Application Support/Artnbrilho"

# Procura um navegador baseado em Chromium e abre em modo aplicativo
for APP in "Google Chrome" "Microsoft Edge" "Brave Browser" "Chromium"; do
  if [ -d "/Applications/$APP.app" ]; then
    open -na "$APP" --args \
      --app="$URL" \
      --user-data-dir="$PROFILE" \
      --no-first-run --no-default-browser-check
    exit 0
  fi
done

# Nenhum navegador Chromium encontrado: abre no navegador padrão (Safari)
open "$URL"
LAUNCH

chmod +x "$APP_DIR/Contents/MacOS/Artnbrilho"

echo "✅ Aplicativo criado com sucesso!"
echo ""
echo "   📍 Local:  $APP_DIR"
echo ""
echo "Como usar:"
echo "   1) Dê dois cliques em \"Artnbrilho.app\" na sua Mesa (Desktop)."
echo "   2) Para instalar de vez: arraste-o para a pasta Aplicativos."
echo "   3) Para usar em outro Mac: arraste-o para o iCloud Drive."
echo ""
echo "Os dados (produtos, vendas, etc.) ficam salvos no app e persistem"
echo "entre aberturas. Para passar os dados a outro dispositivo, use"
echo "Minha Conta → Backup de Dados (Exportar / Importar)."
echo ""
