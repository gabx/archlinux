#!/usr/bin/env bash
declare -A map
while IFS='|' read -r desc name; do
  map["$desc"]="$name"
done < <(pactl list sinks | awk '
  /^Sink #/{n=""}
  /^[[:space:]]*Name:/{n=$2}
  /^[[:space:]]*Description:/{sub(/^[[:space:]]*Description:[[:space:]]*/,"");print $0"|"n}')

choice=$(printf '%s\n' "${!map[@]}" | fuzzel --dmenu --prompt 'Sortie audio: ')
[ -n "$choice" ] && pactl set-default-sink "${map[$choice]}"
