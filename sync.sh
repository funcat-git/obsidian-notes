#!/data/data/com.termux/files/usr/bin/bash

cd "$(dirname "$0")"

git add -A
git commit -m "auto sync $(date '+%F %T')" || true
git push origin main
