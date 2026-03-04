#!/usr/bin/env bash

exit 0

set -euo pipefail

USER_ID="${1:-0}"

packages=(
  com.hihonor.popularapps
  com.hihonor.appmarket
  com.google.android.gms.location.history
  com.hihonor.assistant
  com.hihonor.brain
  com.hihonor.aipluginengine
  com.hihonor.magicvoice
  com.hihonor.airlink
  com.hihonor.android.instantshare
  com.hihonor.android.mirrorshare
  com.hihonor.crossdeviceserviceshare
  com.hihonor.handoff
  com.hihonor.koBackup
  com.hihonor.hncloud
  com.hihonor.contacts.sync
  com.google.android.projection.gearhead
  com.hihonor.android.thememanager
  com.hihonor.game.kitserver
  com.hihonor.mediamaterial
  com.huawei.appmarket
)

for pkg in "${packages[@]}"; do
  adb shell pm disable-user --user "$USER_ID" "$pkg"
done
