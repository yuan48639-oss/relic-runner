import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEVELS_PATH = ROOT / "game" / "data" / "levels.json"
SAVE_MANAGER_PATH = ROOT / "game" / "scripts" / "SaveManager.gd"


def fail(message: str) -> None:
    raise SystemExit(f"VALIDATION FAILED: {message}")


def main() -> None:
    levels = json.loads(LEVELS_PATH.read_text(encoding="utf-8"))
    if len(levels) != 40:
        fail(f"expected 40 levels, found {len(levels)}")

    required = {"name_en", "name_zh", "hint_en", "hint_zh", "start", "platforms", "hazards", "checkpoints", "enemies", "goal", "region", "music", "par_time"}
    regions = set()
    boss_rewards = []
    required_skills = set()
    for index, level in enumerate(levels, start=1):
        missing = sorted(required - set(level))
        if missing:
            fail(f"level {index} missing fields: {', '.join(missing)}")
        regions.add(int(level["region"]))
        if int(level["region"]) not in (1, 2, 3, 4):
            fail(f"level {index} has invalid region {level['region']}")
        if index > 10 and "required_skill" not in level:
            fail(f"level {index} should declare required_skill")
        if "required_skill" in level:
            required_skills.add(level["required_skill"])
        if "boss" in level:
            reward = level.get("reward", {})
            skill = reward.get("skill")
            if not skill:
                fail(f"boss level {index} missing reward.skill")
            boss_rewards.append(skill)

    expected_skills = ["pyroblast", "tidal_wave", "clock_snare", "dawn_barrier"]
    if regions != {1, 2, 3, 4}:
        fail(f"expected regions 1-4, found {sorted(regions)}")
    if boss_rewards != expected_skills:
        fail(f"expected boss rewards {expected_skills}, found {boss_rewards}")
    if not {"pyroblast", "tidal_wave", "clock_snare"}.issubset(required_skills):
        fail(f"late regions missing required skill gates: {sorted(required_skills)}")

    save_text = SAVE_MANAGER_PATH.read_text(encoding="utf-8")
    if "const SAVE_VERSION = 2" not in save_text:
        fail("SaveManager.gd is not at SAVE_VERSION 2")

    print("Validation passed: 40 levels, 4 regions, 4 boss rewards, save v2.")


if __name__ == "__main__":
    main()
