#!/usr/bin/env bash
cls="hl-pnl-box"
render="$HOME/.config/waybar/scripts/hl-pnl-render.sh"
bw=860; bh=260; margin=8   # largeur, hauteur de la box, marge

# Toggle : fermer si déjà ouverte
pid=$(hyprctl clients -j | jq -r --arg c "$cls" '.[]|select(.class==$c)|.pid' | head -1)
if [ -n "$pid" ] && [ "$pid" != "null" ]; then kill "$pid" 2>/dev/null; exit 0; fi

# Position = coin haut-droit du moniteur ACTUELLEMENT focus
read -r mx mw my bar < <(hyprctl monitors -j | jq -r '
  .[] | select(.focused==true) | "\(.x) \(.width) \(.y) \(.reserved[1])"')
[ -z "$mx" ] && { mx=0; mw=1920; my=0; bar=30; }
px=$(( mx + mw - bw - margin ))
py=$(( my + bar + margin ))

# Ouvrir
kitty --class "$cls" --title "Positions HL" \
  -o background="#1e2b36" -o font_family="InconsolataGo Nerd Font Mono Bold" \
  bash -lc "$render" &

# Attendre l'apparition, puis flotter + dimensionner + placer
for i in $(seq 1 20); do
  hyprctl clients -j | jq -e --arg c "$cls" '.[]|select(.class==$c)' >/dev/null 2>&1 && break
  sleep 0.05
done
sleep 0.05
