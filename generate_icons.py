#!/usr/bin/env python3
from PIL import Image, ImageDraw
import os
import sys

# Target directory - support both old and new paths
target_dir = sys.argv[1] if len(sys.argv) > 1 else 'ios/UstiaGo/Assets.xcassets/AppIcon.appiconset'
os.makedirs(target_dir, exist_ok=True)

def create_icon(size, filename):
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    w, h = size, size
    
    # Deep blue/purple gradient background
    for y in range(h):
        ratio = y / h
        r = int(25 + (55 - 25) * ratio)
        g = int(25 + (35 - 25) * ratio)
        b = int(90 + (160 - 90) * ratio)
        draw.line([(0, y), (w, y)], fill=(r, g, b, 255))
    
    cx, cy = w // 2, h // 2
    
    # Clock face - outer ring (white)
    outer_r = int(min(w, h) * 0.38)
    draw.ellipse([cx - outer_r, cy - outer_r, cx + outer_r, cy + outer_r],
                 fill=None, outline=(255, 255, 255, 255), width=max(2, size // 18))
    
    # Clock face - inner fill (semi-transparent white)
    inner_r = int(outer_r * 0.85)
    draw.ellipse([cx - inner_r, cy - inner_r, cx + inner_r, cy + inner_r],
                 fill=(255, 255, 255, 220))
    
    # Hour markers - small dots at 12, 3, 6, 9 positions
    marker_r = max(1, size // 40)
    for angle in [0, 90, 180, 270]:
        import math
        rad = math.radians(angle - 90)
        mx = int(cx + (outer_r - marker_r * 2) * math.cos(rad))
        my = int(cy + (outer_r - marker_r * 2) * math.sin(rad))
        draw.ellipse([mx - marker_r, my - marker_r, mx + marker_r, my + marker_r],
                     fill=(255, 255, 255, 255))
    
    # Clock hands
    hand_color = (66, 133, 244, 255)  # Blue
    w_px = max(2, size // 16)
    
    # Hour hand (pointing ~10 o'clock)
    import math
    hour_angle = math.radians(300)  # 10 o'clock
    hour_len = int(outer_r * 0.5)
    hx = int(cx + hour_len * math.cos(hour_angle))
    hy = int(cy + hour_len * math.sin(hour_angle))
    draw.line([cx, cy, hx, hy], fill=(255, 255, 255, 255), width=w_px)
    
    # Minute hand (pointing ~2 o'clock)
    min_angle = math.radians(60)  # 2 o'clock
    min_len = int(outer_r * 0.7)
    mx2 = int(cx + min_len * math.cos(min_angle))
    my2 = int(cy + min_len * math.sin(min_angle))
    draw.line([cx, cy, mx2, my2], fill=(hand_color[0], hand_color[1], hand_color[2], 255), width=max(2, size // 20))
    
    # Center dot
    dot_r = max(2, size // 18)
    draw.ellipse([cx - dot_r, cy - dot_r, cx + dot_r, cy + dot_r],
                 fill=(255, 255, 255, 255))
    
    img.save(filename, 'PNG')

sizes = [
    (20, 'Icon-20@1x.png'),
    (40, 'Icon-20@2x.png'),
    (60, 'Icon-20@3x.png'),
    (29, 'Icon-29@1x.png'),
    (58, 'Icon-29@2x.png'),
    (87, 'Icon-29@3x.png'),
    (40, 'Icon-40@1x.png'),
    (80, 'Icon-40@2x.png'),
    (120, 'Icon-40@3x.png'),
    (76, 'Icon-76@1x.png'),
    (152, 'Icon-76@2x.png'),
    (167, 'Icon-83.5@2x.png'),
    (1024, 'Icon-1024@1x.png'),
]

for size, name in sizes:
    create_icon(size, f'{target_dir}/{name}')
    print(f'Created {name} ({size}x{size})')

print(f'\nAll {len(sizes)} icons generated in {target_dir}/')
