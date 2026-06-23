#!/usr/bin/env bash
data=$(curl -sf "https://api.binance.com/api/v3/ticker/24hr?symbol=BTCUSD")
if [ -z "$data" ]; then
  echo '{"text":"₿ --","class":"down","tooltip":"no data"}'
  exit 0
fi
echo "$data" | jq -c '{
  text: ("₿ " + (.lastPrice|tonumber|floor|tostring)),
  class: (if (.priceChangePercent|tonumber) >= 0 then "up" else "down" end),
  tooltip: ("24h: " + .priceChangePercent + "%")
}'
