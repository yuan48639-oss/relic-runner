# Asset Import Notes

This directory stores source assets that can be legally shipped.

Rules:

- Register every third-party asset in `docs/asset_register.csv` before it enters the game.
- Prefer CC0, public-domain assets, or licenses that clearly allow commercial use.
- Keep downloaded license files next to the relevant asset pack whenever possible.
- Do not use copyrighted characters, trademarks, logos, UI screenshots, music, or sound effects without clear permission.
- If AI-generated assets are used, record the tool, prompt summary, date, and purpose in `docs/ai_content_disclosure.md`.

## Imported Asset Packs

- `assets/vendor/kenney_abstract_platformer/`: Kenney Abstract Platformer, CC0, used for platforms, backgrounds, characters, enemies, props, and tiles.
- `assets/vendor/kenney_game_icons/`: Kenney Game Icons, CC0, used for UI icons and control prompts.
- `assets/vendor/kenney_interface_sounds/`: Kenney Interface Sounds, CC0, used for menu clicks, confirmation, back, and other UI sounds.
- `game/assets/kenney/`: runtime subset copied into the Godot project for `res://` loading.
- `game/assets/fonts/NotoSansCJKsc-Regular.otf`: Noto Sans CJK SC Regular, SIL Open Font License 1.1, used for bilingual UI rendering.

Each imported pack keeps its bundled license file. Authorization details are tracked in `docs/asset_register.csv`.
