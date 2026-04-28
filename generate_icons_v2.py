#!/usr/bin/env python3
"""
Professional iOS App Icon Generator v2
Fast, beautiful icons with gradients and 3D effects
"""
from PIL import Image, ImageDraw, ImageFilter
import os
import math

def hex_to_rgb(hex_color):
    """Convert hex to RGB tuple"""
    h = hex_color.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def create_rounded_mask(size, radius):
    """Create a rounded rectangle mask efficiently"""
    mask = Image.new('L', (size, size), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle([0, 0, size-1, size-1], radius=radius, fill=255)
    return mask

def gradient_linear(size, color1, color2, direction='vertical'):
    """Create linear gradient"""
    img = Image.new('RGB', (size, size))
    draw = ImageDraw.Draw(img)
    
    if direction == 'vertical':
        for y in range(size):
            ratio = y / (size - 1)
            r = int(color1[0] + (color2[0] - color1[0]) * ratio)
            g = int(color1[1] + (color2[1] - color1[1]) * ratio)
            b = int(color1[2] + (color2[2] - color1[2]) * ratio)
            draw.line([(0, y), (size-1, y)], fill=(r, g, b))
    else:  # horizontal
        for x in range(size):
            ratio = x / (size - 1)
            r = int(color1[0] + (color2[0] - color1[0]) * ratio)
            g = int(color1[1] + (color2[1] - color1[1]) * ratio)
            b = int(color1[2] + (color2[2] - color1[2]) * ratio)
            draw.line([(x, 0), (x, size-1)], fill=(r, g, b))
    
    return img

def gradient_radial(size, inner_color, outer_color):
    """Create radial gradient efficiently"""
    img = Image.new('RGB', (size, size))
    draw = ImageDraw.Draw(img)
    cx = cy = size // 2
    max_r = size * 0.7
    
    for y in range(size):
        for x in range(size):
            dist = math.sqrt((x - cx)**2 + (y - cy)**2)
            ratio = min(dist / max_r, 1.0)
            r = int(inner_color[0] + (outer_color[0] - inner_color[0]) * ratio)
            g = int(inner_color[1] + (outer_color[1] - inner_color[1]) * ratio)
            b = int(inner_color[2] + (outer_color[2] - inner_color[2]) * ratio)
            img.putpixel((x, y), (r, g, b))
    
    return img

def add_shadow(size, radius, offset=6, alpha=50):
    """Add soft drop shadow"""
    shadow = Image.new('RGBA', (size + offset*2, size + offset*2), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_draw.rounded_rectangle([offset, offset, size + offset - 1, size + offset - 1],
                                   radius=radius, fill=(0, 0, 0, alpha))
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=offset//2))
    return shadow

def add_gloss_highlight(size, radius, intensity=0.25):
    """Add glossy top highlight"""
    overlay = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    
    highlight_h = int(size * 0.35)
    for y in range(highlight_h):
        local_y = y / highlight_h
        # Elliptical falloff
        width_factor = math.sqrt(max(0, 1 - (local_y - 0.3)**2 * 3))
        current_w = int(size * 0.9 * width_factor)
        if current_w > 0:
            x1 = (size - current_w) // 2
            x2 = x1 + current_w
            alpha = int(255 * intensity * (1 - local_y))
            if alpha > 0:
                draw.line([(x1, y), (x2, y)], fill=(255, 255, 255, alpha))
    
    return overlay

def draw_clock(size):
    """Draw clock icon elements"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    cx, cy = size // 2, size // 2
    
    # Clock face
    face_r = int(size * 0.3)
    face_inner = int(size * 0.24)
    
    # Outer white ring with shadow
    draw.ellipse([cx - face_r, cy - face_r, cx + face_r, cy + face_r],
                 fill=(255, 255, 255, 250))
    
    # Inner face gradient (subtle)
    for r in range(face_inner, face_r):
        ratio = (face_r - r) / (face_r - face_inner)
        gray = int(200 + 55 * ratio)
        alpha = int(200 * ratio)
        draw.ellipse([cx - r, cy - r, cx + r, cy + r],
                     outline=(gray, gray, gray, alpha))
    
    # Hour markers
    marker_r = max(1, size // 50)
    for angle_deg in [0, 90, 180, 270]:
        rad = math.radians(angle_deg - 90)
        mx = int(cx + (face_r - size//25) * math.cos(rad))
        my = int(cy + (face_r - size//25) * math.sin(rad))
        draw.ellipse([mx - marker_r, my - marker_r, mx + marker_r, my + marker_r],
                     fill=(100, 110, 140))
    
    # Hour hand (pointing ~10 o'clock)
    hour_angle = math.radians(300)
    hour_len = int(face_inner * 0.5)
    hx = int(cx + hour_len * math.cos(hour_angle))
    hy = int(cy + hour_len * math.sin(hour_angle))
    line_w = max(2, size // 22)
    draw.line([cx, cy, hx, hy], fill=(50, 50, 70), width=line_w)
    
    # Minute hand (pointing ~2 o'clock)
    min_angle = math.radians(60)
    min_len = int(face_inner * 0.7)
    mx = int(cx + min_len * math.cos(min_angle))
    my = int(cy + min_len * math.sin(min_angle))
    draw.line([cx, cy, mx, my], fill=(66, 133, 244, 255), width=max(2, size//28))
    
    # Second hand (red accent)
    sec_angle = math.radians(90)
    sec_len = int(face_inner * 0.85)
    sx = int(cx + sec_len * math.cos(sec_angle))
    sy = int(cy + sec_len * math.sin(sec_angle))
    draw.line([cx, cy, sx, sy], fill=(220, 50, 50), width=max(1, size//60))
    
    # Center cap
    cap_r = max(2, size // 20)
    draw.ellipse([cx - cap_r, cy - cap_r, cx + cap_r, cy + cap_r],
                 fill=(220, 50, 50))
    
    return img

def draw_shield(size):
    """Draw shield icon elements"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    cx, cy = size // 2, size // 2
    
    sw = int(size * 0.55)  # shield width
    sh = int(size * 0.65)  # shield height
    
    # Shield body points
    top = cy - sh // 2
    left = cx - sw // 2
    right = cx + sw // 2
    bottom = cy + sh // 2
    
    # Shield path with curves
    pts = [
        (left + sw//4, top),                      # top-left start
        (right - sw//4, top),                     # top-right start
        (right - sw//5, top + sh//6),             # top-right curve
        (right, top + sh//3),                      # right upper
        (right, bottom - sh//4),                   # right lower
        (cx, bottom),                              # bottom point
        (left, bottom - sh//4),                    # left lower
        (left, top + sh//3),                      # left upper
        (left + sw//5, top + sh//6),              # top-left curve
    ]
    
    # Draw shield layers (outer, middle, inner)
    # Outer shadow
    offset_pts = [(p[0] + 3, p[1] + 4) for p in pts]
    draw.polygon(offset_pts, fill=(0, 0, 0, 40))
    
    # Main shield
    draw.polygon(pts, fill=(70, 50, 130))
    
    # Inner shield highlight
    inner_pad = sw // 7
    inner_pts = [(p[0] + inner_pad if p[0] < cx else p[0] - inner_pad, 
                  p[1] + inner_pad if i > 4 else p[1]) 
                 for i, p in enumerate(pts)]
    draw.polygon(inner_pts, fill=(100, 80, 170))
    
    # Eye symbol
    eye_w = sw // 2
    eye_h = eye_w // 3
    eye_top = cy - eye_h // 2
    
    # Eye white
    draw.ellipse([cx - eye_w//2, eye_top, cx + eye_w//2, eye_top + eye_h],
                 fill=(255, 255, 255))
    
    # Pupil
    pupil_r = eye_w // 5
    draw.ellipse([cx - pupil_r, cy - pupil_r, cx + pupil_r, cy + pupil_r],
                 fill=(30, 30, 60))
    
    # Highlight
    hl_r = pupil_r // 2
    draw.ellipse([cx + pupil_r//3, cy - pupil_r,
                  cx + pupil_r//3 + hl_r, cy - pupil_r + hl_r],
                 fill=(255, 255, 255))
    
    return img

def create_icon(size, style='clock', colors=None):
    """Create complete app icon"""
    if colors is None:
        colors = {
            'top': (52, 101, 195),
            'bottom': (26, 35, 126),
            'accent': (66, 133, 244)
        }
    
    corner_radius = size // 5
    
    # 1. Create gradient background
    bg = gradient_linear(size, colors['top'], colors['bottom'], 'vertical')
    
    # 2. Apply rounded mask
    mask = create_rounded_mask(size, corner_radius)
    bg_rounded = Image.new('RGBA', (size, size))
    bg_rounded.paste(bg, (0, 0))
    bg_rounded.putalpha(mask)
    
    # 3. Add shadow
    shadow = add_shadow(size, corner_radius, offset=size//25, alpha=45)
    shadowed = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    shadowed.paste(bg_rounded, (0, 0), bg_rounded)
    # Paste shadow behind
    shadowed.paste(shadow, (-size//25*2, -size//25*2), shadow)
    # Re-paste rounded rect on top
    shadowed.paste(bg_rounded, (0, 0), bg_rounded)
    
    # 4. Add center element
    if style == 'clock':
        center_img = draw_clock(size)
    elif style == 'shield':
        center_img = draw_shield(size)
    else:
        center_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    
    # Composite center element
    result = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    result.paste(shadowed, (0, 0), shadowed)
    result.paste(center_img, (0, 0), center_img)
    
    # 5. Add glossy highlight
    gloss = add_gloss_highlight(size, corner_radius, intensity=0.2)
    for x in range(size):
        for y in range(size):
            p = gloss.getpixel((x, y))
            if p[3] > 0:
                existing = result.getpixel((x, y))
                if existing[3] > 0:
                    # Alpha blend
                    src_alpha = p[3] / 255
                    new_r = int(p[0] * src_alpha + existing[0] * (1 - src_alpha))
                    new_g = int(p[1] * src_alpha + existing[1] * (1 - src_alpha))
                    new_b = int(p[2] * src_alpha + existing[2] * (1 - src_alpha))
                    result.putpixel((x, y), (new_r, new_g, new_b, 255))
    
    return result

def generate_icons(target_dir, style='clock', colors=None):
    """Generate all icon sizes"""
    os.makedirs(target_dir, exist_ok=True)
    
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
        (120, 'Icon-60@2x.png'),
        (180, 'Icon-60@3x.png'),
        (1024, 'Icon-1024@1x.png'),
    ]
    
    if colors is None:
        if style == 'shield':
            colors = {'top': (103, 58, 183), 'bottom': (48, 27, 110), 'accent': (255, 215, 0)}
        elif style == 'flame':
            colors = {'top': (255, 120, 50), 'bottom': (180, 30, 20), 'accent': (255, 220, 50)}
        else:
            colors = {'top': (52, 101, 195), 'bottom': (26, 35, 126), 'accent': (66, 133, 244)}
    
    print(f"Generating {style} icons to {target_dir}/")
    print(f"Colors: {colors}")
    print()
    
    for size, filename in sizes:
        print(f"  {filename} ({size}x{size})...", end=" ", flush=True)
        img = create_icon(size, style, colors)
        img.save(f'{target_dir}/{filename}', 'PNG')
        print("✓")
    
    print(f"\nDone! {len(sizes)} icons created.")

if __name__ == "__main__":
    import sys
    
    target_dir = sys.argv[1] if len(sys.argv) > 1 else 'Assets/AppIcon.appiconset'
    style = sys.argv[2] if len(sys.argv) > 2 else 'clock'
    
    generate_icons(target_dir, style)
