#!/bin/sh
## Splits an image into small tiles vertically (usage example: a screenshot of a single line of monospaced text is split into the (equally wide) characters.)
convert -crop 40x60 LiberationMono_Line1_40_60.png %d.png