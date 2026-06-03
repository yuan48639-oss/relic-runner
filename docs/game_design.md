# Relic Runner Demo Design

## One-Line Pitch

Play as the Dawn Gate Courier, entering a sand-sea ruin that rearranges itself before sunrise. Find the Dawnlight Core before the desert swallows the town.

## Design Pillars

- Feel first: jump, double jump, dash, stomp, and sword strike must respond immediately. Content quantity should never outweigh control quality.
- Clear danger: enemies, spikes, boss attacks, exits, and interactables need explicit visual language.
- Reward tradeoffs: stomps award 2 coins, while sword kills award 1 coin with a potion-drop chance. Players choose between risk and stability.
- Home growth: every expedition starts from the home hub. After clearing levels or dying, players return home to buy equipment, potions, and max-health upgrades.
- 1.0 scope fit: target first-clear time is roughly 90-140 minutes, with a complete flow, Windows-first release, and no promise of complex networking or long-tail content.

## Current Demo Content

- 40 levels split across 4 regions: Tutorial Ruins, Underground Waterways, Broken Clocktower, and Dawnlight Core Depths.
- Core movement: run, jump, double jump, and dash.
- Core combat: short or long sword melee, head-stomp kills, hurt invulnerability, and knockback feedback.
- Enemy types: patrol enemy, flying eye, shield soldier, crawler, and multi-health bosses.
- Home hub: players can move freely and interact with the expedition gate, shop, Dawnlight Core, backpack / equipment menu, and notice board by pressing `J` or left clicking.
- Progression: coins persist, potions enter the backpack, equipment is permanently purchased, and the Dawnlight Core upgrades max health.
- Level mechanics: checkpoints, moving platforms, brittle platforms, key doors, spikes, and exits.
- Death flow: when health reaches 0, a death notice appears. Players can return home or spend 100 coins to revive at a checkpoint.
- Skills: the 4 region bosses drop Pyroblast, Tidal Wave, Clock Snare, and Dawn Barrier. Press `O` to open the skill list; `K` and `L` equip and cast skills.

## Controls

- Move: `A/D` or arrow keys.
- Jump: `Space`, `W`, or up arrow.
- Dash: `Shift`.
- Attack / interact: `J` or left mouse button.
- Use potion: `Q`.
- Open backpack: `I`, usable in both the home hub and levels.
- Open skill list: `O`.
- Cast skills: `K`, `L`.
- Pause or back: `Esc`. In home UI, `Esc` should return to the original spot without resetting player position.

## Expedition Flow

- The home hub is the starting point. Each expedition begins from the current progress point.
- Clearing an intermediate level advances to the next level without returning home.
- Clearing the final level returns to the home hub.
- Death does not immediately retreat to the home hub. The death notice asks whether to return home or spend 100 coins to revive.

## Current Economy And Equipment

- Stomp kill: 2 coins.
- Sword kill: 1 coin, with a base 10% potion-drop chance.
- Coin Charm: +1 coin for each defeated enemy.
- Medic Charm: raises sword-kill potion-drop chance to 25% and potion healing to 2 health.
- Dawnlight Core: upgrades max health from 3 to 6, priced at 50, 85, and 120 coins.
- Home shop: potion 6, long sword 18, swift boots 28, bronze armor 34, coin charm 40, medic charm 52, wing boots 68, dawn blade 82.
- Equipment menu: weapon, boots, armor, and charm. Purchased gear is permanently unlocked and can be re-equipped from the backpack / equipment screen.
- Release rule: a new game starts with 0 coins, and players gradually buy equipment and potions through expedition rewards.

## Launch Constraints

- First launch platform is `Windows`.
- The first public demo should not include online services, achievements, cloud saves, DLC, in-app purchases, Workshop support, or Linux/macOS launch builds.
- LAN co-op remains an internal prototype and should not be promised on the Steam page until synchronization, disconnect handling, and firewall issues are stable.
- Final art must remain readable at a `960x540` viewport and on Steam Deck-like screens.
