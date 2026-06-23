#!/usr/bin/env bash
coin="HYPE"

resp=$(curl -s -X POST https://api.hyperliquid.xyz/info \
  -H 'Content-Type: application/json' \
  -d '{"type":"metaAndAssetCtxs"}')

read -r mark prev < <(printf '%s' "$resp" | jq -r --arg c "$coin" '
  (.[0].universe | map(.name) | index($c)) as $i
  | .[1][$i] | "\(.markPx) \(.prevDayPx)"')

if [ -z "$mark" ] || [ "$mark" = "null" ]; then
  printf '{"text":"%s --","class":"down","tooltip":"Hyperliquid indisponible"}\n' "$coin"
  exit 0
fi

pct=$(awk -v m="$mark" -v p="$prev" 'BEGIN{ if(p>0) printf "%.2f",(m-p)/p*100; else print "0" }')
cls=$(awk -v x="$pct" 'BEGIN{ print (x>=0)?"up":"down" }')
price=$(awk -v m="$mark" 'BEGIN{ printf "%.2f", m }')

printf '{"text":"HYPE %s","class":"%s","tooltip":"HYPE %s$  (%s%% 24h)"}\n' "$price" "$cls" "$price" "$pct"
