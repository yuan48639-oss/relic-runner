# Relic Runner Production Roadmap

## Current Direction

Relic Runner is a small 2D action-platformer. The player is the Dawn Gate Courier, entering ancient ruins that rearrange themselves before sunrise, searching for the Dawnlight Core, and using expedition coins to strengthen the next run.

## 1.0 Goals

- Deliver roughly two hours of single-player 1.0 content.
- Expand the current route to 40 levels, 4 regions, and 4 bosses.
- Keep and polish prototype enemy types: patrol, flyer, shield soldier, crawler, and boss enemies.
- Keep and polish the home hub, persistent coins, permanent equipment, backpack potions, and Dawnlight Core max-health upgrades.
- Keep save/load, Chinese/English UI, volume settings, and the foundation for `Windows` export.
- Future work should focus less on adding raw features and more on stabilizing flow, improving feel, and replacing temporary art and sound.

## Milestones

1. Stable architecture: keep levels data-driven, continue splitting the main script, and strengthen boundaries around home, death, revive, clear, and save logic.
2. Content tuning: checkpoints, keys, moving platforms, brittle floors, dash, flyers, shield soldiers, crawlers, and bosses already exist; the next focus is pacing and difficulty curve.
3. Presentation upgrade: replace rectangles and temporary tones with licensed tilesets, character animation, enemy animation, UI icons, fonts, sound effects, and music.
4. Steam demo: run 5-10 playtests, fix feedback, capture real screenshots and short videos, and submit for Steam review.
5. LAN prototype: keep it internal until host-authoritative synchronization is stable enough to consider public exposure.

## Story Beats

- Home hub: Dawn Gate camp at the edge of town. The player buys equipment, upgrades health, manages the backpack, and enters the ruins.
- Ruin entrance: teaches movement, jumping, attacking, and coin collection.
- Spike corridor: teaches stomp rewards, spike punishment, and potion use.
- Dawn Gate hall: introduces ruin shops, key doors, and more complex enemy combinations.
- Boss room: defeat the Dawnlight Guard, earn Pyroblast, and reveal the skill system's potential.
- Underground Waterways: introduce moving platforms, waterway timing, and Tidal Wave.
- Broken Clocktower: introduce brittle platforms, vertical rhythm, and Clock Snare.
- Dawnlight Core Depths: combine all mechanics, defeat the final boss, earn Dawn Barrier, and complete the ending.

## Near-Term Priorities

- Polish coin drop, magnet, pickup sounds, and value settlement until stable.
- Make purchased equipment changes more visible and tactile on the character.
- Strengthen the imp-like monster style with anticipation, hit reaction, and death feedback.
- Add polished icons for backpack, equipment, skill list, shop, and Dawnlight Core UI.
- Prepare a final art replacement pipeline so every icon and sprite can be swapped without rewriting gameplay logic.
- Connect the Godot CLI or editor path to the validation flow so `tools/validate_project.py` and Godot script checks can both run.
