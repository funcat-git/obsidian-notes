#!/data/data/com.termux/files/usr/bin/bash

cd /storage/emulated/0/sec/sec

git add .

git commit -m "auto sync $(date '+%Y-%m-%d %H:%M:%S')" || true

git pull --rebase origin main || true

git push origin main
