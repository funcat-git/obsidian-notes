#!/data/data/com.termux/files/usr/bin/bash

cd /storage/emulated/0/sec/sec || exit

echo "🔄 start sync..."

git add .

git commit -m "auto sync $(date '+%Y-%m-%d %H:%M:%S')" || true

git pull --rebase origin main || {
  echo "⚠️ pull failed, abort rebase"
  git rebase --abort
}

git push origin main || {
  echo "❌ push failed"
}

echo "✅ done"
