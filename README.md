# Relic Runner Demo

Relic Runner is a small Godot 4 2D action-platformer project. The target is to grow the current prototype into a Windows-first 1.0 game with roughly two hours of single-player content.

## Current Scope

- Engine: Godot 4.x
- Launch target: Windows
- Input: keyboard, mouse, and Xbox-compatible controllers
- Content: explorable home hub, 40 levels, 4 regions, 4 bosses, level shops, key doors, checkpoints, moving platforms, brittle platforms, spikes, coin drops, potions, equipment, and skill unlocks
- Equipment: potions, weapons, boots, armor, and charms; purchased gear changes the player's look or abilities
- Skills: Pyroblast, Tidal Wave, Clock Snare, and Dawn Barrier; press `O` to open the skill list, then use equipped skills with `K` / `L`
- Save data: `user://savegame.json` stores coins, max health, backpack contents, purchases, equipment, skills, and progress
- LAN: an internal prototype entry remains, but LAN play is not a 1.0 store commitment

## Local Run

1. Install Godot 4.x.
2. Open the `game/` directory in Godot.
3. Press Play. The main scene is `res://scenes/Main.tscn`.

The repository currently contains the project files and scripts. A final exported build has not been produced yet.

## Controls

- Move: `A/D`, arrow keys, left stick, or D-pad
- Jump / double jump: `Space`, `W`, up arrow, or controller A
- Dash: `Shift` or controller B
- Attack / interact: `J`, left mouse button, or controller X
- Use backpack potion: `Q` or `U`, or controller Y
- Open backpack / equipment: `I`
- Open skill list: `O`
- Cast equipped skills: `K`, `L`
- Pause: `Esc` or controller Start
- Restart current level: `R`
- Language: switch through the `Language` button

## Current Gameplay Rules

- The game starts in the home hub. Walk to a facility and press `J` or left click to interact.
- Home facilities include the shop, Dawnlight Core, backpack / equipment menu, expedition gate, and notice board / system menu.
- Each expedition starts from the current progress point. Clearing a level advances to the next level; clearing the final level returns to the home hub.
- When health reaches zero, the death notice lets the player return home or revive at a checkpoint for 100 coins.
- The release economy starts at 0 coins. Players buy equipment gradually by defeating enemies and exploring during expeditions.
- Stomping enemies awards 2 coins. Sword kills award 1 coin and have a 10% chance to drop a health potion.
- Each region boss drops one skill. After pickup, the skill can be equipped to `K` or `L`.
- Health potions normally restore 1 health. The Medic Charm makes potions restore 2 health and raises the sword-kill potion drop chance to 25%.
- Home shop prices: potion 6, long sword 18, swift boots 28, bronze armor 34, coin charm 40, medic charm 52, wing boots 68, dawn blade 82, anchor boots 110, storm sword 130, glass armor 145, dawn charm 165.

## Art And Fonts

- A runtime subset of Kenney CC0 assets is integrated under `game/assets/kenney/`.
- Player, enemies, bosses, coins, potions, keys, doors, flags, spikes, platforms, and region backgrounds use imported PNG assets where available.
- The UI font is Noto Sans CJK SC Regular under `game/assets/fonts/`, mainly to avoid broken Chinese glyphs in bilingual UI.
- Some procedural drawing remains for collision shapes and development fallbacks. Final release still needs stronger animation, music, and real build screenshots.

## Validation

```text
python tools/validate_project.py
```

The script validates 40 levels, 4 regions, 4 boss skill rewards, and the save version.

## Steam Preparation

Related checklists:

- `docs/steam_launch_checklist.md`
- `docs/asset_register.csv`
- `steam/steamworks_build/README.md`
