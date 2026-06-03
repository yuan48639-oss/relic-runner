# Playtest Plan

## Test Audience

Invite 5-10 players. Prioritize players familiar with Steam 2D platformers, action-platformers, or light Metroidvania games, while keeping 1-2 newcomers to validate whether guidance is clear enough.

## Test Preparation

1. Use an exported `Windows` build, not the Godot editor.
2. Start from a clean save.
3. Record the build version, test date, and whether the player uses keyboard or controller.
4. Before testing, tell the player only: "Start from the home hub and try to complete one expedition." Do not explain hidden rules.

## Observation Metrics

- Time required to understand the goal for the first time.
- Where the first death happens and whether it feels fair.
- When the first successful attack, stomp, and coin pickup happen.
- Whether the player discovers the home shop, Dawnlight Core, backpack, and skill list.
- Whether the player understands the tradeoff between 2-coin stomps, 1-coin sword kills, and potion drops.
- Whether the player voluntarily buys equipment, equips items, and uses potions.
- Whether the player understands the death options: return home or revive for 100 coins.
- Full demo clear time and any midpoint quit location.

## Test Flow

1. Launch the exported build and let the player choose a language.
2. Let the player explore the home hub freely and enter level 1 through the expedition gate.
3. During play, record issues without actively guiding the player.
4. If the player is stuck for more than 3 minutes, give the smallest useful hint and record the stuck point.
5. After the player clears the demo, dies and returns home, or quits voluntarily, run a short interview.

## Interview Questions

- What do you think the current goal is?
- Which death or damage moment felt unfair?
- Which action felt best, and which felt most awkward?
- Do you understand what coins, equipment, potions, and max health are for?
- Would you keep playing a fuller version? Why?

## Pass Criteria

- At least 7 of 10 players understand the home hub and expedition goal within the first minute.
- At least 6 of 10 players complete the demo without developer help.
- No player reports unreadable button prompts, menus that cannot return, or a confusing death retry flow.
- Most players can explain that stomps reward more coins but are riskier.
- At least half of players voluntarily open the shop or backpack / equipment screen.
