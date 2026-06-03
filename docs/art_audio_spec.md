# Art, Audio, And Font Specification

## Art Direction

- Overall style: clear, charming, tactile 2D side-scrolling action-platformer visuals. Pixel art or low-resolution hand-painted art is preferred.
- Base grid: use 32 px and 48 px modules so characters, enemies, terrain, and UI stay visually consistent.
- Palette: sandstone, bronze, dawn gold, cool ruin shadows, and readable danger red. Avoid letting the whole game collapse into one dominant color family.
- Readability first: platform edges, spikes, enemy attack ranges, exits, and interactables must be understandable at a glance.
- Reference direction: it is acceptable to study layering, background depth, and clean silhouettes from strong 2D exploration games, but do not copy commercial characters, monsters, icons, maps, or compositions.

## Required Art

- Player: idle, run, jump, fall, dash, attack, hurt, death, victory, and interact animations.
- Equipment appearance: short sword, long sword, dawn blade, boots, armor, and charms. Purchased and equipped gear should be visible on the character.
- Enemies: patrolling imp, flying eye, shield soldier, crawler, and multi-health bosses. Each enemy needs a clear silhouette, anticipation, and hit feedback.
- Environment: home hub, ruin level terrain, spikes, moving platforms, brittle platforms, keys, doors, switches, shop, Dawnlight Core, and expedition entrance.
- Drops and UI: coins, health hearts, potions, skill scrolls, backpack icons, equipment icons, health bar, coin counter, prompt buttons, language icon, and settings icon.
- Backgrounds: the home hub and levels need wider horizontal scenes, including sky layers, clouds, sunlight, distant mountains, ruin silhouettes, roads, grass, and foreground decoration.

## Current Placeholder Meaning

- Blue moving platform body: moving foothold. Extra blue guide rectangles should no longer appear.
- Blue checkpoint flag: removed from runtime for now; restore it after checkpoint art and rules are finalized.
- Gold door or flag: level exit.
- Red triangle: spike or danger mechanism.
- Green small bottle: health potion pickup.
- Player, monsters, weapon sweeps, and fire skills are still project-owned procedural placeholders with simple motion.

These placeholders are acceptable for internal testing, but final Steam screenshots and promotional videos should use either registered final assets or finished project-owned art.

## Sound Effects

- Required sounds: jump, land, dash, sword swing, sword hit, stomp kill, damage, coin drop, coin magnet, potion pickup, purchase, button confirm, death, clear, boss hit, and Pyroblast cast.
- Combat direction: sword swings need a clear blade sound; hits need stronger martial impact; coins need metallic collision and pickup movement.
- Audio buses: use `Master`, `Music`, `SFX`, and `UI` groups so volume settings do not interfere with each other.
- Current build: temporary generated tones are integrated for UI, coins, hits, potions, purchases, death, and clear events. Replace them with licensed sounds before final polish if needed.

## Music

- Main menu or home loop: warm and bright, emphasizing safety before an expedition.
- Ruin level loop: stronger rhythm suitable for repeated attempts.
- Danger or boss music: more tense, but never louder than impact sounds and UI prompts.

## Fonts

- Body UI fonts must support both Chinese and English. `Noto Sans SC` is the default candidate.
- Title fonts may use pixel or hand-drawn styles, but commercial-use permission must be verified.
- Register every font source, license, purpose, and download URL in the asset register.
