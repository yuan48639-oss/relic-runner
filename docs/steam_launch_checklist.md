# Steam 1.0 Launch Checklist

## Steamworks Setup

- [ ] Create a paid release game app through Steam Direct.
- [ ] Confirm the 1.0 release uses the full game app, not a demo app ID.
- [ ] Give team members only the minimum required permissions.
- [ ] Complete tax, banking, identity, content survey, and AI content disclosure forms.
- [ ] Confirm game name, capsule branding, supported systems, controller support, and language support.
- [ ] Confirm the 1.0 build, store page, and SteamPipe App ID / Depot ID are aligned.

## Store Page

- [ ] Short description covers 2D action-platforming, ruin theme, roughly two-hour main path, and core mechanics.
- [ ] Long description covers movement, combat, hazards, home growth, 40 levels, 4 regions, 4 bosses, equipment, and skills.
- [ ] Screenshots use real build footage only; do not use concept art as gameplay representation.
- [ ] Produce a 20-40 second real gameplay video or short trailer.
- [ ] Export capsules, header images, and library assets at Steam-required sizes.
- [ ] Publish the Coming Soon page before final release.
- [ ] Store-page promises must already exist in the build; do not promise unfinished LAN co-op.

## Build

- [ ] Install Godot 4 export templates.
- [ ] Export the `Windows` build to `build/windows/RelicRunner.exe` or the final product-name path.
- [ ] Launch the exported package outside the Godot editor.
- [ ] Verify the full flow can be completed with both keyboard and controller.
- [ ] Upload through SteamPipe using the VDF templates in `steam/steamworks_build/`.
- [ ] Leave at least 7 business days for Valve review before the planned release date.

## Quality Check

- [ ] New players understand the goal, movement, attack, shop, and death flow within 10 minutes.
- [ ] The game can be played continuously for 30 minutes without crashing.
- [ ] Every level supports pause, resume, death, revive, and return to home.
- [ ] There are no missing assets, debug labels, editor-only paths, or test content that should not ship.
- [ ] The asset register is complete, including fonts, sound effects, music, and AI content records.
- [ ] Chinese UI does not show unintended English internal field names such as `weapon` in the inventory.
