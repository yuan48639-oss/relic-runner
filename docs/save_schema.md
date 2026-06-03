# Save Schema

Save file path:

```text
user://savegame.json
```

Settings file path:

```text
user://settings.json
```

## Current Fields

- `version`: save schema version. The current release schema is `2`.
- `current_level`: current level index, starting at 0.
- `unlocked_level`: highest unlocked level index.
- `current_region`: current region number, from 1 to 4.
- `player_lives`: current health, never greater than `max_lives`.
- `max_lives`: max health after Dawnlight Core upgrades, currently capped at 6.
- `coins`: persistent coins retained after returning home, dying, or restarting the game.
- `has_long_sword`: legacy compatibility field for early long-sword purchase records.
- `backpack`: consumable counts, currently shaped as `{ "potion": number }`.
- `purchased_items`: permanent home-shop purchase records.
- `equipment`: current equipment slots, including `weapon`, `boots`, `armor`, and `charm`.
- `skills_unlocked` / `unlocked_skills`: unlocked skills such as Pyroblast, Tidal Wave, Clock Snare, and Dawn Barrier.
- `skill_slots` / `equipped_skills`: skill equipment slots, currently mapped to `K` and `L`.
- `language`: UI language, either `zh` or `en`.
- `master_volume`: master volume.
- `best_times`: reserved for future best-clear-time records.

## Save Strategy

- Save when an expedition starts, a level loads, a level is cleared, an item is purchased, an enemy reward is gained, a potion is picked up, a backpack potion is used, death returns to the home hub, or the Dawnlight Core upgrades max health.
- Do not save the player's moment-to-moment coordinates inside a level. This prevents bad saves from trapping the player inside hazards or enemies.
- Loading defaults to the home hub or the starting point of the unlocked level; it does not restore arbitrary mid-level coordinates.
- When the player spends 100 coins to revive after death, revive only at a checkpoint or designed revive point.
- If save JSON cannot be parsed or the version is unsupported, ignore the bad save and return to a new-game state without crashing.
- v1 save loading should remain compatible with old `has_long_sword`, `unlocked_skills`, and `equipped_skills` fields; saving should write v2 fields.

## Settings Strategy

- Language, volume, window mode, screen shake, and future key bindings should be stored in `user://settings.json`.
- Settings persistence should not depend on expedition saves. Deleting the save should not reset language or volume preferences.
