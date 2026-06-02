# 存档结构

存档文件路径：

```text
user://savegame.json
```

设置文件路径：

```text
user://settings.json
```

## 当前字段

- `version`：存档结构版本。当前正式结构为 `2`。
- `current_level`：当前关卡索引，从 0 开始。
- `unlocked_level`：已解锁的最高关卡索引。
- `current_region`：当前区域编号，取值 1-4。
- `player_lives`：当前生命值，不能超过 `max_lives`。
- `max_lives`：晨辉核心提升后的生命上限，目前最高为 6。
- `coins`：持久金币，回到家园、死亡或重启游戏后保留。
- `has_long_sword`：旧存档兼容字段，用于兼容早期长剑购买记录。
- `backpack`：背包消耗品数量，目前格式为 `{ "potion": number }`。
- `purchased_items`：家园商店永久购买记录。
- `equipment`：当前装备，包含 `weapon`、`boots`、`armor`、`charm` 四个槽位。
- `skills_unlocked` / `unlocked_skills`：已解锁技能，例如炎爆术、潮汐波、钟摆束缚、晨辉屏障。
- `skill_slots` / `equipped_skills`：技能装备槽，目前对应 `K` 和 `L`。
- `language`：界面语言，取值为 `zh` 或 `en`。
- `master_volume`：主音量。
- `best_times`：预留字段，用于后续记录最佳通关时间。

## 存档策略

- 远征开始、进入关卡、通关、购买物品、获得敌人奖励、拾取药水、使用背包药水、死亡返回家园、晨辉核心升级时保存。
- 不保存玩家在关卡中的瞬时坐标，避免坏档卡在陷阱或敌人身上。
- 读档默认恢复到家园或已解锁关卡的起点，不从任意中途坐标恢复。
- 死亡后选择 100 金币复活时，只恢复到检查点或设计好的复活点。
- 存档 JSON 无法解析或版本不支持时，应忽略坏档并回到新游戏状态，同时避免崩溃。
- v1 存档读取时应兼容旧的 `has_long_sword`、`unlocked_skills`、`equipped_skills` 字段；保存时写出 v2 字段。

## 设置策略

- 语言、音量、窗口模式、屏幕震动开关和后续按键绑定应放入 `user://settings.json`。
- 设置保存不应依赖远征存档，删除存档不应重置玩家的语言和音量偏好。
