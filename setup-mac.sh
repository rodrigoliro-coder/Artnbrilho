#!/bin/bash
# setup-mac.sh — Configura o app Artnbrilho no seu Mac
set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   Artnbrilho — Setup para macOS      ║"
echo "╚══════════════════════════════════════╝"
echo ""

# verifica Node.js
if ! command -v node &> /dev/null; then
  echo "❌ Node.js não encontrado."
  echo "   Instale em: https://nodejs.org  (versão LTS recomendada)"
  echo "   Ou via Homebrew: brew install node"
  exit 1
fi

echo "✅ Node.js $(node --version) encontrado"
echo ""

# instala dependências do Electron
echo "📦 Instalando dependências..."
cd "$(dirname "$0")/electron"
npm install --silent

echo ""
echo "✅ Tudo pronto! Escolha o que fazer:"
echo ""
echo "  1) Rodar o app agora (janela abre imediatamente):"
echo "     npm start"
echo ""
echo "  2) Gerar o .app para instalar em /Applications:"
echo "     npm run build"
echo "     (o arquivo fica em electron/dist/)"
echo ""

read -p "Deseja abrir o app agora? (s/n): " resp
if [[ "$resp" =~ ^[Ss]$ ]]; then
  echo ""
  echo "🚀 Abrindo Artnbrilho..."
  npm start
fi
