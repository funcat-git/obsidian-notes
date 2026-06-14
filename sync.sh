#!/data/data/com.termux/files/usr/bin/bash

# 自动定位 git 仓库根目录
REPO=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -z "$REPO" ]; then
  echo "❌ not inside a git repo, searching fallback..."

  # fallback：固定路径（防止 termux 环境问题）
  REPO="/storage/emulated/0/obsidian-notes"
fi

cd "$REPO" || exit 1

echo "📍 repo: $REPO"

echo "🔄 pull..."
git pull --rebase origin main

echo "📦 add..."
git add -A

git commit -m "auto sync $(date '+%F %T')" || echo "ℹ️ no changes"

echo "🚀 push..."
git push origin main

echo "✅ done"
