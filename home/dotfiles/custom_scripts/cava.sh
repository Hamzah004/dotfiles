#!/usr/bin/env bash
set -euo pipefail

# Bars (0 → 7)
BARS=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

# Colors (low → high) - Catppuccin Mocha
COLORS=(
  "#89b4fa"  # blue
  "#74c7ec"  # cyan
  "#a6e3a1"  # green
  "#f9e2af"  # yellow
  "#fab387"  # orange
  "#f38ba8"  # red
  "#cba6f7"  # purple
  "#bac2de"  # lavender
)

CONFIG_FILE="$(mktemp)"
trap 'rm -f "$CONFIG_FILE"' EXIT

cat > "$CONFIG_FILE" <<EOF
[general]
bars = 18
framerate = 60

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

cava -p "$CONFIG_FILE" | while IFS= read -r line; do
    output=""
    for (( i=0; i<${#line}; i++ )); do
        ch="${line:i:1}"
        [[ "$ch" == ";" ]] && continue
        output+="<span foreground=\"${COLORS[$ch]}\">${BARS[$ch]}</span>"
    done
    printf '%s\n' "$output"
done
