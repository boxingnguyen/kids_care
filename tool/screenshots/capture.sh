#!/usr/bin/env bash
# Capture App Store screenshots from the demo-data harness.
#   1. flutter build ios --simulator --debug -t tool/screenshots/screenshot_main.dart --dart-define-from-file=config/env.json
#   2. tool/screenshots/capture.sh <simulator-udid> <out-dir> [screen ...]
set -euo pipefail

UDID="$1"; OUT="$2"; shift 2
if [ $# -gt 0 ]; then SCREENS=("$@"); else
  SCREENS=(welcome parent-home parent-map parent-todo parent-notes child-home child-todo child-notes)
fi
BUNDLE=com.crosstechedu.kidscare
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
APP="$ROOT/build/ios/iphonesimulator/Runner.app"
WAIT="${WAIT:-9}"

mkdir -p "$OUT"
xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl bootstatus "$UDID" >/dev/null
xcrun simctl install "$UDID" "$APP"
xcrun simctl privacy "$UDID" grant location-always "$BUNDLE" || true
xcrun simctl location "$UDID" set 10.7778,106.7001
xcrun simctl status_bar "$UDID" override --time 9:41 --dataNetwork wifi --wifiMode active \
  --wifiBars 3 --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100

DATA="$(xcrun simctl get_app_container "$UDID" "$BUNDLE" data)"
i=1
for s in "${SCREENS[@]}"; do
  xcrun simctl terminate "$UDID" "$BUNDLE" 2>/dev/null || true
  mkdir -p "$DATA/tmp" && printf '%s' "$s" > "$DATA/tmp/shot_screen.txt"
  xcrun simctl launch "$UDID" "$BUNDLE" >/dev/null
  sleep "$WAIT"
  f="$OUT/$(printf '%02d' $i)_$s.png"
  xcrun simctl io "$UDID" screenshot "$f" >/dev/null 2>&1
  echo "$f"
  i=$((i+1))
done
xcrun simctl terminate "$UDID" "$BUNDLE" 2>/dev/null || true
