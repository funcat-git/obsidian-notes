#!/data/data/com.termux/files/usr/bin/bash

cd /storage/emulated/0/sec/sec || exit 1

echo "🔄 start sync..."

git add .

git diff --cached --quiet && {
  echo "ℹ️ no changes"
  exit 0
}

git commit -m "auto sync $(date '+%F %T')"

git pull --rebase origin main || {
  echo "⚠️ pull failed"
  git rebase --abort
  exit 1
}

git push origin main || {
  echo "❌ push failed"
  exit 1
}

echo "✅ done"
