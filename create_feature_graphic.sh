#!/bin/bash

# Create feature graphic with the new logo
cd "/Users/vigowalker/Chipa SSID Finder"

# Create a gradient background with the logo
magick -size 1024x500 gradient:'#6B46C1-#9333EA' \
  \( new_logo.png -resize 280x420 \) \
  -gravity west -geometry +60+0 -composite \
  -font Arial -pointsize 56 -fill white -gravity center \
  -annotate +200-60 'Chipa SSID Finder' \
  -font Arial -pointsize 28 -fill '#E0E7FF' \
  -annotate +200+20 'Extract session tokens from trading platforms' \
  -font Arial -pointsize 22 -fill white \
  -annotate +200+80 '✓ 8 Trading Platforms  ✓ Secure  ✓ Private' \
  feature_graphic_1024x500.png

echo "Feature graphic created!"
