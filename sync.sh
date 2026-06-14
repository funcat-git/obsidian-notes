#!/data/data/com.termux/files/usr/bin/bash

cd /storage/emulated/0/obsidian-notes || exit 1

echo "🔄 pulling latest..."
git pull --rebase origin main

echo "📦 adding changes..."
git add -A

git commit -m "auto sync $(date '+%F %T')" || echo "ℹ️ no changes"

echo "🚀 pushing..."
git push origin main

echo "✅ done"
