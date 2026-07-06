#!/usr/bin/env bash
printf "\e[?25l"
envf="$HOME/.config/waybar/scripts/.hl-env"
[ -f "$envf" ] && . "$envf"

resp=$(curl -s --max-time 8 -X POST https://api.hyperliquid.xyz/info \
  -H 'Content-Type: application/json' \
  -d "{\"type\":\"clearinghouseState\",\"user\":\"$HL_ADDRESS\"}")

orders=$(curl -s --max-time 8 -X POST https://api.hyperliquid.xyz/info \
  -H 'Content-Type: application/json' \
  -d "{\"type\":\"frontendOpenOrders\",\"user\":\"$HL_ADDRESS\"}")

mids=$(curl -s --max-time 8 -X POST https://api.hyperliquid.xyz/info \
  -H 'Content-Type: application/json' \
  -d '{"type":"allMids"}')

printf '\n  %-6s %8s %7s %7s %6s %6s %8s %7s\n' "TOKEN" "USDC" "PnL" "ROI" "LIQ" "SL" "PP" "FUND"
printf '  %s\n' "----------------------------------------------------------------"

jq -r --argjson orders "$orders" --argjson mids "$mids" '
  ($orders | map(select(.reduceOnly==true and .isTrigger==true)) | map({(.coin): .triggerPx}) | add // {}) as $stops |
  .assetPositions[].position |
  (.szi|tonumber) as $s |
  (.positionValue|tonumber) as $v |
  (.unrealizedPnl|tonumber) as $p |
  (.marginUsed|tonumber) as $margin |
  ((if $margin != 0 then ($p / $margin * 100) else 0 end)) as $roi |
  ((.cumFunding.sinceOpen // "0")|tonumber|-.) as $f |
  (.entryPx|tonumber) as $entry |
  ($mids[.coin] | tonumber) as $mark |
  (if .liquidationPx != null and .liquidationPx != ""
   then ((.liquidationPx|tonumber) as $liq
         | (($mark - $liq | if . < 0 then -. else . end) / $mark * 100))
   else null end) as $liq_dist |
  ($stops[.coin]) as $sl_str |
  (if $sl_str != null then ($sl_str|tonumber) else null end) as $sl |
  (if $sl != null
   then (($mark - $sl | if . < 0 then -. else . end) / $mark * 100)
   else null end) as $sl_dist |
  (if $sl != null then (($sl - $entry) * $s) else null end) as $sl_loss |
  [
    .coin,
    ((if $s<0 then -1 else 1 end)*$v),
    $p,
    ($roi*10|round/10),
    (if $liq_dist != null then ($liq_dist*10|round/10) else "NA" end),
    (if $sl_dist  != null then ($sl_dist*10 |round/10) else "NA" end),
    (if $sl_loss  != null then $sl_loss                else "NA" end),
    $f
  ] | @tsv
' <<< "$resp" |
while IFS=$'\t' read -r c v p roi ld sd sl f; do
  roifmt=$(printf "%6.1f%%" "$roi")
  [ "$ld" = "NA" ] && liqfmt="  -"    || liqfmt=$(printf "%5.1f%%" "$ld")
  [ "$sd" = "NA" ] && slfmt="  NA"    || slfmt=$(printf  "%5.1f%%" "$sd")
  [ "$sl" = "NA" ] && lossfmt="      NA" || lossfmt=$(printf "%8.2f" "$sl")
  printf '  %-6s %8.2f %7.2f %7s %6s %6s %8s %7.2f\n' \
    "$c" "$v" "$p" "$roifmt" "$liqfmt" "$slfmt" "$lossfmt" "$f"
done
sleep infinity
