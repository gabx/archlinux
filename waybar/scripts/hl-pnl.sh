#!/usr/bin/env bash
envf="$HOME/.config/waybar/scripts/.hl-env"
[ -f "$envf" ] && . "$envf"
fail(){ printf '{"text":"PnL --"}\n'; exit 0; }
[ -n "${HL_ADDRESS:-}" ] || fail

resp=$(curl -s --max-time 8 -X POST https://api.hyperliquid.xyz/info \
  -H 'Content-Type: application/json' \
  -d "{\"type\":\"clearinghouseState\",\"user\":\"$HL_ADDRESS\"}")
printf '%s' "$resp" | jq -e . >/dev/null 2>&1 || fail

sum=$(printf '%s' "$resp" | jq '[.assetPositions[].position.unrealizedPnl|tonumber]|add // 0')
col=$(awk -v x="$sum" 'BEGIN{print (x>0)?"#3fae5a":(x<0)?"#e05265":"#c1d2e2"}')
txt=$(awk -v x="$sum" 'BEGIN{printf "%+.2f", x}')
jq -cn --arg t "$txt" --arg col "$col" '{text:("<span color=\"\($col)\">\($t)</span>")}'
