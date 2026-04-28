#!/usr/bin/env python3
"""
Resize AI-generated 1024x1024 icon to all required iOS icon sizes.
Usage: python3 resize_icons.py <source_icon.png> <output_dir>
"""
from PIL import Image
import os
import sys

# iOS icon sizes required
ICON_SIZES = [
    ("Icon-20@1x.png", 20),
    ("Icon-20@2x.png", 40),
    ("Icon-20@3x.png", 60),
    ("Icon-29@1x.png", 29),
    ("Icon-29@2x.png", 58),
    ("Icon-29@3x.png", 87),
    ("Icon-40@1x.png", 40),
    ("Icon-40@2x.png", 80),
    ("Icon-40@3x.png", 120),
    ("Icon-60@2x.png", 120),
    ("Icon-60@3x.png", 180),
    ("Icon-76@1x.png", 76),
    ("Icon-76@2x.png", 152),
    ("Icon-83.5@2x.png", 167),
    ("Icon-1024@1x.png", 1024),
]

def resize_icon(source_path, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    
    img = Image.open(source_path)
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    basename = os.path.splitext(os.path.basename(source_path))[0]
    
    for filename, size in ICON_SIZES:
        resized = img.resize((size, size), Image.LANCZOS)
        output_path = os.path.join(output_dir, filename)
        resized.save(output_path, 'PNG')
        print(f"  Created {filename} ({size}x{size})")
    
    print(f"\nAll icons saved to: {output_dir}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 resize_icons.py <source_icon.png> <output_dir>")
        sys.exit(1)
    
    source = sys.argv[1]
    output = sys.argv[2]
    
    print(f"Resizing: {source}")
    print(f"Output: {output}")
    print()
    resize_icon(source, output)
