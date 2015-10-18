## Splits an image into small tiles vertically (usage example: a screenshot of a single line of monospaced text is split into the (equally wide) characters.)

SRCIMG="$1"

if [ -z "$1" ]; then
  echo "split_image -- split an image into tiles."
  echo "USAGE: $0 <image file>";
  exit 1
fi

convert -crop 40x60 LiberationMono_Line1_40_60.png %d.png