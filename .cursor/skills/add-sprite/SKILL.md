---
name: add-sprite
description: Adds a new sprite or animation frames from assets/images/spritesheet.png to SpriteUtil by locating its pixel coordinates. Use when the user wants a new sprite, image, button, digit, bird colour, pipe, or animation frame from the spritesheet.
---

# Add sprite

## When to use

- A component or overlay needs an image that isn't in `SpriteUtil` yet

## When not to use

- The sprite already exists in `lib/util/sprite_util.dart` — reuse it
- The image isn't on the spritesheet — ask the human for the asset first

## Instructions

1. **Check existing sprites** — Search `SpriteUtil` for a match before adding anything.
2. **Locate the sprite** — Open `assets/images/spritesheet.png` (Read the image) and find the region. Neighbouring entries in `SpriteUtil` are reliable reference points for nearby coordinates.
3. **Measure precisely** — Determine `x, y, width, height` in source pixels. If precise measurement is needed, use Python with Pillow to crop and check the bounding box:

```bash
python3 -c "from PIL import Image; im=Image.open('assets/images/spritesheet.png'); im.crop((x, y, x+w, y+h)).save('/tmp/sprite_check.png')"
```

   Then Read `/tmp/sprite_check.png` to confirm the crop is tight with no neighbouring pixels.
4. **Add to `SpriteUtil`** — Add a `static Sprite name = getSprite(x, y, w, h);` in the matching section (birds, pipes, digits, menu). Name it descriptively in camelCase. For animations, add numbered frames (`blueBird1`, `blueBird2`, `blueBird3`) like the existing birds.
5. **Use it** — Assign the sprite in a component's `onLoad` or in an overlay's `SpriteWidget`.
6. **Verify** — `flutter analyze`; tell the human which screen to check on the simulator.

## Failure behaviour

- If the region is ambiguous (multiple similar sprites), show the candidate crops and ask which one.
