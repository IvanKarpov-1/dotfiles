#!/usr/bin/env bash

# Predefined colors (name -> "R G B")
declare -A colors=(
  [adwaita]="147 192 234"
  [black]="79 79 79"
  [blue]="82 148 226"
  [bluegrey]="96 125 139"
  [breeze]="87 184 236"
  [brown]="174 142 108"
  [carmine]="163 0 2"
  [cyan]="0 188 212"
  [darkcyan]="69 171 183"
  [deeporange]="235 102 55"
  [green]="135 177 88"
  [grey]="142 142 142"
  [indigo]="92 107 192"
  [magenta]="202 113 223"
  [nordic]="129 161 193"
  [orange]="238 146 58"
  [palebrown]="209 191 174"
  [paleorange]="238 202 143"
  [pink]="240 98 146"
  [red]="226 82 82"
  [teal]="22 160 133"
  [violet]="126 87 194"
  [white]="228 228 228"
  [yaru]="103 103 103"
  [yellow]="249 189 48"
)


if [ $# -lt 1 ]; then
    echo "Usage: $0 <hexcolor>  (examples: #416835, 416835, #416835FF)"
    exit 1
fi

input_hex="$1"

# Normalize input: strip leading '#' and keep only first 6 hex digits (ignore alpha if present)
hex=$(echo "$input_hex" | sed -E 's/^#//; s/[^0-9a-fA-F].*//; s/^(.{6}).*/\1/')

if ! [[ "$hex" =~ ^[0-9a-fA-F]{6}$ ]]; then
    echo "Invalid hex color: '$input_hex'"
    exit 2
fi

# Use ImageMagick to get an srgb string "srgb(R,G,B)"
# 'txt:-' prints human-readable pixel enumeration, we extract the srgb(...) part.
srgb_raw=$(magick -size 1x1 "xc:#$hex" txt:- 2>/dev/null | grep -o 'srgb([^)]*)' || true)

if [ -z "$srgb_raw" ]; then
    # fallback: try 'convert' (older ImageMagick)
    srgb_raw=$(convert -size 1x1 "xc:#$hex" txt:- 2>/dev/null | grep -o 'srgb([^)]*)' || true)
fi

if [ -z "$srgb_raw" ]; then
    echo "ImageMagick did not return srgb(...) for #$hex"
    exit 3
fi

# srgb_raw looks like: srgb(65,104,53)
# convert commas to spaces and strip text
target_rgb=$(echo "$srgb_raw" | sed -e 's/srgb(//' -e 's/)//' -e 's/,/ /g')

# Build a small input for Python: first line is target RGB, then palette lines
python_input="$(echo "$target_rgb")"
for k in "${!colors[@]}"; do
    python_input="$python_input"$'\n'"$k ${colors[$k]}"
done

# Call Python once to convert to Lab and compute closest match (ΔE CIE76)
best=$(python3 - <<'PY' "$python_input"
import sys
from math import pow, sqrt

data = sys.argv[1] if len(sys.argv)>1 else sys.stdin.read()
# If provided via argv (we passed as argument), use that; otherwise read stdin
if len(sys.argv) > 1 and '\n' in sys.argv[1]:
    txt = sys.argv[1]
else:
    txt = sys.stdin.read() if len(sys.argv)==1 else '\n'.join(sys.argv[1:])

lines = [line.strip() for line in txt.splitlines() if line.strip()]
# first line: target rgb
tr, tg, tb = map(int, lines[0].split())

palette = []
for ln in lines[1:]:
    parts = ln.split()
    name = parts[0]
    r,g,b = map(int, parts[1:4])
    palette.append((name, r, g, b))

# RGB -> linear RGB -> XYZ -> Lab conversion (D65)
def srgb_to_lin(v):
    v = v / 255.0
    if v <= 0.04045:
        return v / 12.92
    return pow((v + 0.055) / 1.055, 2.4)

def rgb_to_xyz(r,g,b):
    r_lin = srgb_to_lin(r)
    g_lin = srgb_to_lin(g)
    b_lin = srgb_to_lin(b)
    # sRGB D65
    X = r_lin * 0.4124564 + g_lin * 0.3575761 + b_lin * 0.1804375
    Y = r_lin * 0.2126729 + g_lin * 0.7151522 + b_lin * 0.0721750
    Z = r_lin * 0.0193339 + g_lin * 0.1191920 + b_lin * 0.9503041
    return X, Y, Z

def f_lab(t):
    if t > 0.008856:
        return pow(t, 1.0/3.0)
    return (7.787 * t) + (16.0/116.0)

def xyz_to_lab(X, Y, Z):
    # reference white D65
    Xn = 0.95047
    Yn = 1.00000
    Zn = 1.08883
    fx = f_lab(X / Xn)
    fy = f_lab(Y / Yn)
    fz = f_lab(Z / Zn)
    L = 116.0 * fy - 16.0
    a = 500.0 * (fx - fy)
    b = 200.0 * (fy - fz)
    return L, a, b

def rgb_to_lab(r,g,b):
    X,Y,Z = rgb_to_xyz(r,g,b)
    return xyz_to_lab(X,Y,Z)

tL, ta, tb_lab = rgb_to_lab(tr, tg, tb)

best = None
best_dist = None
all_results = []

for name, r, g, b in palette:
    L, a, b2 = rgb_to_lab(r,g,b)
    # CIE76 Euclidean in Lab
    d = sqrt((tL - L)**2 + (ta - a)**2 + (tb_lab - b2)**2)
    all_results.append((d, name, r, g, b))

all_results.sort(key=lambda x: x[0])

top = all_results[:1]

print(f"{top[0][1]}")
PY

exit 0)

~/.local/bin/papirus-folders -C $best
