#!/bin/bash

URL="https://organiser.virtual.lontiotlabs.au/#Homepage"
SOCKET="/run/user/1000/wayland-0"

echo "Waiting for Wayland..."

while [ ! -S "$SOCKET" ]; do
    sleep 1
done

export WAYLAND_DISPLAY=wayland-0
export XDG_RUNTIME_DIR=/run/user/1000

echo "Waiting for website..."

until curl -fsS https://organiser.virtual.lontiotlabs.au >/dev/null; do
    sleep 5
done

echo "Starting Chromium kiosk"

exec /usr/bin/lwrespawn /usr/bin/chromium "$URL" \
    --kiosk \
    --ozone-platform=wayland \
    --force-device-scale-factor=0.75 \
    --no-sandbox \
    --disable-infobars \
    --disable-features=TranslateUIT