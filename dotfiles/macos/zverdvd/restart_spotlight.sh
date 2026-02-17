#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  exec sudo "$0" "$@"
fi

labels=(
  "system/com.apple.metadata.mds"
  "system/com.apple.metadata.mds.scan"
  "system/com.apple.metadata.mds.index"
)

echo "[1/5] Forcing indexing off first..."
mdutil -Ea -i off || true

echo "[2/5] Enabling Spotlight launch services..."
for label in "${labels[@]}"; do
  launchctl enable "$label" 2>/dev/null || true
done

echo "[3/5] Restarting Spotlight daemons..."
for label in "${labels[@]}"; do
  launchctl kickstart -k "$label" 2>/dev/null || true
done

echo "[4/5] Turning indexing on and rebuilding index..."
mdutil -Ea -i on || true
mdutil -Ea || true

echo "[5/5] Spotlight status:"
for volume in / /System/Volumes/Data; do
  if [[ -d "$volume" ]]; then
    mdutil -s "$volume" || true
  fi
done
