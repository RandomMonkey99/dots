#!/bin/bash

CACHE="$HOME/.cache/waybar-mpris-art"
mkdir -p "$CACHE"

url=$(playerctl metadata mpris:artUrl 2>/dev/null)

if [[ -z "$url" ]]; then
    rm -f "$CACHE/art.png"
    exit 0
fi

case "$url" in
    file://*)
        cp "${url#file://}" "$CACHE/art.png"
        ;;
    http://*|https://*)
        curl -sL "$url" -o "$CACHE/art.png"
        ;;
esac

echo "$CACHE/art.png"
