# LAN Co-op Design

## Current State

The project already has a visible LAN prototype menu and a `NetworkManager` that can create an `ENet` host, join `127.0.0.1`, and stop networking. At this stage, only the menu and connection entry points are validated; full gameplay synchronization is not enabled.

## Goals

- Support 2-player cooperation on the same local network.
- Host authority: the host owns the final game state, while clients mainly send input.
- Share health, coins, shop purchases, level progress, and key drops.
- The host owns enemies, drops, shop results, boss rewards, and save writes.
- Client disconnects must not corrupt the host save or push coins, health, or equipment into invalid states.

## Co-op Gameplay Rules

- Both players share 3 team lives, later upgradeable through the Dawnlight Core.
- When one player dies, they respawn at a checkpoint or near the teammate, and team lives are reduced.
- Coins go into a shared team wallet, and shop purchases apply to the team.
- The camera prioritizes keeping both players on screen; if they move too far apart, the game prevents further separation.
- Boss skill drops are resolved once. After unlock, both players can equip the skill.

## Implementation Order

1. Continue extracting expedition state from `Game.gd` so coins, health, levels, equipment, skills, and enemy state can be serialized.
2. Replace the single-`player` assumption with a player registry that can spawn multiple player instances.
3. Clients upload only input. The host broadcasts positions, animations, enemy life/death, drops, coins, health, and current level.
4. Support direct host LAN IP entry first, then consider UDP LAN discovery.
5. Add disconnect recovery, host quit handling, client reconnect, and firewall prompts.
6. Keep the LAN entry internal until synchronization is stable; do not include it in Steam store promises.

## Test Matrix

- Run host and client on the same machine through `127.0.0.1`.
- Connect two computers on the same Wi-Fi through the host's LAN IP.
- Disconnect the client during a level.
- Quit the host while the shop UI is open.
- Join as a client after the host has already entered a level.
- Verify boss death, coin magneting, potion drops, shop purchases, and skill unlocks stay consistent on both ends.
