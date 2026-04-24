#!/usr/bin/env python3
"""Resize AI-generated icon to all iOS sizes"""
from PIL import Image
import os

SIZES = [
    ('Icon-20@1x.png', 20),
    ('Icon-20@2x.png', 40),
    ('Icon-20@3x.png', 60),
    ('Icon-29@1x.png', 29),
    ('Icon-29@2x.png', 58),
    ('Icon-29@3x.png', 87),
    ('Icon-40@1x.png', 40),
    ('Icon-40@2x.png', 80),
    ('Icon-40@3x.png', 120),
    ('Icon-60@2x.png', 120),
    ('Icon-60@3x.png', 180),
    ('Icon-76@1x.png', 76),
    ('Icon-76@2x.png', 152),
    ('Icon-83.5@2x.png', 167),
    ('Icon-1024@1x.png', 1024),
]

source = '/Users/user291981/Desktop/ios-UstiaGo/Assets/AI_Generated_Icons/UstiaGo_icon_v2.png'
output_dir = '/Users/user291981/Desktop/ios-UstiaGo/Assets/AppIcon.appiconset'

os.makedirs(output_dir, exist_ok=True)

img = Image.open(source)
print(f"Source: {img.size} {img.mode}")

for filename, size in SIZES:
    resized = img.resize((size, size), Image.LANCZOS)
    resized.save(f'{output_dir}/{filename}', 'PNG')
    print(f"  Created {filename}")

print(f"\nDone! {len(SIZES)} icons in {output_dir}")
