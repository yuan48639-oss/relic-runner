extends Node2D

const PlayerScript = preload("res://scripts/Player.gd")
const EnemyScript = preload("res://scripts/Enemy.gd")
const SaveManagerScript = preload("res://scripts/SaveManager.gd")
const AudioManagerScript = preload("res://scripts/AudioManager.gd")
const NetworkManagerScript = preload("res://scripts/NetworkManager.gd")
const TEX_BG_RUINS = preload("res://assets/kenney/platformer/bg_ruins.png")
const TEX_BG_WATERWORKS = preload("res://assets/kenney/platformer/bg_waterworks.png")
const TEX_BG_CLOCKTOWER = preload("res://assets/kenney/platformer/bg_clocktower.png")
const TEX_BG_CORE = preload("res://assets/kenney/platformer/bg_core.png")
const TEX_TILE_BROWN = preload("res://assets/kenney/platformer/tile_brown.png")
const TEX_TILE_GREY = preload("res://assets/kenney/platformer/tile_grey.png")
const TEX_TILE_GREEN = preload("res://assets/kenney/platformer/tile_green.png")
const TEX_TILE_RED = preload("res://assets/kenney/platformer/tile_red.png")
const TEX_TILE_BRITTLE = preload("res://assets/kenney/platformer/tile_brittle.png")
const TEX_SPIKES = preload("res://assets/kenney/platformer/spikes.png")
const TEX_DOOR = preload("res://assets/kenney/platformer/door.png")
const TEX_FLAG = preload("res://assets/kenney/platformer/flag.png")
const TEX_KEY = preload("res://assets/kenney/platformer/key.png")
const TEX_POTION = preload("res://assets/kenney/platformer/potion.png")
const TEX_COIN = preload("res://assets/kenney/platformer/coin.png")
const TEX_SKILL_PYROBLAST = preload("res://assets/kenney/platformer/skill_pyroblast.png")
const TEX_SKILL_TIDAL_WAVE = preload("res://assets/kenney/platformer/skill_tidal_wave.png")
const TEX_SKILL_CLOCK_SNARE = preload("res://assets/kenney/platformer/skill_clock_snare.png")
const TEX_SKILL_DAWN_BARRIER = preload("res://assets/kenney/platformer/skill_dawn_barrier.png")
const FONT_UI = preload("res://assets/fonts/NotoSansCJKsc-Regular.otf")

const LEVELS_PATH = "res://data/levels.json"
const VIEWPORT_SIZE = Vector2(960, 540)
const LEVEL_X_SCALE = 1.6
const HOME_WORLD_WIDTH = 1920.0
const WORLD_LIMIT_Y = 620.0
const LAYER_WORLD = 1
const LAYER_PLAYER = 2
const LAYER_ENEMY = 4
const LAYER_TRIGGER = 8
const PLAYER_HALF_WIDTH = 12.0
const PLAYER_HEIGHT = 44.0
const ENEMY_HALF_WIDTH = 15.0
const ENEMY_HEIGHT = 30.0
const STOMP_GRACE = 8.0
const MAX_LIVES = 3
const POTION_COST = 4
const SWORD_COST = 7
const HOME_POTION_COST = 6
const HOME_LONG_SWORD_COST = 18
const HOME_SWIFT_BOOTS_COST = 28
const HOME_BRONZE_ARMOR_COST = 34
const HOME_COIN_CHARM_COST = 40
const HOME_MEDIC_CHARM_COST = 52
const HOME_WING_BOOTS_COST = 68
const HOME_DAWN_BLADE_COST = 82
const HOME_STORM_SWORD_COST = 130
const HOME_ANCHOR_BOOTS_COST = 110
const HOME_GLASS_ARMOR_COST = 145
const HOME_DAWN_CHARM_COST = 165
const HOME_MAX_LIFE_CAP = 6
const CORE_LIFE_BASE_COST = 50
const CORE_LIFE_STEP_COST = 35
const REVIVE_COST = 100
const STARTING_COINS = 0
const PYROBLAST_RANGE = 150.0
const PYROBLAST_DAMAGE = 3
const PYROBLAST_COOLDOWN = 3.5
const TIDAL_WAVE_RANGE = 185.0
const TIDAL_WAVE_DAMAGE = 2
const TIDAL_WAVE_COOLDOWN = 4.0
const CLOCK_SNARE_RANGE = 170.0
const CLOCK_SNARE_DAMAGE = 2
const CLOCK_SNARE_COOLDOWN = 4.8
const DAWN_BARRIER_RANGE = 118.0
const DAWN_BARRIER_DAMAGE = 1
const DAWN_BARRIER_COOLDOWN = 6.0
const SHORT_SWORD_REACH = 44.0
const LONG_SWORD_REACH = 72.0
const STORM_SWORD_REACH = 84.0
const DAWN_BLADE_REACH = 92.0
const SKILL_IDS = ["pyroblast", "tidal_wave", "clock_snare", "dawn_barrier"]
const HOME_SHOP_ORDER = ["potion", "long_sword", "swift_boots", "bronze_armor", "coin_charm", "medic_charm", "wing_boots", "dawn_blade", "storm_sword", "anchor_boots", "glass_armor", "dawn_charm"]
const EQUIPMENT_ITEMS = {
	"long_sword": {"slot": "weapon", "value": "long_sword", "cost": HOME_LONG_SWORD_COST},
	"dawn_blade": {"slot": "weapon", "value": "dawn_blade", "cost": HOME_DAWN_BLADE_COST},
	"storm_sword": {"slot": "weapon", "value": "storm_sword", "cost": HOME_STORM_SWORD_COST},
	"swift_boots": {"slot": "boots", "value": "swift_boots", "cost": HOME_SWIFT_BOOTS_COST},
	"wing_boots": {"slot": "boots", "value": "wing_boots", "cost": HOME_WING_BOOTS_COST},
	"anchor_boots": {"slot": "boots", "value": "anchor_boots", "cost": HOME_ANCHOR_BOOTS_COST},
	"bronze_armor": {"slot": "armor", "value": "bronze_armor", "cost": HOME_BRONZE_ARMOR_COST},
	"glass_armor": {"slot": "armor", "value": "glass_armor", "cost": HOME_GLASS_ARMOR_COST},
	"coin_charm": {"slot": "charm", "value": "coin_charm", "cost": HOME_COIN_CHARM_COST},
	"medic_charm": {"slot": "charm", "value": "medic_charm", "cost": HOME_MEDIC_CHARM_COST},
	"dawn_charm": {"slot": "charm", "value": "dawn_charm", "cost": HOME_DAWN_CHARM_COST}
}
const WEAPON_STATS = {
	"short_sword": {"reach": SHORT_SWORD_REACH, "damage": 1, "skill_bonus": 0},
	"long_sword": {"reach": LONG_SWORD_REACH, "damage": 1, "skill_bonus": 0},
	"dawn_blade": {"reach": DAWN_BLADE_REACH, "damage": 2, "skill_bonus": 0},
	"storm_sword": {"reach": STORM_SWORD_REACH, "damage": 2, "skill_bonus": 1}
}
const BOOT_STATS = {
	"worn_boots": {"speed": 230.0, "dash_speed": 520.0, "dash_duration": 0.12, "dash_cooldown": 0.45, "max_jumps": 2},
	"swift_boots": {"speed": 252.0, "dash_speed": 575.0, "dash_duration": 0.11, "dash_cooldown": 0.32, "max_jumps": 2},
	"wing_boots": {"speed": 242.0, "dash_speed": 555.0, "dash_duration": 0.11, "dash_cooldown": 0.28, "max_jumps": 3},
	"anchor_boots": {"speed": 218.0, "dash_speed": 640.0, "dash_duration": 0.16, "dash_cooldown": 0.36, "max_jumps": 2}
}

const LEVELS = [
	{
		"name_en": "1. Tutorial Ruins",
		"name_zh": "1. Tutorial Ruins",
		"hint_en": "Move, double jump, and strike the training drone.",
		"hint_zh": "Move, jump, and attack through the first ruin.",
		"start": [64, 500],
		"platforms": [[0, 500, 960, 40], [138, 440, 120, 18], [320, 392, 130, 18], [520, 440, 118, 18], [720, 382, 150, 18]],
		"hazards": [[468, 492, 126, 16]],
		"enemies": [{"pos": [585, 440], "patrol": 45}],
		"goal": [846, 382]
	},
	{
		"name_en": "2. Spike Gallery",
		"name_zh": "2. Spike Gallery",
		"hint_en": "Keep momentum and use the second jump late.",
		"hint_zh": "Keep momentum and save the second jump for the spikes.",
		"start": [58, 500],
		"platforms": [[0, 500, 230, 40], [306, 460, 116, 18], [500, 414, 116, 18], [688, 368, 134, 18], [840, 500, 120, 40]],
		"hazards": [[230, 492, 76, 18], [422, 492, 78, 18], [616, 492, 72, 18], [822, 492, 18, 18]],
		"enemies": [{"pos": [548, 414], "patrol": 46}, {"pos": [746, 368], "patrol": 42}],
		"goal": [900, 500]
	},
	{
		"name_en": "3. Gate of Dawn",
		"name_zh": "3. Gate of Dawn",
		"hint_en": "Chain attacks and jumps to cross the broken bridge.",
		"hint_zh": "Chain attacks and jumps across the broken bridge.",
		"start": [54, 500],
		"platforms": [[0, 500, 160, 40], [224, 452, 116, 18], [384, 408, 116, 18], [548, 364, 116, 18], [724, 416, 110, 18], [848, 500, 112, 40]],
		"hazards": [[160, 492, 64, 18], [340, 492, 44, 18], [500, 492, 48, 18], [664, 492, 60, 18], [834, 492, 14, 18]],
		"enemies": [{"pos": [278, 452], "patrol": 42}, {"pos": [606, 364], "patrol": 48}, {"pos": [778, 416], "patrol": 32}],
		"goal": [910, 500],
		"shop": [108, 500]
	}
]
const TEXT = {
	"en": {
		"title": "RELIC RUNNER",
		"subtitle": "Home of the Dawn Gate courier",
		"start": "Start Expedition",
		"continue": "Continue",
		"home_shop": "Home Shop",
		"core": "Dawn Core",
		"inventory": "Backpack / Equipment",
		"settings": "Settings",
		"network": "LAN Prototype",
		"delete_save": "Delete Save",
		"quit": "Quit",
		"back": "Back",
		"controls": "Move: A/D or Left Stick   Jump: Space/A   Dash: Shift/B   Attack/Interact: J/X   Potion: Q/U/Y   Backpack: I   Skills: O, K/L   Restart: R   Pause: Esc/Start",
		"settings_title": "SETTINGS",
		"master_volume": "Master Volume",
		"music_volume": "Music Volume",
		"sfx_volume": "SFX Volume",
		"ui_volume": "UI Volume",
		"paused": "PAUSED",
		"resume": "Resume",
		"restart_level": "Restart Level",
		"main_menu": "Main Menu",
		"death": "YOU FELL IN THE RUINS",
		"return_home": "Return Home",
		"revive": "Revive - 100 coins",
		"revive_no_money": "Not enough coins to revive.",
		"revived": "Revived at the checkpoint.",
		"retry": "Retry Level",
		"complete": "DAWN CORE RESTORED",
		"complete_note": "The full 1.0 route is complete. Review screenshots, credits, and SteamPipe templates before release.",
		"play_again": "Play Again",
		"lives": "Lives",
		"coins": "Coins",
		"max_life": "Max Life",
		"home_status": "Expedition Start: %s    Coins: %s    Max Life: %s",
		"home_walk_tip": "Walk home. Press J / Left Click near a station to interact. Esc opens system menu.",
		"home_gate": "Expedition Gate",
		"home_backpack": "Backpack",
		"home_settings_board": "Notice Board",
		"home_pause": "HOME MENU",
		"interact_prompt": "J / Left Click",
		"home_death": "You returned home after falling in the ruins.",
		"home_clear": "Level cleared. Spend coins before the next expedition.",
		"home_complete": "The Dawn Core is restored. The town survives the sunrise.",
		"buy_home_potion": "Buy Potion - 6 coins",
		"buy_home_sword": "Permanent Long Sword - 18 coins",
		"buy_home_boots": "Swift Boots - 28 coins",
		"buy_home_armor": "Bronze Armor - 34 coins",
		"buy_home_charm": "Coin Charm - 40 coins",
		"buy_home_medic": "Medic Charm - 52 coins",
		"buy_home_wing_boots": "Wing Boots - 68 coins",
		"buy_home_dawn_blade": "Dawn Blade - 82 coins",
		"buy_home_storm_sword": "Storm Sword - 130 coins",
		"buy_home_anchor_boots": "Anchor Boots - 110 coins",
		"buy_home_glass_armor": "Glass Armor - 145 coins",
		"buy_home_dawn_charm": "Dawn Charm - 165 coins",
		"core_upgrade": "Upgrade Max Life",
		"core_cost": "Cost: %s coins",
		"core_maxed": "Core life upgrades maxed.",
		"core_upgraded": "Dawn Core strengthened. Max life increased.",
		"inventory_title": "BACKPACK / EQUIPMENT",
		"inventory_summary": "Potions: %s    Weapon: %s    Boots: %s    Armor: %s    Charm: %s",
		"skills_title": "SKILLS",
		"skill_summary": "K: %s    L: %s",
		"skill_pyroblast": "Pyroblast",
		"skill_tidal_wave": "Tidal Wave",
		"skill_clock_snare": "Clock Snare",
		"skill_dawn_barrier": "Dawn Barrier",
		"skill_locked": "Locked",
		"equip_k": "Equip to K",
		"equip_l": "Equip to L",
		"skill_unlocked": "Pyroblast learned.",
		"skill_no_slot": "No skill equipped.",
		"skill_cooldown": "Skill cooling down.",
		"owned": "Owned",
		"equipped": "Equipped",
		"use_potion": "Use Potion",
		"no_potion": "No potion in backpack.",
		"potion_stored": "Potion stored in backpack.",
		"item_short_sword": "Short Sword",
		"item_long_sword": "Long Sword",
		"item_dawn_blade": "Dawn Blade",
		"item_storm_sword": "Storm Sword",
		"item_worn_boots": "Worn Boots",
		"item_swift_boots": "Swift Boots",
		"item_wing_boots": "Wing Boots",
		"item_anchor_boots": "Anchor Boots",
		"item_cloth": "Cloth Tunic",
		"item_bronze_armor": "Bronze Armor",
		"item_glass_armor": "Glass Armor",
		"item_none": "None",
		"item_coin_charm": "Coin Charm",
		"item_medic_charm": "Medic Charm",
		"item_dawn_charm": "Dawn Charm",
		"slot_weapon": "Weapon",
		"slot_boots": "Boots",
		"slot_armor": "Armor",
		"slot_charm": "Charm",
		"effect_potion": "Stored in backpack. Use during a run.",
		"effect_long_sword": "Reach +28. Damage 1.",
		"effect_dawn_blade": "Reach +48. Damage 2.",
		"effect_storm_sword": "Reach +40. Damage 2. Skill damage +1.",
		"effect_swift_boots": "Move +22. Dash cooldown 0.32s.",
		"effect_wing_boots": "Move +12. Triple jump. Dash cooldown 0.28s.",
		"effect_anchor_boots": "Move -12. Dash speed +120. Dash lasts 0.16s.",
		"effect_bronze_armor": "Blocks the first hit of each expedition.",
		"effect_glass_armor": "Blocks two hits of each expedition.",
		"effect_coin_charm": "+1 coin from each defeated enemy.",
		"effect_medic_charm": "Potions heal more and sword kills drop more potions.",
		"effect_dawn_charm": "Skills cool down faster.",
		"equip": "Equip",
		"blocked_hit": "Armor blocked the hit.",
		"shop_title": "RUIN SHOP",
		"shop_tip": "Warm tip: stomp enemies for 2 coins.",
		"shop_prompt": "Press J / Left Click to shop",
		"buy_potion": "Potion - 4 coins",
		"buy_sword": "Long Sword - 7 coins",
		"close_shop": "Close",
		"shop_full_life": "Life is already full.",
		"shop_no_money": "Not enough coins.",
		"shop_bought_potion": "Potion used. +1 life.",
		"shop_bought_sword": "Long sword equipped.",
		"shop_sword_owned": "Long sword already owned.",
		"network_title": "LAN PROTOTYPE",
		"network_note": "Connection shell only. Gameplay sync comes after state refactor.",
		"host_game": "Host Game",
		"join_local": "Join 127.0.0.1",
		"stop_network": "Stop Network",
		"network_status": "Status"
	},
	"zh": {
		"title": "遗迹奔跑者",
		"subtitle": "晨门信使的家园",
		"start": "开始远征",
		"continue": "继续游戏",
		"home_shop": "家园商店",
		"core": "晨辉核心",
		"inventory": "背包 / 装备栏",
		"settings": "设置",
		"network": "局域网原型",
		"delete_save": "删除存档",
		"quit": "退出",
		"back": "返回",
		"controls": "移动：A/D 或左摇杆   跳跃：Space/A   冲刺：Shift/B   攻击/交互：J/X   药水：Q/U/Y   背包：I   技能：O、K/L   重开：R   暂停：Esc/Start",
		"settings_title": "设置",
		"master_volume": "主音量",
		"music_volume": "音乐音量",
		"sfx_volume": "音效音量",
		"ui_volume": "界面音量",
		"paused": "已暂停",
		"resume": "继续",
		"restart_level": "重开关卡",
		"main_menu": "主菜单",
		"death": "你倒在了遗迹中",
		"return_home": "返回家园",
		"revive": "100 金币复活",
		"revive_no_money": "金币不足，无法复活。",
		"revived": "已在检查点复活。",
		"retry": "重试关卡",
		"complete": "晨辉核心已复苏",
		"complete_note": "1.0 主线已完成。发布前请复核截图、署名和 SteamPipe 模板。",
		"play_again": "再玩一次",
		"lives": "生命",
		"coins": "金币",
		"max_life": "生命上限",
		"home_status": "远征起点：%s    金币：%s    生命上限：%s",
		"home_walk_tip": "在家园中移动。靠近设施按 J / 左键交互，Esc 打开系统菜单。",
		"home_gate": "远征门",
		"home_backpack": "背包",
		"home_settings_board": "告示牌",
		"home_pause": "家园菜单",
		"interact_prompt": "J / 左键",
		"home_death": "你从遗迹中撤回了家园。",
		"home_clear": "关卡已完成。出发前可以在家园消费金币。",
		"home_complete": "晨辉核心已复苏。城镇撑过了日出。",
		"buy_home_potion": "购买药水 - 6 金币",
		"buy_home_sword": "永久长剑 - 18 金币",
		"buy_home_boots": "迅捷靴 - 28 金币",
		"buy_home_armor": "青铜护甲 - 34 金币",
		"buy_home_charm": "金币护符 - 40 金币",
		"buy_home_medic": "医者护符 - 52 金币",
		"buy_home_wing_boots": "羽翼靴 - 68 金币",
		"buy_home_dawn_blade": "晨辉刃 - 82 金币",
		"buy_home_storm_sword": "风暴剑 - 130 金币",
		"buy_home_anchor_boots": "锚定靴 - 110 金币",
		"buy_home_glass_armor": "琉璃甲 - 145 金币",
		"buy_home_dawn_charm": "晨辉护符 - 165 金币",
		"core_upgrade": "提升生命上限",
		"core_cost": "价格：%s 金币",
		"core_maxed": "核心生命升级已满。",
		"core_upgraded": "晨辉核心已强化，生命上限提升。",
		"inventory_title": "背包 / 装备栏",
		"inventory_summary": "药水：%s    武器：%s    靴子：%s    护甲：%s    护符：%s",
		"skills_title": "技能列表",
		"skill_summary": "K：%s    L：%s",
		"skill_pyroblast": "炎爆术",
		"skill_tidal_wave": "潮汐波",
		"skill_clock_snare": "钟摆束缚",
		"skill_dawn_barrier": "晨辉屏障",
		"skill_locked": "未解锁",
		"equip_k": "装备到 K",
		"equip_l": "装备到 L",
		"skill_unlocked": "已学会新技能。",
		"skill_no_slot": "该按键没有装备技能。",
		"skill_cooldown": "技能冷却中。",
		"owned": "已拥有",
		"equipped": "已装备",
		"use_potion": "使用药水",
		"no_potion": "背包里没有药水。",
		"potion_stored": "药水已放入背包。",
		"item_short_sword": "短剑",
		"item_long_sword": "长剑",
		"item_dawn_blade": "晨辉刃",
		"item_storm_sword": "风暴剑",
		"item_worn_boots": "旧靴",
		"item_swift_boots": "迅捷靴",
		"item_wing_boots": "羽翼靴",
		"item_anchor_boots": "锚定靴",
		"item_cloth": "布衣",
		"item_bronze_armor": "青铜护甲",
		"item_glass_armor": "琉璃甲",
		"item_none": "无",
		"item_coin_charm": "金币护符",
		"item_medic_charm": "医者护符",
		"item_dawn_charm": "晨辉护符",
		"slot_weapon": "武器",
		"slot_boots": "靴子",
		"slot_armor": "护甲",
		"slot_charm": "护符",
		"effect_potion": "放入背包，出征时使用。",
		"effect_long_sword": "攻击距离 +28，伤害 1。",
		"effect_dawn_blade": "攻击距离 +48，伤害 2。",
		"effect_storm_sword": "攻击距离 +40，伤害 2，技能伤害 +1。",
		"effect_swift_boots": "移动速度 +22，冲刺冷却 0.32 秒。",
		"effect_wing_boots": "移动速度 +12，三段跳，冲刺冷却 0.28 秒。",
		"effect_anchor_boots": "移动速度 -12，冲刺速度 +120，冲刺时长 0.16 秒。",
		"effect_bronze_armor": "每次出征抵挡第一次受伤。",
		"effect_glass_armor": "每次出征抵挡两次受伤。",
		"effect_coin_charm": "每个被击败的怪物额外 +1 金币。",
		"effect_medic_charm": "药水治疗更多，剑杀更容易掉药。",
		"effect_dawn_charm": "缩短技能冷却时间。",
		"equip": "装备",
		"blocked_hit": "护甲抵挡了这次伤害。",
		"shop_title": "遗迹商店",
		"shop_tip": "提示：踩死怪物掉落 2 金币。",
		"shop_prompt": "按 J / 左键打开商店",
		"buy_potion": "药水 - 4 金币",
		"buy_sword": "更长的宝剑 - 7 金币",
		"close_shop": "关闭",
		"shop_full_life": "生命已满。",
		"shop_no_money": "金币不足。",
		"shop_bought_potion": "已使用药水，生命 +1。",
		"shop_bought_sword": "已装备更长的宝剑。",
		"shop_sword_owned": "已经拥有更长的宝剑。",
		"network_title": "局域网原型",
		"network_note": "当前只做连接外壳；玩法同步在状态重构后接入。",
		"host_game": "创建主机",
		"join_local": "加入 127.0.0.1",
		"stop_network": "停止网络",
		"network_status": "状态"
	}
}

var world: Node2D
var level_root: Node2D
var ui_layer: CanvasLayer
var ui_root: Control
var player
var camera: Camera2D
var enemies: Array = []
var coin_drops: Array = []
var current_level := 0
var state := "menu"
var inventory_return_state := "home"
var skill_return_state := "home"
var paused := false
var master_volume := 0.8
var language := "zh"
var player_lives := MAX_LIVES
var max_lives := MAX_LIVES
var coins := STARTING_COINS
var has_long_sword := false
var unlocked_level := 0
var home_message := ""
var home_spawn_position := Vector2(900, 500)
var home_resume_position := Vector2.ZERO
var has_home_resume_position := false
var home_interactables: Array = []
var backpack := {"potion": 0}
var purchased_items := {}
var equipment := {
	"weapon": "short_sword",
	"boots": "worn_boots",
	"armor": "cloth",
	"charm": "none"
}
var unlocked_skills := {}
var equipped_skills := {"K": "", "L": ""}
var skill_cooldowns := {
	"pyroblast": 0.0,
	"tidal_wave": 0.0,
	"clock_snare": 0.0,
	"dawn_barrier": 0.0
}
var armor_charges := 0
var shop_available := false
var shop_position := Vector2.ZERO
var shop_message := ""
var checkpoint_position := Vector2.ZERO
var keys_collected := {}
var doors: Array = []
var moving_platforms: Array = []
var levels: Array = []
var current_world_width := VIEWPORT_SIZE.x
var save_manager
var audio_manager
var network_manager
var network_message := "Offline"
var hud_label: Label
var hud_health_bar: ProgressBar
var hud_life_label: Label
var hud_coin_label: Label
var hud_potion_label: Label
var hud_equipment_label: Label
var hud_hint_label: Label
var ui_focus_assigned := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	randomize()
	save_manager = SaveManagerScript.new()
	save_manager.name = "SaveManager"
	add_child(save_manager)
	audio_manager = AudioManagerScript.new()
	audio_manager.name = "AudioManager"
	add_child(audio_manager)
	network_manager = NetworkManagerScript.new()
	network_manager.name = "NetworkManager"
	add_child(network_manager)
	network_manager.status_changed.connect(func(message: String) -> void:
		network_message = message
		if state == "network":
			show_network_menu()
	)
	levels = load_levels()
	apply_saved_settings()
	load_home_state()
	ensure_input_actions()
	audio_manager.set_volume("Master", master_volume)
	build_world_root()
	build_ui_root()
	show_main_menu()

func ensure_input_actions() -> void:
	add_key_action("move_left", [KEY_A, KEY_LEFT])
	add_key_action("move_right", [KEY_D, KEY_RIGHT])
	add_key_action("jump", [KEY_SPACE, KEY_W, KEY_UP])
	add_key_action("dash", [KEY_SHIFT])
	add_key_action("attack", [KEY_J])
	add_key_action("use_item", [KEY_Q, KEY_U])
	add_key_action("inventory", [KEY_I])
	add_key_action("skills", [KEY_O])
	add_key_action("skill_k", [KEY_K])
	add_key_action("skill_l", [KEY_L])
	add_key_action("pause", [KEY_ESCAPE])
	add_key_action("restart", [KEY_R])
	add_key_action("ui_up", [KEY_W, KEY_UP])
	add_key_action("ui_down", [KEY_S, KEY_DOWN])
	add_key_action("ui_left", [KEY_A, KEY_LEFT])
	add_key_action("ui_right", [KEY_D, KEY_RIGHT])
	add_key_action("ui_accept", [KEY_J, KEY_ENTER, KEY_SPACE])
	add_key_action("ui_cancel", [KEY_ESCAPE])
	add_mouse_button_action("attack", MOUSE_BUTTON_LEFT)

	add_joy_button_action("jump", JOY_BUTTON_A)
	add_joy_button_action("dash", JOY_BUTTON_B)
	add_joy_button_action("attack", JOY_BUTTON_X)
	add_joy_button_action("use_item", JOY_BUTTON_Y)
	add_joy_button_action("pause", JOY_BUTTON_START)
	add_joy_button_action("move_left", JOY_BUTTON_DPAD_LEFT)
	add_joy_button_action("move_right", JOY_BUTTON_DPAD_RIGHT)

	add_joy_motion_action("move_left", JOY_AXIS_LEFT_X, -1.0)
	add_joy_motion_action("move_right", JOY_AXIS_LEFT_X, 1.0)

func add_key_action(action: StringName, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for key in keys:
		var event := InputEventKey.new()
		event.keycode = key
		add_event_if_missing(action, event)

func add_joy_button_action(action: StringName, button_index: int) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var event := InputEventJoypadButton.new()
	event.button_index = button_index
	add_event_if_missing(action, event)

func add_mouse_button_action(action: StringName, button_index: int) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var event := InputEventMouseButton.new()
	event.button_index = button_index
	add_event_if_missing(action, event)

func add_joy_motion_action(action: StringName, axis: int, value: float) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var event := InputEventJoypadMotion.new()
	event.axis = axis
	event.axis_value = value
	add_event_if_missing(action, event)

func add_event_if_missing(action: StringName, event: InputEvent) -> void:
	for existing in InputMap.action_get_events(action):
		if existing.is_match(event):
			return
	InputMap.action_add_event(action, event)

func t(key: String) -> String:
	var pack: Dictionary = TEXT.get(language, TEXT["en"])
	return pack.get(key, TEXT["en"].get(key, key))

func level_text(data: Dictionary, key: String) -> String:
	var localized_key := "%s_%s" % [key, language]
	var localized := str(data.get(localized_key, ""))
	if is_bad_localized_text(localized):
		return str(data.get("%s_en" % key, key))
	return localized

func is_bad_localized_text(value: String) -> bool:
	return value == "" or value.contains("?") or value.contains("�") or value.contains("閬") or value.contains("鑳") or value.contains("鐠") or value.contains("娑")

func current_region_id() -> int:
	if levels.is_empty():
		return 1
	var index := clampi(current_level, 0, levels.size() - 1)
	return int(levels[index].get("region", (index / 10) + 1))

func language_button_text() -> String:
	if language == "en":
		return "Language / 语言: English -> 中文"
	return "Language / 语言: 中文 -> English"

func toggle_language() -> void:
	language = "zh" if language == "en" else "en"
	save_settings()
	refresh_ui_for_language()

func refresh_ui_for_language() -> void:
	match state:
		"menu":
			show_main_menu()
		"home":
			show_main_menu()
		"home_pause":
			show_home_pause_menu()
		"settings":
			show_settings()
		"playing":
			clear_ui()
			show_hud()
		"paused":
			show_pause_menu()
		"dead":
			show_death_screen()
		"won":
			show_win_screen()
		"shop":
			show_shop(shop_message)
		"home_shop":
			show_home_shop()
		"core":
			show_core()
		"inventory":
			show_inventory()
		"network":
			show_network_menu()

func load_levels() -> Array:
	if FileAccess.file_exists(LEVELS_PATH):
		var file := FileAccess.open(LEVELS_PATH, FileAccess.READ)
		if file:
			var parsed = JSON.parse_string(file.get_as_text())
			if typeof(parsed) == TYPE_ARRAY and parsed.size() > 0:
				return parsed
	return LEVELS.duplicate(true)

func apply_saved_settings() -> void:
	if not save_manager:
		return
	var settings: Dictionary = save_manager.load_settings()
	if settings.has("language"):
		language = str(settings["language"])
	if settings.has("master_volume"):
		master_volume = clampf(float(settings["master_volume"]), 0.0, 1.0)
	if settings.has("audio") and audio_manager:
		audio_manager.apply_settings(settings["audio"])

func save_settings() -> void:
	if not save_manager:
		return
	var audio_settings := {}
	if audio_manager:
		audio_settings = audio_manager.export_settings()
	save_manager.save_settings({
		"language": language,
		"master_volume": master_volume,
		"audio": audio_settings
	})

func load_home_state() -> void:
	if not save_manager or not save_manager.has_save():
		return
	var data: Dictionary = save_manager.load_game()
	if data.is_empty():
		return
	current_level = clampi(int(data.get("current_level", 0)), 0, max(levels.size() - 1, 0))
	unlocked_level = clampi(int(data.get("unlocked_level", current_level)), 0, max(levels.size() - 1, 0))
	max_lives = clampi(int(data.get("max_lives", MAX_LIVES)), MAX_LIVES, HOME_MAX_LIFE_CAP)
	player_lives = clampi(int(data.get("player_lives", max_lives)), 1, max_lives)
	coins = max(STARTING_COINS, int(data.get("coins", STARTING_COINS)))
	has_long_sword = bool(data.get("has_long_sword", false))
	var loaded_backpack: Dictionary = data.get("backpack", {})
	backpack = {"potion": int(loaded_backpack.get("potion", 0))}
	purchased_items = data.get("purchased_items", {})
	var loaded_equipment: Dictionary = data.get("equipment", {})
	equipment = {
		"weapon": str(loaded_equipment.get("weapon", "long_sword" if has_long_sword else "short_sword")),
		"boots": str(loaded_equipment.get("boots", "worn_boots")),
		"armor": str(loaded_equipment.get("armor", "cloth")),
		"charm": str(loaded_equipment.get("charm", "none"))
	}
	unlocked_skills = data.get("unlocked_skills", data.get("skills_unlocked", {}))
	var loaded_skills: Dictionary = data.get("equipped_skills", {})
	equipped_skills = {
		"K": str(loaded_skills.get("K", "")),
		"L": str(loaded_skills.get("L", ""))
	}

func build_world_root() -> void:
	world = Node2D.new()
	world.name = "World"
	add_child(world)

	camera = Camera2D.new()
	camera.name = "Camera2D"
	camera.enabled = true
	camera.position = VIEWPORT_SIZE / 2.0
	add_child(camera)

func build_ui_root() -> void:
	ui_layer = CanvasLayer.new()
	ui_layer.name = "UI"
	add_child(ui_layer)
	ui_root = Control.new()
	ui_root.name = "Root"
	ui_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_layer.add_child(ui_root)

func clear_ui() -> void:
	for child in ui_root.get_children():
		child.queue_free()
	ui_focus_assigned = false
	hud_label = null
	hud_health_bar = null
	hud_life_label = null
	hud_coin_label = null
	hud_potion_label = null
	hud_equipment_label = null
	hud_hint_label = null

func show_main_menu() -> void:
	show_home_world()
	return
	state = "menu"
	paused = false
	clear_level()
	clear_ui()
	draw_home_map_background()

	var title := make_label(t("title"), 42, Vector2(0, 34), Vector2(VIEWPORT_SIZE.x, 62), HORIZONTAL_ALIGNMENT_CENTER)
	title.add_theme_color_override("font_color", Color(0.98, 0.84, 0.42))
	ui_root.add_child(title)

	var subtitle := make_label(t("subtitle"), 18, Vector2(0, 92), Vector2(VIEWPORT_SIZE.x, 34), HORIZONTAL_ALIGNMENT_CENTER)
	subtitle.add_theme_color_override("font_color", Color(0.83, 0.88, 0.82))
	ui_root.add_child(subtitle)

	var next_name := level_text(levels[clampi(unlocked_level, 0, levels.size() - 1)], "name") if levels.size() > 0 else "--"
	var status := make_label(t("home_status") % [next_name, coins, max_lives], 16, Vector2(0, 128), Vector2(VIEWPORT_SIZE.x, 28), HORIZONTAL_ALIGNMENT_CENTER)
	status.add_theme_color_override("font_color", Color(0.96, 0.86, 0.55))
	ui_root.add_child(status)

	if home_message != "":
		var message := make_label(home_message, 15, Vector2(0, 156), Vector2(VIEWPORT_SIZE.x, 28), HORIZONTAL_ALIGNMENT_CENTER)
		message.add_theme_color_override("font_color", Color(0.94, 0.84, 0.58))
		ui_root.add_child(message)

	var start_button := make_button(t("start"), Vector2(602, 232), Vector2(210, 44))
	start_button.pressed.connect(func() -> void: start_game())
	ui_root.add_child(start_button)

	var home_shop_button := make_button(t("home_shop"), Vector2(124, 266), Vector2(210, 44))
	home_shop_button.pressed.connect(func() -> void: show_home_shop())
	ui_root.add_child(home_shop_button)

	var core_button := make_button(t("core"), Vector2(376, 214), Vector2(210, 44))
	core_button.pressed.connect(func() -> void: show_core())
	ui_root.add_child(core_button)

	var inventory_button := make_button(t("inventory"), Vector2(376, 324), Vector2(210, 44))
	inventory_button.pressed.connect(func() -> void: show_inventory())
	ui_root.add_child(inventory_button)

	var settings_button := make_button(t("settings"), Vector2(188, 412), Vector2(160, 38))
	settings_button.pressed.connect(func() -> void: show_settings())
	ui_root.add_child(settings_button)

	var network_button := make_button(t("network"), Vector2(400, 412), Vector2(160, 38))
	network_button.pressed.connect(func() -> void: show_network_menu())
	ui_root.add_child(network_button)

	var language_button := make_button(language_button_text(), Vector2(612, 412), Vector2(240, 38))
	language_button.pressed.connect(func() -> void: toggle_language())
	ui_root.add_child(language_button)

	var delete_button := make_button(t("delete_save"), Vector2(280, 462), Vector2(180, 36))
	delete_button.disabled = not save_manager.has_save()
	delete_button.pressed.connect(func() -> void:
		save_manager.delete_save()
		reset_home_state()
		show_main_menu()
	)
	ui_root.add_child(delete_button)

	var quit_button := make_button(t("quit"), Vector2(500, 462), Vector2(180, 36))
	quit_button.pressed.connect(func() -> void: get_tree().quit())
	ui_root.add_child(quit_button)

	var controls := make_label(t("controls"), 13, Vector2(0, 506), Vector2(VIEWPORT_SIZE.x, 30), HORIZONTAL_ALIGNMENT_CENTER)
	controls.add_theme_color_override("font_color", Color(0.62, 0.68, 0.68))
	ui_root.add_child(controls)

func show_home_world() -> void:
	state = "home"
	paused = false
	clear_level()
	clear_ui()
	home_interactables.clear()
	current_world_width = HOME_WORLD_WIDTH
	player_lives = max_lives

	level_root = Node2D.new()
	level_root.name = "Home"
	world.add_child(level_root)
	draw_home_world_background()
	create_home_station("settings", Vector2(180, 500), t("home_settings_board"), Color(0.38, 0.42, 0.38))
	create_home_station("shop", Vector2(510, 500), t("home_shop"), Color(0.82, 0.46, 0.18))
	create_home_station("core", Vector2(820, 500), t("core"), Color(0.86, 0.68, 0.25))
	create_home_station("expedition", Vector2(960, 500), t("home_gate"), Color(0.92, 0.64, 0.22))
	create_home_station("inventory", Vector2(1280, 500), t("home_backpack"), Color(0.42, 0.62, 0.68))

	player = PlayerScript.new()
	player.name = "Player"
	player.game = self
	level_root.add_child(player)
	apply_player_equipment()
	var spawn_pos := home_resume_position if has_home_resume_position else home_spawn_position
	player.reset_to(spawn_pos, player_lives)

	show_home_hud()

func draw_home_world_background() -> void:
	var sky := ColorRect.new()
	sky.color = Color(0.11, 0.17, 0.2, 1.0)
	sky.size = Vector2(HOME_WORLD_WIDTH, VIEWPORT_SIZE.y)
	level_root.add_child(sky)
	for band in range(5):
		var strip := ColorRect.new()
		strip.color = Color(0.12 + band * 0.025, 0.18 + band * 0.018, 0.21 + band * 0.01, 0.42)
		strip.position = Vector2(0, 60 + band * 54)
		strip.size = Vector2(HOME_WORLD_WIDTH, 34)
		level_root.add_child(strip)
	add_background_sun(Vector2(510, 92))
	add_background_cloud(Vector2(210, 108), 1.0)
	add_background_cloud(Vector2(930, 78), 1.2)
	add_background_cloud(Vector2(1510, 124), 0.9)
	add_background_mountains(HOME_WORLD_WIDTH, 316, Color(0.12, 0.18, 0.2), Color(0.2, 0.27, 0.25))
	for i in range(10):
		add_ruin_silhouette(Vector2(70 + i * 190, 274 + sin(i) * 24), 0.85 + float(i % 3) * 0.14)
	create_platform(Rect2(0, 500, HOME_WORLD_WIDTH, 40))
	var road := ColorRect.new()
	road.color = Color(0.55, 0.45, 0.28, 1.0)
	road.position = Vector2(32, 486)
	road.size = Vector2(HOME_WORLD_WIDTH - 64, 14)
	level_root.add_child(road)
	for i in range(42):
		add_grass_tuft(Vector2(28 + i * 45, 500), Color(0.28, 0.56, 0.32))

func add_background_sun(pos: Vector2) -> void:
	var sun := ColorRect.new()
	sun.color = Color(0.96, 0.68, 0.28, 0.78)
	sun.position = pos
	sun.size = Vector2(120, 22)
	level_root.add_child(sun)
	var glow := ColorRect.new()
	glow.color = Color(0.96, 0.68, 0.28, 0.22)
	glow.position = pos + Vector2(-38, -18)
	glow.size = Vector2(196, 58)
	level_root.add_child(glow)

func add_background_cloud(pos: Vector2, scale: float) -> void:
	var cloud_color := Color(0.82, 0.9, 0.88, 0.34)
	for i in range(5):
		var puff := ColorRect.new()
		puff.color = cloud_color
		puff.position = pos + Vector2(float(i) * 24.0 * scale, sin(i) * 8.0 * scale)
		puff.size = Vector2(42.0 * scale, 18.0 * scale)
		level_root.add_child(puff)

func add_background_mountains(width: float, base_y: float, far_color: Color, near_color: Color) -> void:
	for layer in range(2):
		var color := far_color if layer == 0 else near_color
		var y_offset := float(layer) * 38.0
		for x in range(-160, int(width) + 240, 240):
			var peak_index := posmod(int(x / 80) + layer * 3, 5)
			var peak_height := 110.0 + float(peak_index) * 18.0
			var mountain := Polygon2D.new()
			mountain.color = Color(color.r, color.g, color.b, 0.72 if layer == 0 else 0.88)
			mountain.polygon = PackedVector2Array([
				Vector2(x, base_y + y_offset),
				Vector2(x + 120, base_y - peak_height + y_offset),
				Vector2(x + 280, base_y + y_offset)
			])
			level_root.add_child(mountain)

func add_ruin_silhouette(pos: Vector2, scale: float) -> void:
	var body := ColorRect.new()
	body.color = Color(0.16, 0.15, 0.12, 0.86)
	body.position = pos
	body.size = Vector2(58.0 * scale, 226.0 * scale)
	level_root.add_child(body)
	var cap := ColorRect.new()
	cap.color = Color(0.23, 0.2, 0.15, 0.9)
	cap.position = pos + Vector2(-10.0 * scale, -20.0 * scale)
	cap.size = Vector2(78.0 * scale, 22.0 * scale)
	level_root.add_child(cap)
	for i in range(3):
		var slit := ColorRect.new()
		slit.color = Color(0.07, 0.09, 0.09, 0.72)
		slit.position = pos + Vector2(14.0 * scale, (38.0 + i * 54.0) * scale)
		slit.size = Vector2(12.0 * scale, 24.0 * scale)
		level_root.add_child(slit)

func add_grass_tuft(pos: Vector2, color: Color) -> void:
	for i in range(3):
		var blade := ColorRect.new()
		blade.color = color.lightened(float(i) * 0.08)
		blade.position = pos + Vector2(float(i) * 5.0, -8.0 - float(i % 2) * 4.0)
		blade.size = Vector2(3.0, 10.0 + float(i % 2) * 4.0)
		level_root.add_child(blade)

func create_home_station(station_id: String, pos: Vector2, label_text: String, accent: Color) -> void:
	var station := Node2D.new()
	station.name = "Home_%s" % station_id
	station.position = pos
	var base := ColorRect.new()
	base.position = Vector2(-34, -66)
	base.size = Vector2(68, 66)
	base.color = Color(0.18, 0.16, 0.12)
	station.add_child(base)
	var roof := ColorRect.new()
	roof.position = Vector2(-44, -82)
	roof.size = Vector2(88, 18)
	roof.color = accent
	station.add_child(roof)
	if station_id == "core":
		var core := ColorRect.new()
		core.position = Vector2(-20, -112)
		core.size = Vector2(40, 40)
		core.color = accent
		station.add_child(core)
	elif station_id == "expedition":
		var gate_left := ColorRect.new()
		gate_left.position = Vector2(-42, -128)
		gate_left.size = Vector2(18, 62)
		gate_left.color = Color(0.42, 0.36, 0.25)
		station.add_child(gate_left)
		var gate_right := ColorRect.new()
		gate_right.position = Vector2(24, -128)
		gate_right.size = Vector2(18, 62)
		gate_right.color = Color(0.42, 0.36, 0.25)
		station.add_child(gate_right)
		var gate_light := ColorRect.new()
		gate_light.position = Vector2(-20, -112)
		gate_light.size = Vector2(40, 46)
		gate_light.color = Color(0.95, 0.64, 0.22, 0.45)
		station.add_child(gate_light)
	var label := make_world_label(label_text, Vector2(-90, -132), Vector2(180, 30), 14)
	station.add_child(label)
	var prompt := make_world_label(t("interact_prompt"), Vector2(-70, -100), Vector2(140, 24), 13)
	prompt.add_theme_color_override("font_color", Color(0.94, 0.84, 0.58))
	station.add_child(prompt)
	level_root.add_child(station)
	home_interactables.append({
		"id": station_id,
		"position": pos,
		"range": 76.0
	})

func show_home_hud() -> void:
	var next_name := level_text(levels[0], "name") if levels.size() > 0 else "--"
	var panel := ColorRect.new()
	panel.color = Color(0.035, 0.04, 0.045, 0.82)
	panel.position = Vector2(10, 8)
	panel.size = Vector2(940, 64)
	ui_root.add_child(panel)
	var status := make_label(t("home_status") % [next_name, coins, max_lives], 15, Vector2(20, 12), Vector2(920, 24), HORIZONTAL_ALIGNMENT_CENTER)
	status.add_theme_color_override("font_color", Color(0.96, 0.86, 0.55))
	ui_root.add_child(status)
	var tip := make_label(t("home_walk_tip"), 13, Vector2(20, 36), Vector2(920, 26), HORIZONTAL_ALIGNMENT_CENTER)
	tip.add_theme_color_override("font_color", Color(0.72, 0.78, 0.76))
	ui_root.add_child(tip)
	if home_message != "":
		var message := make_label(home_message, 14, Vector2(0, 78), Vector2(VIEWPORT_SIZE.x, 24), HORIZONTAL_ALIGNMENT_CENTER)
		message.add_theme_color_override("font_color", Color(0.94, 0.84, 0.58))
		ui_root.add_child(message)

func remember_home_position() -> void:
	if player and is_instance_valid(player):
		home_resume_position = player.global_position
		has_home_resume_position = true

func reset_home_state() -> void:
	current_level = 0
	unlocked_level = 0
	max_lives = MAX_LIVES
	player_lives = max_lives
	coins = STARTING_COINS
	has_long_sword = false
	backpack = {"potion": 0}
	purchased_items = {}
	equipment = {
		"weapon": "short_sword",
		"boots": "worn_boots",
		"armor": "cloth",
		"charm": "none"
	}
	unlocked_skills = {}
	equipped_skills = {"K": "", "L": ""}
	skill_cooldowns = {
		"pyroblast": 0.0,
		"tidal_wave": 0.0,
		"clock_snare": 0.0,
		"dawn_barrier": 0.0
	}
	armor_charges = 0
	has_home_resume_position = false
	home_resume_position = Vector2.ZERO
	home_message = ""

func show_home_shop(message: String = "") -> void:
	state = "home_shop"
	clear_level()
	clear_ui()
	add_panel_background(Color(0.045, 0.055, 0.045, 1.0))
	ui_root.add_child(make_label(t("home_shop"), 34, Vector2(0, 42), Vector2(VIEWPORT_SIZE.x, 48), HORIZONTAL_ALIGNMENT_CENTER))
	ui_root.add_child(make_label("%s: %s    %s: %s" % [t("coins"), coins, t("inventory"), int(backpack.get("potion", 0))], 17, Vector2(0, 94), Vector2(VIEWPORT_SIZE.x, 28), HORIZONTAL_ALIGNMENT_CENTER))

	for i in range(HOME_SHOP_ORDER.size()):
		var item_id: String = HOME_SHOP_ORDER[i]
		var col := i % 3
		var row := i / 3
		add_home_shop_button(item_id, Vector2(36 + col * 306, 132 + row * 76))

	if message != "":
		var label := make_label(message, 16, Vector2(0, 432), Vector2(VIEWPORT_SIZE.x, 30), HORIZONTAL_ALIGNMENT_CENTER)
		label.add_theme_color_override("font_color", Color(0.94, 0.84, 0.58))
		ui_root.add_child(label)

	var back := make_button(t("back"), Vector2(360, 476), Vector2(240, 40))
	back.pressed.connect(func() -> void: show_main_menu())
	ui_root.add_child(back)

func add_item_icon_ui(item_id: String, pos: Vector2) -> void:
	var frame := ColorRect.new()
	frame.position = pos
	frame.size = Vector2(48, 48)
	frame.color = Color(0.1, 0.12, 0.13, 0.95)
	ui_root.add_child(frame)
	var accent := item_ui_color(item_id)
	var glow := ColorRect.new()
	glow.position = pos + Vector2(4, 4)
	glow.size = Vector2(40, 40)
	glow.color = Color(accent.r, accent.g, accent.b, 0.22)
	ui_root.add_child(glow)
	match item_id:
		"potion":
			add_ui_rect(pos + Vector2(18, 12), Vector2(12, 24), Color(0.32, 0.95, 0.58))
			add_ui_rect(pos + Vector2(20, 7), Vector2(8, 6), Color(0.94, 0.82, 0.54))
			add_ui_rect(pos + Vector2(21, 16), Vector2(3, 12), Color(0.82, 1.0, 0.84, 0.8))
		"long_sword", "dawn_blade", "storm_sword":
			add_ui_rect(pos + Vector2(22, 8), Vector2(5, 26), accent)
			add_ui_rect(pos + Vector2(17, 31), Vector2(15, 4), Color(0.78, 0.52, 0.22))
			add_ui_rect(pos + Vector2(20, 35), Vector2(9, 7), Color(0.36, 0.22, 0.12))
			if item_id == "storm_sword":
				add_ui_rect(pos + Vector2(14, 12), Vector2(4, 18), Color(0.44, 0.78, 1.0, 0.8))
		"swift_boots", "wing_boots", "anchor_boots":
			add_ui_rect(pos + Vector2(11, 24), Vector2(12, 13), accent)
			add_ui_rect(pos + Vector2(25, 20), Vector2(12, 17), accent.lightened(0.1))
			add_ui_rect(pos + Vector2(9, 36), Vector2(31, 5), Color(0.12, 0.2, 0.22))
			if item_id == "wing_boots":
				add_ui_rect(pos + Vector2(31, 12), Vector2(10, 5), Color(0.9, 0.96, 1.0))
			if item_id == "anchor_boots":
				add_ui_rect(pos + Vector2(14, 16), Vector2(22, 4), Color(0.92, 0.82, 0.44))
		"bronze_armor", "glass_armor":
			add_ui_rect(pos + Vector2(14, 12), Vector2(20, 26), accent)
			add_ui_rect(pos + Vector2(10, 15), Vector2(7, 10), accent.darkened(0.18))
			add_ui_rect(pos + Vector2(31, 15), Vector2(7, 10), accent.darkened(0.18))
			if item_id == "glass_armor":
				add_ui_rect(pos + Vector2(17, 15), Vector2(14, 20), Color(0.86, 1.0, 1.0, 0.45))
		"coin_charm", "medic_charm", "dawn_charm":
			add_ui_rect(pos + Vector2(19, 10), Vector2(10, 8), Color(0.72, 0.58, 0.24))
			add_ui_rect(pos + Vector2(15, 18), Vector2(18, 18), accent)
			add_ui_rect(pos + Vector2(20, 23), Vector2(8, 8), Color(1.0, 0.96, 0.72, 0.75))

func add_item_icon_ui_small(item_id: String, pos: Vector2) -> void:
	var accent := item_ui_color(item_id)
	add_ui_rect(pos, Vector2(30, 30), Color(0.1, 0.12, 0.13, 0.95))
	add_ui_rect(pos + Vector2(3, 3), Vector2(24, 24), Color(accent.r, accent.g, accent.b, 0.2))
	match item_id:
		"potion":
			add_ui_rect(pos + Vector2(12, 8), Vector2(7, 16), Color(0.32, 0.95, 0.58))
			add_ui_rect(pos + Vector2(13, 5), Vector2(5, 4), Color(0.94, 0.82, 0.54))
		"long_sword", "dawn_blade", "storm_sword":
			add_ui_rect(pos + Vector2(14, 5), Vector2(4, 18), accent)
			add_ui_rect(pos + Vector2(10, 21), Vector2(12, 3), Color(0.78, 0.52, 0.22))
		"swift_boots", "wing_boots", "anchor_boots":
			add_ui_rect(pos + Vector2(7, 16), Vector2(8, 9), accent)
			add_ui_rect(pos + Vector2(16, 13), Vector2(8, 12), accent.lightened(0.1))
		"bronze_armor", "glass_armor":
			add_ui_rect(pos + Vector2(9, 7), Vector2(13, 18), accent)
		"coin_charm", "medic_charm", "dawn_charm":
			add_ui_rect(pos + Vector2(10, 10), Vector2(12, 12), accent)

func add_ui_rect(pos: Vector2, size: Vector2, color: Color) -> void:
	var rect := ColorRect.new()
	rect.position = pos
	rect.size = size
	rect.color = color
	ui_root.add_child(rect)

func add_world_sprite(parent: Node, texture: Texture2D, pos: Vector2, size: Vector2, modulate_color: Color = Color.WHITE) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.centered = true
	sprite.position = pos + size / 2.0
	if texture:
		sprite.scale = Vector2(size.x / maxf(float(texture.get_width()), 1.0), size.y / maxf(float(texture.get_height()), 1.0))
	sprite.modulate = modulate_color
	parent.add_child(sprite)
	return sprite

func region_background_texture() -> Texture2D:
	match current_region_id():
		2:
			return TEX_BG_WATERWORKS
		3:
			return TEX_BG_CLOCKTOWER
		4:
			return TEX_BG_CORE
	return TEX_BG_RUINS

func region_tile_texture() -> Texture2D:
	match current_region_id():
		2:
			return TEX_TILE_GREEN
		3:
			return TEX_TILE_GREY
		4:
			return TEX_TILE_RED
	return TEX_TILE_BROWN

func skill_texture(skill_id: String) -> Texture2D:
	match skill_id:
		"tidal_wave":
			return TEX_SKILL_TIDAL_WAVE
		"clock_snare":
			return TEX_SKILL_CLOCK_SNARE
		"dawn_barrier":
			return TEX_SKILL_DAWN_BARRIER
	return TEX_SKILL_PYROBLAST

func item_ui_color(item_id: String) -> Color:
	match item_id:
		"potion":
			return Color(0.32, 0.95, 0.58)
		"long_sword":
			return Color(0.84, 0.88, 0.9)
		"dawn_blade":
			return Color(0.72, 0.96, 1.0)
		"storm_sword":
			return Color(0.48, 0.72, 1.0)
		"swift_boots":
			return Color(0.34, 0.78, 0.92)
		"wing_boots":
			return Color(0.78, 0.9, 1.0)
		"anchor_boots":
			return Color(0.46, 0.58, 0.72)
		"bronze_armor":
			return Color(0.76, 0.46, 0.22)
		"glass_armor":
			return Color(0.62, 0.92, 1.0)
		"coin_charm":
			return Color(0.95, 0.78, 0.24)
		"medic_charm":
			return Color(0.86, 0.28, 0.42)
		"dawn_charm":
			return Color(1.0, 0.86, 0.38)
	return Color(0.72, 0.72, 0.72)

func add_home_shop_button(item_id: String, pos: Vector2) -> void:
	var cost := item_cost(item_id)
	var button_text := home_shop_label_for(item_id)
	if item_id != "potion":
		if purchased_items.has(item_id):
			button_text = "%s (%s)" % [item_display_name(item_id), t("owned")]
		else:
			button_text = "%s - %s %s" % [item_display_name(item_id), cost, t("coins")]
	add_ui_rect(pos + Vector2(-8, -6), Vector2(286, 62), Color(0.07, 0.085, 0.075, 0.86))
	add_item_icon_ui(item_id, pos + Vector2(0, 0))
	var button := make_button(button_text, pos + Vector2(58, 0), Vector2(212, 32))
	button.disabled = item_id != "potion" and purchased_items.has(item_id)
	button.add_theme_font_size_override("font_size", 15)
	button.pressed.connect(func() -> void: buy_home_item(item_id))
	ui_root.add_child(button)

	var effect := make_label(equipment_effect_summary(item_id), 11, pos + Vector2(58, 30), Vector2(214, 30), HORIZONTAL_ALIGNMENT_CENTER)
	effect.add_theme_color_override("font_color", Color(0.76, 0.8, 0.7))
	ui_root.add_child(effect)

func buy_home_item(item_id: String) -> void:
	var cost := item_cost(item_id)
	if item_id != "potion" and purchased_items.has(item_id):
		show_home_shop(t("owned"))
		return
	if coins < cost:
		show_home_shop(t("shop_no_money"))
		return
	coins -= cost
	if item_id == "potion":
		backpack["potion"] = int(backpack.get("potion", 0)) + 1
	else:
		purchased_items[item_id] = true
		equip_item(item_id)
	play_sfx("buy")
	save_run()
	show_home_shop(t("potion_stored") if item_id == "potion" else t("equipped"))

func item_cost(item_id: String) -> int:
	if item_id == "potion":
		return HOME_POTION_COST
	if EQUIPMENT_ITEMS.has(item_id):
		return int(EQUIPMENT_ITEMS[item_id].get("cost", 0))
	return 0

func home_shop_label_for(item_id: String) -> String:
	match item_id:
		"potion":
			return t("buy_home_potion")
		"long_sword":
			return t("buy_home_sword")
		"swift_boots":
			return t("buy_home_boots")
		"bronze_armor":
			return t("buy_home_armor")
		"coin_charm":
			return t("buy_home_charm")
		"medic_charm":
			return t("buy_home_medic")
		"wing_boots":
			return t("buy_home_wing_boots")
		"dawn_blade":
			return t("buy_home_dawn_blade")
		"storm_sword":
			return t("buy_home_storm_sword")
		"anchor_boots":
			return t("buy_home_anchor_boots")
		"glass_armor":
			return t("buy_home_glass_armor")
		"dawn_charm":
			return t("buy_home_dawn_charm")
	return item_display_name(item_id)

func item_display_name(item_id: String) -> String:
	return t("item_%s" % item_id)

func slot_display_name(slot: String) -> String:
	return t("slot_%s" % slot)

func weapon_stats_for(weapon_id: String) -> Dictionary:
	if WEAPON_STATS.has(weapon_id):
		return WEAPON_STATS[weapon_id]
	return WEAPON_STATS["short_sword"]

func boot_stats_for(boots_id: String) -> Dictionary:
	if BOOT_STATS.has(boots_id):
		return BOOT_STATS[boots_id]
	return BOOT_STATS["worn_boots"]

func weapon_attack_damage() -> int:
	return int(weapon_stats_for(str(equipment.get("weapon", "short_sword"))).get("damage", 1))

func equipment_effect_summary(item_id: String) -> String:
	var effect_key := "effect_%s" % item_id
	var effect_text := t(effect_key)
	return "" if effect_text == effect_key else effect_text

func equip_item(item_id: String) -> void:
	if not EQUIPMENT_ITEMS.has(item_id):
		return
	var data: Dictionary = EQUIPMENT_ITEMS[item_id]
	var slot := str(data.get("slot", ""))
	equipment[slot] = str(data.get("value", item_id))
	var weapon := str(equipment.get("weapon", "short_sword"))
	has_long_sword = weapon == "long_sword" or weapon == "storm_sword" or weapon == "dawn_blade"

func is_item_equipped(item_id: String) -> bool:
	if not EQUIPMENT_ITEMS.has(item_id):
		return false
	var data: Dictionary = EQUIPMENT_ITEMS[item_id]
	return str(equipment.get(str(data.get("slot", "")), "")) == str(data.get("value", item_id))

func show_core(message: String = "") -> void:
	state = "core"
	clear_level()
	clear_ui()
	add_panel_background(Color(0.04, 0.05, 0.065, 1.0))
	ui_root.add_child(make_label(t("core"), 34, Vector2(0, 82), Vector2(VIEWPORT_SIZE.x, 54), HORIZONTAL_ALIGNMENT_CENTER))
	ui_root.add_child(make_label("%s: %s    %s: %s" % [t("coins"), coins, t("max_life"), max_lives], 18, Vector2(0, 150), Vector2(VIEWPORT_SIZE.x, 34), HORIZONTAL_ALIGNMENT_CENTER))
	var cost := core_upgrade_cost()
	var upgrade_text := t("core_maxed") if max_lives >= HOME_MAX_LIFE_CAP else "%s (%s)" % [t("core_upgrade"), t("core_cost") % cost]
	var upgrade := make_button(upgrade_text, Vector2(300, 232), Vector2(360, 46))
	upgrade.disabled = max_lives >= HOME_MAX_LIFE_CAP
	upgrade.pressed.connect(func() -> void: buy_core_life())
	ui_root.add_child(upgrade)
	if message != "":
		var label := make_label(message, 16, Vector2(0, 304), Vector2(VIEWPORT_SIZE.x, 34), HORIZONTAL_ALIGNMENT_CENTER)
		label.add_theme_color_override("font_color", Color(0.94, 0.84, 0.58))
		ui_root.add_child(label)
	var back := make_button(t("back"), Vector2(360, 382), Vector2(240, 42))
	back.pressed.connect(func() -> void: show_main_menu())
	ui_root.add_child(back)

func core_upgrade_cost() -> int:
	return CORE_LIFE_BASE_COST + (max_lives - MAX_LIVES) * CORE_LIFE_STEP_COST

func buy_core_life() -> void:
	if max_lives >= HOME_MAX_LIFE_CAP:
		show_core(t("core_maxed"))
		return
	var cost := core_upgrade_cost()
	if coins < cost:
		show_core(t("shop_no_money"))
		return
	coins -= cost
	max_lives += 1
	player_lives = max_lives
	play_sfx("buy")
	save_run()
	show_core(t("core_upgraded"))

func show_inventory(message: String = "") -> void:
	var previous_state := state
	inventory_return_state = previous_state
	state = "inventory"
	clear_ui()
	if previous_state == "playing" or previous_state == "paused" or previous_state == "shop":
		paused = true
		if player:
			player.enabled = false
		add_translucent_overlay()
	elif previous_state == "home" or previous_state == "home_pause":
		remember_home_position()
		paused = true
		if player:
			player.enabled = false
		add_translucent_overlay()
	else:
		clear_level()
		add_panel_background(Color(0.045, 0.045, 0.05, 1.0))
	ui_root.add_child(make_label(t("inventory_title"), 34, Vector2(0, 42), Vector2(VIEWPORT_SIZE.x, 54), HORIZONTAL_ALIGNMENT_CENTER))
	var summary := t("inventory_summary") % [
		backpack.get("potion", 0),
		item_display_name(str(equipment.get("weapon", "short_sword"))),
		item_display_name(str(equipment.get("boots", "worn_boots"))),
		item_display_name(str(equipment.get("armor", "cloth"))),
		item_display_name(str(equipment.get("charm", "none")))
	]
	ui_root.add_child(make_label(summary, 16, Vector2(60, 104), Vector2(840, 52), HORIZONTAL_ALIGNMENT_CENTER))
	ui_root.add_child(make_label("%s: %s    %s: %s" % [t("coins"), coins, t("max_life"), max_lives], 18, Vector2(0, 154), Vector2(VIEWPORT_SIZE.x, 34), HORIZONTAL_ALIGNMENT_CENTER))

	add_inventory_slot("weapon", Vector2(88, 214), ["long_sword", "dawn_blade"])
	add_inventory_slot("boots", Vector2(516, 214), ["swift_boots", "wing_boots"])
	add_inventory_slot("armor", Vector2(88, 326), ["bronze_armor"])
	add_inventory_slot("charm", Vector2(516, 326), ["coin_charm", "medic_charm"])

	if message != "":
		var label := make_label(message, 16, Vector2(0, 422), Vector2(VIEWPORT_SIZE.x, 30), HORIZONTAL_ALIGNMENT_CENTER)
		label.add_theme_color_override("font_color", Color(0.94, 0.84, 0.58))
		ui_root.add_child(label)

	var back := make_button(t("back"), Vector2(360, 470), Vector2(240, 42))
	back.pressed.connect(func() -> void: close_inventory())
	ui_root.add_child(back)

func close_inventory() -> void:
	if inventory_return_state == "playing" or inventory_return_state == "paused" or inventory_return_state == "shop":
		resume_game()
	elif inventory_return_state == "home" or inventory_return_state == "home_pause":
		resume_home()
	else:
		show_main_menu()

func show_skills(message: String = "") -> void:
	var previous_state := state
	skill_return_state = previous_state
	state = "skills"
	clear_ui()
	if previous_state == "playing" or previous_state == "paused" or previous_state == "shop":
		paused = true
		if player:
			player.enabled = false
		add_translucent_overlay()
	elif previous_state == "home" or previous_state == "home_pause":
		remember_home_position()
		paused = true
		if player:
			player.enabled = false
		add_translucent_overlay()
	else:
		clear_level()
		add_panel_background(Color(0.045, 0.04, 0.05, 1.0))
	ui_root.add_child(make_label(t("skills_title"), 34, Vector2(0, 54), Vector2(VIEWPORT_SIZE.x, 50), HORIZONTAL_ALIGNMENT_CENTER))
	var summary := t("skill_summary") % [skill_display_name(str(equipped_skills.get("K", ""))), skill_display_name(str(equipped_skills.get("L", "")))]
	ui_root.add_child(make_label(summary, 18, Vector2(0, 112), Vector2(VIEWPORT_SIZE.x, 34), HORIZONTAL_ALIGNMENT_CENTER))
	for i in range(SKILL_IDS.size()):
		add_skill_row(SKILL_IDS[i], Vector2(250, 162 + i * 82))
	if message != "":
		var label := make_label(message, 16, Vector2(0, 474), Vector2(VIEWPORT_SIZE.x, 24), HORIZONTAL_ALIGNMENT_CENTER)
		label.add_theme_color_override("font_color", Color(0.94, 0.84, 0.58))
		ui_root.add_child(label)
	var back := make_button(t("back"), Vector2(360, 502), Vector2(240, 32))
	back.pressed.connect(func() -> void: close_skills())
	ui_root.add_child(back)

func add_skill_row(skill_id: String, pos: Vector2) -> void:
	add_ui_rect(pos + Vector2(-10, -8), Vector2(460, 96), Color(0.08, 0.06, 0.055, 0.88))
	add_skill_icon_ui(skill_id, pos + Vector2(0, 8))
	var owned := unlocked_skills.has(skill_id)
	var name_text := skill_display_name(skill_id) if owned else "%s (%s)" % [skill_display_name(skill_id), t("skill_locked")]
	var name := make_label(name_text, 18, pos + Vector2(74, 0), Vector2(360, 30), HORIZONTAL_ALIGNMENT_LEFT)
	name.add_theme_color_override("font_color", Color(1.0, 0.78, 0.42) if owned else Color(0.48, 0.5, 0.5))
	ui_root.add_child(name)
	var k_button := make_button(t("equip_k"), pos + Vector2(76, 42), Vector2(150, 34))
	k_button.disabled = not owned
	k_button.pressed.connect(func() -> void: equip_skill_to_slot(skill_id, "K"))
	ui_root.add_child(k_button)
	var l_button := make_button(t("equip_l"), pos + Vector2(238, 42), Vector2(150, 34))
	l_button.disabled = not owned
	l_button.pressed.connect(func() -> void: equip_skill_to_slot(skill_id, "L"))
	ui_root.add_child(l_button)

func add_skill_icon_ui(skill_id: String, pos: Vector2) -> void:
	add_ui_rect(pos, Vector2(58, 58), Color(0.12, 0.07, 0.05, 0.96))
	if skill_id == "pyroblast":
		add_ui_rect(pos + Vector2(20, 8), Vector2(18, 42), Color(0.95, 0.24, 0.08))
		add_ui_rect(pos + Vector2(25, 18), Vector2(8, 26), Color(1.0, 0.82, 0.22))
		add_ui_rect(pos + Vector2(14, 28), Vector2(30, 14), Color(0.75, 0.08, 0.04, 0.8))
	elif skill_id == "tidal_wave":
		add_ui_rect(pos + Vector2(8, 24), Vector2(44, 10), Color(0.18, 0.66, 0.95))
		add_ui_rect(pos + Vector2(16, 16), Vector2(28, 8), Color(0.48, 0.88, 1.0, 0.75))
		add_ui_rect(pos + Vector2(24, 34), Vector2(18, 6), Color(0.82, 1.0, 1.0, 0.72))
	elif skill_id == "clock_snare":
		add_ui_rect(pos + Vector2(17, 10), Vector2(24, 34), Color(0.78, 0.68, 0.36))
		add_ui_rect(pos + Vector2(27, 14), Vector2(4, 22), Color(0.16, 0.11, 0.07))
		add_ui_rect(pos + Vector2(20, 36), Vector2(18, 5), Color(0.9, 0.78, 0.42))
	elif skill_id == "dawn_barrier":
		add_ui_rect(pos + Vector2(12, 12), Vector2(34, 36), Color(1.0, 0.78, 0.24, 0.36))
		add_ui_rect(pos + Vector2(18, 20), Vector2(22, 20), Color(1.0, 0.94, 0.62, 0.55))

func skill_display_name(skill_id: String) -> String:
	if skill_id == "":
		return "-"
	return t("skill_%s" % skill_id)

func equip_skill_to_slot(skill_id: String, slot: String) -> void:
	if not unlocked_skills.has(skill_id):
		show_skills(t("skill_locked"))
		return
	equipped_skills[slot] = skill_id
	play_sfx("ui")
	save_run()
	show_skills(t("equipped"))

func first_unlocked_skill() -> String:
	for skill_id in SKILL_IDS:
		if unlocked_skills.has(skill_id):
			return skill_id
	return ""

func close_skills() -> void:
	if skill_return_state == "playing" or skill_return_state == "paused" or skill_return_state == "shop":
		resume_game()
	elif skill_return_state == "home" or skill_return_state == "home_pause":
		resume_home()
	else:
		show_main_menu()

func add_inventory_slot(slot: String, pos: Vector2, item_ids: Array) -> void:
	var title := make_label("%s: %s" % [slot_display_name(slot), item_display_name(str(equipment.get(slot, "none")))], 17, pos, Vector2(356, 28), HORIZONTAL_ALIGNMENT_LEFT)
	title.add_theme_color_override("font_color", Color(0.94, 0.84, 0.58))
	ui_root.add_child(title)
	for i in range(item_ids.size()):
		var item_id: String = item_ids[i]
		var row_pos := pos + Vector2(0, 36 + i * 50)
		add_ui_rect(row_pos + Vector2(-6, -3), Vector2(348, 44), Color(0.07, 0.08, 0.085, 0.78))
		add_item_icon_ui_small(item_id, row_pos + Vector2(0, 0))
		if not purchased_items.has(item_id):
			var locked := make_label("%s - %s %s" % [item_display_name(item_id), item_cost(item_id), t("coins")], 14, row_pos + Vector2(40, 0), Vector2(300, 30), HORIZONTAL_ALIGNMENT_LEFT)
			locked.add_theme_color_override("font_color", Color(0.48, 0.52, 0.5))
			ui_root.add_child(locked)
		else:
			var button_text := "%s (%s)" % [item_display_name(item_id), t("equipped")] if is_item_equipped(item_id) else "%s: %s" % [t("equip"), item_display_name(item_id)]
			var button := make_button(button_text, row_pos + Vector2(40, 0), Vector2(294, 26))
			button.disabled = is_item_equipped(item_id)
			button.add_theme_font_size_override("font_size", 15)
			button.pressed.connect(func() -> void:
				equip_item(item_id)
				save_run()
				show_inventory(t("equipped"))
			)
			ui_root.add_child(button)
		var effect := make_label(equipment_effect_summary(item_id), 12, row_pos + Vector2(40, 24), Vector2(292, 18), HORIZONTAL_ALIGNMENT_LEFT)
		effect.add_theme_color_override("font_color", Color(0.74, 0.79, 0.71))
		ui_root.add_child(effect)

func show_settings() -> void:
	state = "settings"
	clear_ui()
	add_panel_background(Color(0.04, 0.05, 0.06, 1.0))
	ui_root.add_child(make_label(t("settings_title"), 34, Vector2(0, 56), Vector2(VIEWPORT_SIZE.x, 50), HORIZONTAL_ALIGNMENT_CENTER))
	add_volume_control("Master", "master_volume", 126)
	add_volume_control("Music", "music_volume", 176)
	add_volume_control("SFX", "sfx_volume", 226)
	add_volume_control("UI", "ui_volume", 276)

	var language_button := make_button(language_button_text(), Vector2(310, 344), Vector2(340, 42))
	language_button.pressed.connect(func() -> void: toggle_language())
	ui_root.add_child(language_button)

	var back := make_button(t("back"), Vector2(360, 402), Vector2(240, 42))
	back.pressed.connect(func() -> void: show_main_menu())
	ui_root.add_child(back)

func add_volume_control(bus_name: String, label_key: String, y: float) -> void:
	ui_root.add_child(make_label(t(label_key), 16, Vector2(248, y), Vector2(200, 26), HORIZONTAL_ALIGNMENT_RIGHT))
	var slider := HSlider.new()
	slider.position = Vector2(468, y)
	slider.size = Vector2(260, 28)
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.01
	slider.value = audio_manager.get_volume(bus_name) if audio_manager else master_volume
	slider.value_changed.connect(func(value: float) -> void:
		if bus_name == "Master":
			master_volume = value
		if audio_manager:
			audio_manager.set_volume(bus_name, value)
			audio_manager.play_sfx("ui")
		save_settings()
	)
	ui_root.add_child(slider)

func show_network_menu() -> void:
	state = "network"
	clear_ui()
	add_panel_background(Color(0.04, 0.05, 0.06, 1.0))
	ui_root.add_child(make_label(t("network_title"), 34, Vector2(0, 74), Vector2(VIEWPORT_SIZE.x, 54), HORIZONTAL_ALIGNMENT_CENTER))
	ui_root.add_child(make_label(t("network_note"), 16, Vector2(120, 136), Vector2(720, 54), HORIZONTAL_ALIGNMENT_CENTER))
	ui_root.add_child(make_label("%s: %s" % [t("network_status"), network_message], 18, Vector2(0, 196), Vector2(VIEWPORT_SIZE.x, 34), HORIZONTAL_ALIGNMENT_CENTER))

	var host := make_button(t("host_game"), Vector2(360, 252), Vector2(240, 42))
	host.pressed.connect(func() -> void:
		network_manager.host()
	)
	ui_root.add_child(host)

	var join := make_button(t("join_local"), Vector2(360, 304), Vector2(240, 42))
	join.pressed.connect(func() -> void:
		network_manager.join("127.0.0.1")
	)
	ui_root.add_child(join)

	var stop := make_button(t("stop_network"), Vector2(360, 356), Vector2(240, 42))
	stop.pressed.connect(func() -> void:
		network_manager.stop()
		network_message = network_manager.status()
		show_network_menu()
	)
	ui_root.add_child(stop)

	var back := make_button(t("back"), Vector2(360, 420), Vector2(240, 42))
	back.pressed.connect(func() -> void: show_main_menu())
	ui_root.add_child(back)

func start_game() -> void:
	current_level = 0
	player_lives = max_lives
	armor_charges = starting_armor_charges()
	has_home_resume_position = false
	shop_message = ""
	save_run()
	load_level(current_level)

func continue_game() -> void:
	var data: Dictionary = save_manager.load_game()
	if data.is_empty():
		show_main_menu()
		return
	load_home_state()
	show_main_menu()

func save_run() -> void:
	if not save_manager:
		return
	save_manager.save_game({
		"version": 2,
		"current_level": current_level,
		"unlocked_level": unlocked_level,
		"current_region": current_region_id(),
		"player_lives": player_lives,
		"max_lives": max_lives,
		"coins": coins,
		"has_long_sword": has_long_sword,
		"backpack": backpack,
		"purchased_items": purchased_items,
		"equipment": equipment,
		"unlocked_skills": unlocked_skills,
		"skills_unlocked": unlocked_skills,
		"equipped_skills": equipped_skills,
		"skill_slots": equipped_skills,
		"language": language,
		"master_volume": master_volume,
		"best_times": {}
	})

func level_x(value) -> float:
	return float(value) * LEVEL_X_SCALE

func scaled_level_point(data: Array) -> Vector2:
	return Vector2(level_x(data[0]), float(data[1]))

func scaled_level_rect(data: Array) -> Rect2:
	return Rect2(level_x(data[0]), float(data[1]), float(data[2]) * LEVEL_X_SCALE, float(data[3]))

func scaled_enemy_data(data: Dictionary) -> Dictionary:
	var copy: Dictionary = data.duplicate(true)
	var pos_data: Array = copy.get("pos", [0, 0])
	copy["pos"] = [level_x(pos_data[0]), pos_data[1]]
	copy["patrol"] = float(copy.get("patrol", 40.0)) * LEVEL_X_SCALE
	return copy

func scaled_moving_platform_data(data: Dictionary) -> Dictionary:
	var copy := data.duplicate(true)
	var rect_data: Array = copy.get("rect", [0, 0, 96, 18])
	var from_data: Array = copy.get("from", [rect_data[0], rect_data[1]])
	var to_data: Array = copy.get("to", [rect_data[0], rect_data[1]])
	copy["rect"] = [level_x(rect_data[0]), rect_data[1], float(rect_data[2]) * LEVEL_X_SCALE, rect_data[3]]
	copy["from"] = [level_x(from_data[0]), from_data[1]]
	copy["to"] = [level_x(to_data[0]), to_data[1]]
	return copy

func scaled_key_data(data) -> Variant:
	if typeof(data) != TYPE_DICTIONARY:
		return [level_x(data[0]), data[1], data[2]]
	var copy: Dictionary = data.duplicate(true)
	var pos_data: Array = copy.get("pos", [0, 0])
	copy["pos"] = [level_x(pos_data[0]), pos_data[1]]
	return copy

func scaled_door_data(data: Dictionary) -> Dictionary:
	var copy := data.duplicate(true)
	var rect_data: Array = copy.get("rect", [0, 0, 34, 80])
	copy["rect"] = [level_x(rect_data[0]), rect_data[1], float(rect_data[2]) * LEVEL_X_SCALE, rect_data[3]]
	return copy

func load_level(index: int) -> void:
	state = "playing"
	paused = false
	clear_level()
	clear_ui()
	enemies.clear()
	keys_collected.clear()
	doors.clear()
	moving_platforms.clear()
	var data: Dictionary = levels[index]
	current_world_width = maxf(VIEWPORT_SIZE.x, VIEWPORT_SIZE.x * LEVEL_X_SCALE)

	level_root = Node2D.new()
	level_root.name = "Level"
	world.add_child(level_root)
	draw_level_background()

	checkpoint_position = scaled_level_point(data["start"])
	for rect_data in data["platforms"]:
		create_platform(scaled_level_rect(rect_data))
	for brittle_data in data.get("brittle_platforms", []):
		create_brittle_platform(scaled_level_rect(brittle_data))
	for moving_data in data.get("moving_platforms", []):
		create_moving_platform(scaled_moving_platform_data(moving_data))
	for hazard_data in data["hazards"]:
		create_hazard(scaled_level_rect(hazard_data))
	for door_data in data.get("doors", []):
		create_door(scaled_door_data(door_data))
	for key_data in data.get("keys", []):
		create_key(scaled_key_data(key_data))
	for enemy_data in data["enemies"]:
		create_enemy(scaled_enemy_data(enemy_data))
	create_goal(scaled_level_point(data["goal"]))
	if data.has("shop"):
		create_shop(scaled_level_point(data["shop"]))

	player = PlayerScript.new()
	player.name = "Player"
	player.game = self
	level_root.add_child(player)
	apply_player_equipment()
	player.reset_to(scaled_level_point(data["start"]), player_lives)

	show_hud()
	save_run()

func apply_player_equipment() -> void:
	if not player:
		return
	var weapon := str(equipment.get("weapon", "short_sword"))
	var boots := str(equipment.get("boots", "worn_boots"))
	var boot_stats := boot_stats_for(boots)
	player.speed = float(boot_stats.get("speed", 230.0))
	player.dash_speed = float(boot_stats.get("dash_speed", 520.0))
	player.dash_duration = float(boot_stats.get("dash_duration", 0.12))
	player.dash_cooldown_time = float(boot_stats.get("dash_cooldown", 0.45))
	player.max_jumps = int(boot_stats.get("max_jumps", 2))
	player.facing = 1.0 if player.facing >= 0.0 else -1.0
	has_long_sword = weapon == "long_sword" or weapon == "storm_sword" or weapon == "dawn_blade"

func starting_armor_charges() -> int:
	var armor := str(equipment.get("armor", "cloth"))
	if armor == "glass_armor":
		return 2
	if armor == "bronze_armor":
		return 1
	return 0

func clear_level() -> void:
	if level_root and is_instance_valid(level_root):
		level_root.queue_free()
	level_root = null
	player = null
	enemies.clear()
	coin_drops.clear()
	keys_collected.clear()
	doors.clear()
	moving_platforms.clear()
	home_interactables.clear()
	current_world_width = VIEWPORT_SIZE.x
	shop_available = false
	shop_position = Vector2.ZERO

func draw_level_background() -> void:
	var sky := ColorRect.new()
	sky.color = Color(0.07, 0.1, 0.13)
	sky.size = Vector2(current_world_width, VIEWPORT_SIZE.y)
	level_root.add_child(sky)
	add_world_sprite(level_root, region_background_texture(), Vector2(0, 0), Vector2(current_world_width, VIEWPORT_SIZE.y), Color(1.0, 1.0, 1.0, 0.72))
	for band in range(6):
		var strip := ColorRect.new()
		strip.color = Color(0.08 + band * 0.018, 0.11 + band * 0.015, 0.13 + band * 0.012, 0.5)
		strip.position = Vector2(0, 44 + band * 56)
		strip.size = Vector2(current_world_width, 34)
		level_root.add_child(strip)
	add_background_sun(Vector2(260 + float(current_level % 3) * 120.0, 76))
	add_background_cloud(Vector2(160, 108), 0.95)
	add_background_cloud(Vector2(current_world_width * 0.42, 72), 1.15)
	add_background_cloud(Vector2(current_world_width * 0.76, 126), 0.85)
	add_background_mountains(current_world_width, 318, Color(0.1, 0.13, 0.15), Color(0.18, 0.2, 0.18))
	for i in range(11):
		add_ruin_silhouette(Vector2(44 + i * 142, 308 + sin(i + current_level) * 34.0), 0.68 + float((i + current_level) % 4) * 0.1)
	for i in range(34):
		add_grass_tuft(Vector2(22 + i * 46, 500), Color(0.22, 0.44, 0.28))

func create_platform(rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.position = rect.position
	body.collision_layer = LAYER_WORLD
	body.collision_mask = 0

	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	shape.position = rect.size / 2.0
	body.add_child(shape)

	var visual := ColorRect.new()
	visual.color = Color(0.38, 0.34, 0.28, 0.28)
	visual.size = rect.size
	body.add_child(visual)
	add_world_sprite(body, region_tile_texture(), Vector2.ZERO, rect.size)

	var edge := ColorRect.new()
	edge.color = Color(0.68, 0.58, 0.38)
	edge.size = Vector2(rect.size.x, minf(5.0, rect.size.y))
	body.add_child(edge)
	for x in range(0, int(rect.size.x), 32):
		var seam := ColorRect.new()
		seam.color = Color(0.26, 0.23, 0.19, 0.55)
		seam.position = Vector2(x, 5)
		seam.size = Vector2(2, maxf(rect.size.y - 5, 4))
		body.add_child(seam)

	level_root.add_child(body)

func create_moving_platform(data: Dictionary) -> void:
	var rect_data: Array = data.get("rect", [0, 0, 96, 18])
	var from_data: Array = data.get("from", [rect_data[0], rect_data[1]])
	var to_data: Array = data.get("to", [rect_data[0], rect_data[1]])
	var rect := Rect2(rect_data[0], rect_data[1], rect_data[2], rect_data[3])
	var from_pos := Vector2(from_data[0], from_data[1])
	var to_pos := Vector2(to_data[0], to_data[1])

	var body := AnimatableBody2D.new()
	body.position = from_pos
	body.collision_layer = LAYER_WORLD
	body.collision_mask = 0

	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	shape.position = rect.size / 2.0
	body.add_child(shape)

	var visual := ColorRect.new()
	visual.color = Color(0.16, 0.42, 0.56, 0.22)
	visual.size = rect.size
	body.add_child(visual)
	add_world_sprite(body, TEX_TILE_GREY, Vector2.ZERO, rect.size, Color(0.68, 0.95, 1.0))
	var glow := ColorRect.new()
	glow.color = Color(0.42, 0.88, 0.96, 0.85)
	glow.position = Vector2(4, 3)
	glow.size = Vector2(maxf(rect.size.x - 8, 8), 4)
	body.add_child(glow)
	var underside := ColorRect.new()
	underside.color = Color(0.08, 0.18, 0.24)
	underside.position = Vector2(0, rect.size.y - 5)
	underside.size = Vector2(rect.size.x, 5)
	body.add_child(underside)

	level_root.add_child(body)
	moving_platforms.append({
		"node": body,
		"from": from_pos,
		"to": to_pos,
		"speed": float(data.get("speed", 70.0)),
		"direction": 1.0
	})

func create_brittle_platform(rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.position = rect.position
	body.collision_layer = LAYER_WORLD
	body.collision_mask = 0

	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	shape.position = rect.size / 2.0
	body.add_child(shape)

	var visual := ColorRect.new()
	visual.color = Color(0.58, 0.42, 0.28, 0.25)
	visual.size = rect.size
	body.add_child(visual)
	add_world_sprite(body, TEX_TILE_BRITTLE, Vector2.ZERO, rect.size)

	var trigger := Area2D.new()
	trigger.collision_layer = LAYER_TRIGGER
	trigger.collision_mask = LAYER_PLAYER
	var trigger_shape := CollisionShape2D.new()
	var trigger_box := RectangleShape2D.new()
	trigger_box.size = Vector2(rect.size.x, 8)
	trigger_shape.shape = trigger_box
	trigger_shape.position = Vector2(rect.size.x / 2.0, -4.0)
	trigger.add_child(trigger_shape)
	trigger.body_entered.connect(func(body_entered: Node) -> void:
		if body_entered == player and is_instance_valid(body):
			visual.color = Color(0.82, 0.48, 0.25)
			await get_tree().create_timer(0.45).timeout
			if is_instance_valid(body):
				body.queue_free()
	)
	body.add_child(trigger)
	level_root.add_child(body)

func create_door(data: Dictionary) -> void:
	var rect_data: Array = data.get("rect", [0, 0, 34, 80])
	var door_id := str(data.get("id", "key"))
	var rect := Rect2(rect_data[0], rect_data[1], rect_data[2], rect_data[3])
	var body := StaticBody2D.new()
	body.position = rect.position
	body.collision_layer = LAYER_WORLD
	body.collision_mask = 0
	body.set_meta("door_id", door_id)

	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	shape.position = rect.size / 2.0
	body.add_child(shape)

	var visual := ColorRect.new()
	visual.color = Color(0.64, 0.48, 0.18, 0.24)
	visual.size = rect.size
	body.add_child(visual)
	add_world_sprite(body, TEX_DOOR, Vector2.ZERO, rect.size)

	level_root.add_child(body)
	doors.append(body)

func create_key(data) -> void:
	var pos_data = data.get("pos", [0, 0]) if typeof(data) == TYPE_DICTIONARY else data
	var key_id := str(data.get("id", "key")) if typeof(data) == TYPE_DICTIONARY else str(data[2])
	var area := Area2D.new()
	area.position = Vector2(pos_data[0], pos_data[1])
	area.collision_layer = LAYER_TRIGGER
	area.collision_mask = LAYER_PLAYER
	area.body_entered.connect(func(body: Node) -> void:
		if body == player:
			keys_collected[key_id] = true
			open_doors_for_key(key_id)
			area.queue_free()
	)

	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = Vector2(20, 20)
	shape.shape = box
	shape.position = Vector2(10, -10)
	area.add_child(shape)

	var visual := ColorRect.new()
	visual.position = Vector2(0, -20)
	visual.size = Vector2(20, 20)
	visual.color = Color(0.95, 0.78, 0.22, 0.15)
	area.add_child(visual)
	add_world_sprite(area, TEX_KEY, Vector2(-4, -28), Vector2(28, 28))
	level_root.add_child(area)

func open_doors_for_key(key_id: String) -> void:
	for door in doors.duplicate():
		if not is_instance_valid(door):
			doors.erase(door)
			continue
		if str(door.get_meta("door_id")) == key_id:
			door.queue_free()
			doors.erase(door)

func create_checkpoint(pos: Vector2) -> void:
	var area := Area2D.new()
	area.position = pos
	area.collision_layer = LAYER_TRIGGER
	area.collision_mask = LAYER_PLAYER
	area.body_entered.connect(func(body: Node) -> void:
		if body == player:
			checkpoint_position = pos
	)

	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = Vector2(30, 54)
	shape.shape = box
	shape.position = Vector2(15, -27)
	area.add_child(shape)

	var flag := ColorRect.new()
	flag.position = Vector2(0, -54)
	flag.size = Vector2(30, 22)
	flag.color = Color(0.38, 0.72, 0.95, 0.12)
	area.add_child(flag)
	add_world_sprite(area, TEX_FLAG, Vector2(-8, -58), Vector2(38, 38))
	var pole := ColorRect.new()
	pole.position = Vector2(0, -54)
	pole.size = Vector2(4, 54)
	pole.color = Color(0.82, 0.88, 0.9)
	area.add_child(pole)
	var base := ColorRect.new()
	base.position = Vector2(-8, -4)
	base.size = Vector2(22, 4)
	base.color = Color(0.48, 0.54, 0.58)
	area.add_child(base)
	level_root.add_child(area)

func create_hazard(rect: Rect2) -> void:
	var area := Area2D.new()
	area.position = rect.position
	area.collision_layer = LAYER_TRIGGER
	area.collision_mask = LAYER_PLAYER
	area.body_entered.connect(func(body: Node) -> void:
		if body == player:
			damage_player_from(rect.position.x + rect.size.x / 2.0)
	)

	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = rect.size
	shape.shape = box
	shape.position = rect.size / 2.0
	area.add_child(shape)

	var base := ColorRect.new()
	base.color = Color(0.34, 0.05, 0.05)
	base.position = Vector2(0, rect.size.y - 4)
	base.size = Vector2(rect.size.x, 4)
	area.add_child(base)
	add_world_sprite(area, TEX_SPIKES, Vector2.ZERO, rect.size)
	var spike_count: int = max(1, int(rect.size.x / 16.0))
	var spike_width: float = rect.size.x / float(spike_count)
	for i in range(spike_count):
		var spike := Polygon2D.new()
		spike.color = Color(0.9, 0.18, 0.16)
		spike.polygon = PackedVector2Array([
			Vector2(i * spike_width, rect.size.y),
			Vector2(i * spike_width + spike_width * 0.5, 0),
			Vector2(i * spike_width + spike_width, rect.size.y)
		])
		area.add_child(spike)

	level_root.add_child(area)

func create_potion_drop(pos: Vector2) -> void:
	var area := Area2D.new()
	area.name = "LifePotionDrop"
	area.position = pos + Vector2(-8.0, -18.0)
	area.collision_layer = LAYER_TRIGGER
	area.collision_mask = LAYER_PLAYER
	area.body_entered.connect(func(body: Node) -> void:
		if body == player:
			heal_player(potion_heal_amount())
			area.queue_free()
	)

	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = Vector2(20, 20)
	shape.shape = box
	shape.position = Vector2(10, -10)
	area.add_child(shape)

	var vial := ColorRect.new()
	vial.position = Vector2(3, -20)
	vial.size = Vector2(14, 18)
	vial.color = Color(0.32, 0.95, 0.58, 0.18)
	area.add_child(vial)
	add_world_sprite(area, TEX_POTION, Vector2(-2, -28), Vector2(28, 28))
	var cap := ColorRect.new()
	cap.position = Vector2(6, -26)
	cap.size = Vector2(8, 6)
	cap.color = Color(0.94, 0.82, 0.54)
	area.add_child(cap)
	var shine := ColorRect.new()
	shine.position = Vector2(6, -17)
	shine.size = Vector2(3, 8)
	shine.color = Color(0.82, 1.0, 0.84, 0.8)
	area.add_child(shine)

	level_root.add_child(area)

func create_coin_drops(pos: Vector2, amount: int) -> void:
	if not level_root:
		return
	var count := clampi(amount, 1, 16)
	for i in range(count):
		var coin := Node2D.new()
		coin.name = "CoinDrop"
		coin.global_position = pos + Vector2(randf_range(-10.0, 10.0), -22.0 + randf_range(-6.0, 6.0))
		var body := ColorRect.new()
		body.position = Vector2(-5, -5)
		body.size = Vector2(10, 10)
		body.color = Color(0.95, 0.72, 0.16, 0.12)
		coin.add_child(body)
		add_world_sprite(coin, TEX_COIN, Vector2(-9, -9), Vector2(18, 18))
		var shine := ColorRect.new()
		shine.position = Vector2(-2, -4)
		shine.size = Vector2(3, 8)
		shine.color = Color(1.0, 0.94, 0.55, 0.9)
		coin.add_child(shine)
		level_root.add_child(coin)
		coin_drops.append({
			"node": coin,
			"velocity": Vector2(randf_range(-90.0, 90.0), randf_range(-250.0, -160.0)),
			"value": 1,
			"age": 0.0,
			"magnet": false
		})
	play_sfx("coin_drop")

func create_skill_drop(pos: Vector2, skill_id: String) -> void:
	if unlocked_skills.has(skill_id):
		return
	var area := Area2D.new()
	area.name = "SkillDrop_%s" % skill_id
	area.position = pos + Vector2(-16.0, -28.0)
	area.collision_layer = LAYER_TRIGGER
	area.collision_mask = LAYER_PLAYER
	area.body_entered.connect(func(body: Node) -> void:
		if body == player:
			unlock_skill(skill_id)
			area.queue_free()
	)

	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = Vector2(32, 32)
	shape.shape = box
	shape.position = Vector2(16, -16)
	area.add_child(shape)

	var flame := ColorRect.new()
	flame.position = Vector2(6, -30)
	flame.size = Vector2(20, 28)
	flame.color = Color(0.95, 0.28, 0.08, 0.18)
	area.add_child(flame)
	add_world_sprite(area, skill_texture(skill_id), Vector2(0, -36), Vector2(38, 38))
	var core := ColorRect.new()
	core.position = Vector2(11, -23)
	core.size = Vector2(10, 16)
	core.color = Color(1.0, 0.82, 0.22)
	area.add_child(core)
	level_root.add_child(area)
	play_sfx("fire")

func unlock_skill(skill_id: String) -> void:
	unlocked_skills[skill_id] = true
	if equipped_skills.get("K", "") == "":
		equipped_skills["K"] = skill_id
	play_sfx("skill")
	save_run()

func create_shop(pos: Vector2) -> void:
	shop_available = true
	shop_position = pos
	var shop := Node2D.new()
	shop.name = "Shop"
	shop.position = pos

	var body := ColorRect.new()
	body.position = Vector2(-26, -58)
	body.size = Vector2(52, 58)
	body.color = Color(0.2, 0.16, 0.12)
	shop.add_child(body)

	var roof := ColorRect.new()
	roof.position = Vector2(-34, -70)
	roof.size = Vector2(68, 14)
	roof.color = Color(0.88, 0.55, 0.24)
	shop.add_child(roof)

	var tip := make_world_label(t("shop_tip"), Vector2(-176, -128), Vector2(352, 34), 15)
	shop.add_child(tip)

	var prompt := make_world_label(t("shop_prompt"), Vector2(-140, -96), Vector2(280, 28), 14)
	prompt.add_theme_color_override("font_color", Color(0.94, 0.84, 0.58))
	shop.add_child(prompt)

	level_root.add_child(shop)

func make_world_label(text: String, pos: Vector2, size: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.size = size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_override("font", FONT_UI)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.95, 0.95, 0.86))
	return label

func create_goal(pos: Vector2) -> void:
	var area := Area2D.new()
	area.position = pos
	area.collision_layer = LAYER_TRIGGER
	area.collision_mask = LAYER_PLAYER
	area.body_entered.connect(func(body: Node) -> void:
		if body == player:
			level_complete()
	)

	var shape := CollisionShape2D.new()
	var box := RectangleShape2D.new()
	box.size = Vector2(32, 72)
	shape.shape = box
	shape.position = Vector2(16, -36)
	area.add_child(shape)

	var flag := ColorRect.new()
	flag.position = Vector2(0, -72)
	flag.size = Vector2(38, 30)
	flag.color = Color(0.98, 0.76, 0.28)
	area.add_child(flag)
	var pole := ColorRect.new()
	pole.position = Vector2(0, -72)
	pole.size = Vector2(5, 72)
	pole.color = Color(0.9, 0.9, 0.82)
	area.add_child(pole)

	level_root.add_child(area)

func create_enemy(data: Dictionary) -> void:
	var pos_data: Array = data.get("pos", [0, 0])
	var pos := Vector2(pos_data[0], pos_data[1])
	var patrol := float(data.get("patrol", 40.0))
	var enemy_type := str(data.get("type", "patrol"))
	var hp := int(data.get("hp", 1))
	var enemy := EnemyScript.new()
	enemy.name = "Enemy"
	enemy.setup(pos, patrol, self, enemy_type, hp)
	level_root.add_child(enemy)
	enemies.append(enemy)

func show_hud() -> void:
	var panel := ColorRect.new()
	panel.color = Color(0.035, 0.04, 0.045, 0.86)
	panel.position = Vector2(10, 8)
	panel.size = Vector2(940, 72)
	ui_root.add_child(panel)

	var bottle := ColorRect.new()
	bottle.position = Vector2(24, 22)
	bottle.size = Vector2(18, 28)
	bottle.color = Color(0.86, 0.12, 0.16)
	ui_root.add_child(bottle)
	var bottle_cap := ColorRect.new()
	bottle_cap.position = Vector2(28, 16)
	bottle_cap.size = Vector2(10, 7)
	bottle_cap.color = Color(0.95, 0.76, 0.5)
	ui_root.add_child(bottle_cap)

	hud_health_bar = ProgressBar.new()
	hud_health_bar.position = Vector2(54, 20)
	hud_health_bar.size = Vector2(170, 22)
	hud_health_bar.min_value = 0
	hud_health_bar.show_percentage = false
	ui_root.add_child(hud_health_bar)

	hud_life_label = make_label("", 14, Vector2(60, 19), Vector2(158, 24), HORIZONTAL_ALIGNMENT_CENTER)
	hud_life_label.add_theme_color_override("font_color", Color(0.98, 0.96, 0.9))
	ui_root.add_child(hud_life_label)

	hud_coin_label = make_label("", 16, Vector2(246, 18), Vector2(150, 28), HORIZONTAL_ALIGNMENT_LEFT)
	hud_coin_label.add_theme_color_override("font_color", Color(0.98, 0.82, 0.28))
	ui_root.add_child(hud_coin_label)

	hud_potion_label = make_label("", 16, Vector2(400, 18), Vector2(150, 28), HORIZONTAL_ALIGNMENT_LEFT)
	hud_potion_label.add_theme_color_override("font_color", Color(0.56, 0.96, 0.66))
	ui_root.add_child(hud_potion_label)

	hud_equipment_label = make_label("", 13, Vector2(552, 14), Vector2(380, 34), HORIZONTAL_ALIGNMENT_RIGHT)
	hud_equipment_label.add_theme_color_override("font_color", Color(0.78, 0.88, 0.94))
	ui_root.add_child(hud_equipment_label)

	hud_hint_label = make_label("", 13, Vector2(20, 44), Vector2(920, 42), HORIZONTAL_ALIGNMENT_CENTER)
	hud_hint_label.add_theme_color_override("font_color", Color(0.72, 0.76, 0.7))
	ui_root.add_child(hud_hint_label)
	update_hud()

func update_hud() -> void:
	if not hud_health_bar:
		return
	var lives_text := "--"
	if player:
		lives_text = str(player.lives)
	var data: Dictionary = levels[current_level]
	hud_health_bar.max_value = max_lives
	hud_health_bar.value = player_lives
	hud_life_label.text = "%s %s/%s" % [t("lives"), lives_text, max_lives]
	hud_coin_label.text = "%s: %s" % [t("coins"), coins]
	hud_potion_label.text = "%s: %s" % [t("use_potion"), int(backpack.get("potion", 0))]
	var armor_text := " +1" if armor_charges > 0 else ""
	hud_equipment_label.text = "%s / %s / %s%s / %s" % [
		item_display_name(str(equipment.get("weapon", "short_sword"))),
		item_display_name(str(equipment.get("boots", "worn_boots"))),
		item_display_name(str(equipment.get("armor", "cloth"))),
		armor_text,
		item_display_name(str(equipment.get("charm", "none")))
	]
	var region_label := "Region" if language == "en" else "区域"
	hud_hint_label.text = "%s %s / %s\n%s" % [region_label, current_region_id(), level_text(data, "name"), level_text(data, "hint")]

func set_player_lives(value: int) -> void:
	player_lives = clampi(value, 0, max_lives)

func heal_player(amount: int) -> bool:
	if player_lives >= max_lives:
		return false
	player_lives = clampi(player_lives + amount, 0, max_lives)
	if player and is_instance_valid(player):
		player.lives = player_lives
	update_hud()
	play_sfx("potion")
	save_run()
	return true

func potion_heal_amount() -> int:
	return 2 if equipment.get("charm", "none") == "medic_charm" else 1

func use_backpack_potion() -> bool:
	if state != "playing" or paused:
		return false
	if int(backpack.get("potion", 0)) <= 0:
		return false
	if player_lives >= max_lives:
		return false
	backpack["potion"] = int(backpack.get("potion", 0)) - 1
	heal_player(potion_heal_amount())
	update_hud()
	save_run()
	return true

func damage_player_from(from_x: float) -> void:
	if not player or not is_instance_valid(player):
		return
	var before: int = player.lives
	player.take_hit(from_x)
	if player and is_instance_valid(player) and player.lives < before:
		play_sfx("hit")

func should_block_hit(_from_x: float) -> bool:
	if armor_charges <= 0:
		return false
	var armor := str(equipment.get("armor", "cloth"))
	if armor != "bronze_armor" and armor != "glass_armor":
		return false
	armor_charges -= 1
	update_hud()
	play_sfx("hit")
	save_run()
	return true

func get_attack_reach() -> float:
	var weapon := str(equipment.get("weapon", "short_sword"))
	return float(weapon_stats_for(weapon).get("reach", SHORT_SWORD_REACH))

func skill_damage_bonus() -> int:
	return int(weapon_stats_for(str(equipment.get("weapon", "short_sword"))).get("skill_bonus", 0))

func skill_cooldown_multiplier() -> float:
	return 0.78 if equipment.get("charm", "none") == "dawn_charm" else 1.0

func get_equipped_visual(slot: String) -> String:
	return str(equipment.get(slot, "none"))

func player_attack(origin: Vector2, facing: float) -> void:
	play_sfx("sword")
	var reach := get_attack_reach()
	create_attack_slash_visual(origin, facing, reach)
	for enemy in enemies.duplicate():
		if not is_instance_valid(enemy):
			continue
		var enemy_rect := get_enemy_rect(enemy)
		if attack_cone_hits_rect(origin, facing, reach, enemy_rect):
			reward_enemy_defeat(enemy, "attack")

func attack_cone_hits_rect(origin: Vector2, facing: float, reach: float, rect: Rect2) -> bool:
	var cone_origin := origin + Vector2(12.0 * facing, -28.0)
	var center := rect.position + rect.size * 0.5
	var samples := [
		center,
		rect.position,
		rect.position + Vector2(rect.size.x, 0.0),
		rect.position + Vector2(0.0, rect.size.y),
		rect.position + rect.size,
		rect.position + Vector2(rect.size.x * 0.5, 0.0),
		rect.position + Vector2(rect.size.x * 0.5, rect.size.y)
	]
	for point in samples:
		if attack_cone_contains_point(point, cone_origin, facing, reach):
			return true
	return false

func attack_cone_contains_point(point: Vector2, cone_origin: Vector2, facing: float, reach: float) -> bool:
	var local := point - cone_origin
	var forward := local.x * facing
	if forward < 0.0 or forward > reach + 24.0:
		return false
	var vertical_limit := 18.0 + forward * 0.56
	return absf(local.y) <= vertical_limit

func create_attack_slash_visual(origin: Vector2, facing: float, reach: float) -> void:
	if not is_instance_valid(world):
		return
	var slash := Node2D.new()
	slash.z_index = 40
	slash.global_position = origin + Vector2(10.0 * facing, -28.0)
	world.add_child(slash)
	var outer := Line2D.new()
	outer.width = 13.0
	outer.default_color = Color(0.22, 0.72, 1.0, 0.32)
	outer.points = slash_arc_points(facing, reach + 26.0, -1.15, 0.82, 0.58)
	slash.add_child(outer)
	var core := Line2D.new()
	core.width = 5.0
	core.default_color = Color(1.0, 0.96, 0.72, 0.92)
	core.points = slash_arc_points(facing, reach + 18.0, -1.05, 0.72, 0.54)
	slash.add_child(core)
	var tip := Line2D.new()
	tip.width = 2.0
	tip.default_color = Color(1.0, 1.0, 1.0, 0.85)
	tip.points = slash_arc_points(facing, reach + 32.0, 0.2, 0.72, 0.54)
	slash.add_child(tip)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(slash, "modulate:a", 0.0, 0.16).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(slash, "scale", Vector2(1.18, 1.08), 0.16).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(slash.queue_free)

func slash_arc_points(facing: float, radius: float, start_angle: float, end_angle: float, vertical_scale: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in range(15):
		var t := float(i) / 14.0
		var angle := lerpf(start_angle, end_angle, t)
		points.append(Vector2(cos(angle) * radius * facing, sin(angle) * radius * vertical_scale))
	return points

func create_hit_spark(pos: Vector2, heavy: bool) -> void:
	if not is_instance_valid(world):
		return
	var spark := Node2D.new()
	spark.z_index = 45
	spark.global_position = pos + Vector2(0.0, -22.0)
	world.add_child(spark)
	var ray_count := 9 if heavy else 6
	var radius := 34.0 if heavy else 24.0
	for i in range(ray_count):
		var angle := (TAU * float(i) / float(ray_count)) + randf_range(-0.18, 0.18)
		var ray := Line2D.new()
		ray.width = 4.0 if heavy else 3.0
		ray.default_color = Color(1.0, 0.84, 0.28, 0.9)
		ray.points = PackedVector2Array([
			Vector2(cos(angle), sin(angle)) * 5.0,
			Vector2(cos(angle), sin(angle)) * randf_range(radius * 0.55, radius)
		])
		spark.add_child(ray)
	var flash := Line2D.new()
	flash.width = 10.0 if heavy else 7.0
	flash.default_color = Color(1.0, 1.0, 1.0, 0.62)
	flash.points = PackedVector2Array([Vector2(-10.0, 0.0), Vector2(10.0, 0.0)])
	spark.add_child(flash)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(spark, "modulate:a", 0.0, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(spark, "scale", Vector2(1.5, 1.5), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(spark.queue_free)

func reward_enemy_defeat(enemy, method: String) -> void:
	if not is_instance_valid(enemy):
		return
	var defeated_at: Vector2 = enemy.global_position
	var defeated_type := str(enemy.get("enemy_type"))
	var damage := 2 if method == "stomp" else weapon_attack_damage()
	if method != "skill" and enemy.has_method("take_damage") and not enemy.take_damage(damage):
		create_hit_spark(defeated_at, false)
		play_sfx("martial_hit")
		return
	enemy.defeat()
	enemies.erase(enemy)
	create_hit_spark(defeated_at, method != "attack")
	var coin_reward := 2 if method == "stomp" else 1
	if equipment.get("charm", "none") == "coin_charm":
		coin_reward += 1
	create_coin_drops(defeated_at, coin_reward)
	if method != "stomp":
		var potion_chance := 0.25 if equipment.get("charm", "none") == "medic_charm" else 0.1
		if randf() < potion_chance:
			create_potion_drop(defeated_at)
	if defeated_type == "boss":
		create_skill_drop(defeated_at, boss_skill_reward())
	update_hud()

func boss_skill_reward() -> String:
	if levels.is_empty():
		return "pyroblast"
	var data: Dictionary = levels[clampi(current_level, 0, levels.size() - 1)]
	var reward = data.get("reward", {})
	if typeof(reward) == TYPE_DICTIONARY and reward.has("skill"):
		return str(reward["skill"])
	var unlock = data.get("unlock", {})
	if typeof(unlock) == TYPE_DICTIONARY and unlock.has("skill"):
		return str(unlock["skill"])
	var region := int(data.get("region", current_region_id()))
	return SKILL_IDS[clampi(region - 1, 0, SKILL_IDS.size() - 1)]

func get_player_rect() -> Rect2:
	return Rect2(player.global_position + Vector2(-PLAYER_HALF_WIDTH, -PLAYER_HEIGHT), Vector2(PLAYER_HALF_WIDTH * 2.0, PLAYER_HEIGHT))

func get_enemy_rect(enemy) -> Rect2:
	var half_width := ENEMY_HALF_WIDTH
	var height := ENEMY_HEIGHT
	if enemy.get("enemy_type") == "boss":
		half_width = 23.0
		height = 42.0
	return Rect2(enemy.global_position + Vector2(-half_width, -height), Vector2(half_width * 2.0, height))

func is_stomping_enemy(enemy) -> bool:
	var enemy_height := 42.0 if enemy.get("enemy_type") == "boss" else ENEMY_HEIGHT
	var enemy_top: float = enemy.global_position.y - enemy_height
	var previous_bottom: float = player.previous_global_position.y
	var current_bottom: float = player.global_position.y
	var horizontal_overlap := absf(player.global_position.x - enemy.global_position.x) <= PLAYER_HALF_WIDTH + ENEMY_HALF_WIDTH - 3.0
	var crossed_head := previous_bottom <= enemy_top + STOMP_GRACE and current_bottom >= enemy_top - STOMP_GRACE
	return player.was_falling and horizontal_overlap and crossed_head

func _process(_delta: float) -> void:
	update_camera()

func update_camera() -> void:
	if not camera:
		return
	if not player or not is_instance_valid(player):
		camera.position = VIEWPORT_SIZE / 2.0
		return
	var half_width := VIEWPORT_SIZE.x / 2.0
	var target_x := clampf(player.global_position.x, half_width, maxf(half_width, current_world_width - half_width))
	camera.position = Vector2(target_x, VIEWPORT_SIZE.y / 2.0)

func _physics_process(_delta: float) -> void:
	update_moving_platforms(_delta)
	update_coin_drops(_delta)
	update_skill_cooldowns(_delta)
	if state == "home" and player and player.global_position.y > WORLD_LIMIT_Y:
		player.reset_to(home_spawn_position, player_lives)
		return
	if state != "playing" or paused or not player:
		return
	if player.global_position.y > WORLD_LIMIT_Y:
		lose_life_and_respawn()
		return
	for enemy in enemies.duplicate():
		if not is_instance_valid(enemy):
			enemies.erase(enemy)
			continue
		if not enemy.active:
			continue
		var player_rect := get_player_rect()
		var enemy_rect := get_enemy_rect(enemy)
		if player_rect.intersects(enemy_rect):
			if is_stomping_enemy(enemy):
				reward_enemy_defeat(enemy, "stomp")
				player.bounce_after_stomp()
			else:
				damage_player_from(enemy.global_position.x)

func update_skill_cooldowns(delta: float) -> void:
	if state != "playing" or paused:
		return
	for skill_id in skill_cooldowns.keys():
		skill_cooldowns[skill_id] = maxf(float(skill_cooldowns[skill_id]) - delta, 0.0)

func cast_skill_slot(slot: String) -> void:
	if state != "playing" or paused:
		return
	var skill_id := str(equipped_skills.get(slot, ""))
	if skill_id == "":
		return
	match skill_id:
		"pyroblast":
			cast_pyroblast()
		"tidal_wave":
			cast_tidal_wave()
		"clock_snare":
			cast_clock_snare()
		"dawn_barrier":
			cast_dawn_barrier()

func cast_pyroblast() -> void:
	if not unlocked_skills.has("pyroblast"):
		return
	if float(skill_cooldowns.get("pyroblast", 0.0)) > 0.0:
		play_sfx("ui")
		return
	if not player or not is_instance_valid(player):
		return
	var center: Vector2 = player.global_position + Vector2(player.facing * 24.0, -22.0)
	skill_cooldowns["pyroblast"] = PYROBLAST_COOLDOWN * skill_cooldown_multiplier()
	cast_area_damage(center, PYROBLAST_RANGE, PYROBLAST_DAMAGE + skill_damage_bonus(), Color(0.95, 0.22, 0.06), Color(1.0, 0.92, 0.36))

func cast_tidal_wave() -> void:
	if not unlocked_skills.has("tidal_wave"):
		return
	if float(skill_cooldowns.get("tidal_wave", 0.0)) > 0.0:
		play_sfx("ui")
		return
	if not player or not is_instance_valid(player):
		return
	var center: Vector2 = player.global_position + Vector2(player.facing * 36.0, -18.0)
	skill_cooldowns["tidal_wave"] = TIDAL_WAVE_COOLDOWN * skill_cooldown_multiplier()
	cast_area_damage(center, TIDAL_WAVE_RANGE, TIDAL_WAVE_DAMAGE + skill_damage_bonus(), Color(0.12, 0.58, 0.95), Color(0.72, 0.96, 1.0))

func cast_clock_snare() -> void:
	if not unlocked_skills.has("clock_snare"):
		return
	if float(skill_cooldowns.get("clock_snare", 0.0)) > 0.0:
		play_sfx("ui")
		return
	if not player or not is_instance_valid(player):
		return
	var center: Vector2 = player.global_position + Vector2(0.0, -24.0)
	skill_cooldowns["clock_snare"] = CLOCK_SNARE_COOLDOWN * skill_cooldown_multiplier()
	cast_area_damage(center, CLOCK_SNARE_RANGE, CLOCK_SNARE_DAMAGE + skill_damage_bonus(), Color(0.74, 0.58, 0.22), Color(1.0, 0.86, 0.42), true)

func cast_dawn_barrier() -> void:
	if not unlocked_skills.has("dawn_barrier"):
		return
	if float(skill_cooldowns.get("dawn_barrier", 0.0)) > 0.0:
		play_sfx("ui")
		return
	if not player or not is_instance_valid(player):
		return
	armor_charges = max(armor_charges, 1)
	update_hud()
	var center: Vector2 = player.global_position + Vector2(0.0, -24.0)
	skill_cooldowns["dawn_barrier"] = DAWN_BARRIER_COOLDOWN * skill_cooldown_multiplier()
	cast_area_damage(center, DAWN_BARRIER_RANGE, DAWN_BARRIER_DAMAGE + skill_damage_bonus(), Color(1.0, 0.76, 0.18), Color(1.0, 0.96, 0.66))

func cast_area_damage(center: Vector2, radius: float, damage: int, outer_color: Color, core_color: Color, reverse_enemy: bool = false) -> void:
	create_skill_burst_visual(center, radius, outer_color, core_color)
	play_sfx("fire")
	for enemy in enemies.duplicate():
		if not is_instance_valid(enemy) or not enemy.active:
			continue
		if enemy.global_position.distance_to(center) <= radius:
			if reverse_enemy:
				enemy.set("direction", -float(enemy.get("direction")))
			if enemy.has_method("take_damage") and enemy.take_damage(damage):
				reward_enemy_defeat(enemy, "skill")
			else:
				play_sfx("martial_hit")

func create_pyroblast_visual(center: Vector2) -> void:
	create_skill_burst_visual(center, PYROBLAST_RANGE, Color(0.95, 0.22, 0.06), Color(1.0, 0.92, 0.36))

func create_skill_burst_visual(center: Vector2, radius: float, outer_color: Color, core_color: Color) -> void:
	if not level_root:
		return
	var burst := Node2D.new()
	burst.name = "SkillBurst"
	burst.global_position = center
	level_root.add_child(burst)
	var outer := ColorRect.new()
	outer.position = Vector2(-radius, -radius)
	outer.size = Vector2(radius * 2.0, radius * 2.0)
	outer.color = Color(outer_color.r, outer_color.g, outer_color.b, 0.20)
	burst.add_child(outer)
	var mid := ColorRect.new()
	mid.position = Vector2(-radius * 0.48, -radius * 0.48)
	mid.size = Vector2(radius * 0.96, radius * 0.96)
	mid.color = Color(outer_color.lightened(0.2).r, outer_color.lightened(0.2).g, outer_color.lightened(0.2).b, 0.36)
	burst.add_child(mid)
	var core := ColorRect.new()
	core.position = Vector2(-32, -32)
	core.size = Vector2(64, 64)
	core.color = Color(core_color.r, core_color.g, core_color.b, 0.58)
	burst.add_child(core)
	await get_tree().create_timer(0.18).timeout
	if is_instance_valid(burst):
		burst.queue_free()

func update_coin_drops(delta: float) -> void:
	if state != "playing" or paused:
		return
	if not player or not is_instance_valid(player):
		return
	var target: Vector2 = player.global_position + Vector2(0, -26)
	for drop in coin_drops.duplicate():
		var node = drop.get("node")
		if not is_instance_valid(node):
			coin_drops.erase(drop)
			continue
		drop["age"] = float(drop.get("age", 0.0)) + delta
		var to_player: Vector2 = target - node.global_position
		if to_player.length() < 145.0 or float(drop["age"]) > 0.45:
			drop["magnet"] = true
		if bool(drop.get("magnet", false)):
			var speed := 520.0 + float(drop["age"]) * 260.0
			node.global_position += to_player.normalized() * minf(to_player.length(), speed * delta)
		else:
			var velocity: Vector2 = drop.get("velocity", Vector2.ZERO)
			velocity.y += 760.0 * delta
			node.global_position += velocity * delta
			node.rotation += delta * 7.0
			drop["velocity"] = velocity
		if to_player.length() <= 18.0:
			coins += int(drop.get("value", 1))
			update_hud()
			play_sfx("coin_pickup")
			save_run()
			node.queue_free()
			coin_drops.erase(drop)

func update_moving_platforms(delta: float) -> void:
	if state != "playing" or paused:
		return
	for item in moving_platforms:
		var node = item["node"]
		if not is_instance_valid(node):
			continue
		var target: Vector2 = item["to"] if item["direction"] > 0.0 else item["from"]
		var current: Vector2 = node.position
		var next := current.move_toward(target, float(item["speed"]) * delta)
		node.position = next
		if next.distance_to(target) <= 1.0:
			item["direction"] = -float(item["direction"])

func is_game_paused() -> bool:
	return paused or state != "playing"

func lose_life_and_respawn() -> void:
	if not player or not is_instance_valid(player):
		return
	if player.invulnerable_time > 0.0:
		return
	player_lives = clampi(player_lives - 1, 0, max_lives)
	player.lives = player_lives
	update_hud()
	if player_lives <= 0:
		player.enabled = false
		player_died()
		return
	player.reset_to(checkpoint_position, player_lives)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if state == "inventory":
			close_inventory()
		elif state != "dead":
			show_inventory()
	elif event.is_action_pressed("skills"):
		if state == "skills":
			close_skills()
		elif state != "dead":
			show_skills()
	elif event.is_action_pressed("skill_k"):
		if state == "skills":
			var skill_k_id := first_unlocked_skill()
			if skill_k_id != "":
				equip_skill_to_slot(skill_k_id, "K")
		else:
			cast_skill_slot("K")
	elif event.is_action_pressed("skill_l"):
		if state == "skills":
			var skill_l_id := first_unlocked_skill()
			if skill_l_id != "":
				equip_skill_to_slot(skill_l_id, "L")
		else:
			cast_skill_slot("L")
	elif event.is_action_pressed("pause"):
		if state == "playing":
			show_pause_menu()
		elif state == "home":
			show_home_pause_menu()
		elif state == "home_pause":
			resume_home()
		elif state == "paused":
			resume_game()
		elif state == "shop":
			resume_game()
		elif state == "inventory":
			close_inventory()
		elif state == "skills":
			close_skills()
		elif state == "home_shop" or state == "core" or state == "settings" or state == "network":
			show_main_menu()
	elif event.is_action_pressed("use_item") and state == "playing":
		use_backpack_potion()
	elif event.is_action_pressed("restart") and (state == "playing" or state == "paused"):
		load_level(current_level)

func show_home_pause_menu() -> void:
	remember_home_position()
	state = "home_pause"
	paused = true
	if player:
		player.enabled = false
	clear_ui()
	add_translucent_overlay()
	ui_root.add_child(make_label(t("home_pause"), 34, Vector2(0, 72), Vector2(VIEWPORT_SIZE.x, 50), HORIZONTAL_ALIGNMENT_CENTER))

	var resume := make_button(t("resume"), Vector2(360, 144), Vector2(240, 40))
	resume.pressed.connect(func() -> void: resume_home())
	ui_root.add_child(resume)

	var settings_button := make_button(t("settings"), Vector2(360, 194), Vector2(240, 40))
	settings_button.pressed.connect(func() -> void: show_settings())
	ui_root.add_child(settings_button)

	var language_button := make_button(language_button_text(), Vector2(310, 244), Vector2(340, 40))
	language_button.pressed.connect(func() -> void: toggle_language())
	ui_root.add_child(language_button)

	var network_button := make_button(t("network"), Vector2(360, 294), Vector2(240, 40))
	network_button.pressed.connect(func() -> void: show_network_menu())
	ui_root.add_child(network_button)

	var delete_button := make_button(t("delete_save"), Vector2(360, 344), Vector2(240, 40))
	delete_button.disabled = not save_manager.has_save()
	delete_button.pressed.connect(func() -> void:
		save_manager.delete_save()
		reset_home_state()
		show_main_menu()
	)
	ui_root.add_child(delete_button)

	var quit_button := make_button(t("quit"), Vector2(360, 394), Vector2(240, 40))
	quit_button.pressed.connect(func() -> void: get_tree().quit())
	ui_root.add_child(quit_button)

func resume_home() -> void:
	state = "home"
	paused = false
	clear_ui()
	show_home_hud()
	if player:
		player.enabled = true

func show_pause_menu() -> void:
	state = "paused"
	paused = true
	if player:
		player.enabled = false
	clear_ui()
	add_translucent_overlay()
	ui_root.add_child(make_label(t("paused"), 34, Vector2(0, 96), Vector2(VIEWPORT_SIZE.x, 50), HORIZONTAL_ALIGNMENT_CENTER))

	var resume := make_button(t("resume"), Vector2(360, 182), Vector2(240, 44))
	resume.pressed.connect(func() -> void: resume_game())
	ui_root.add_child(resume)

	var restart := make_button(t("restart_level"), Vector2(360, 238), Vector2(240, 44))
	restart.pressed.connect(func() -> void: load_level(current_level))
	ui_root.add_child(restart)

	var language_button := make_button(language_button_text(), Vector2(310, 294), Vector2(340, 44))
	language_button.pressed.connect(func() -> void: toggle_language())
	ui_root.add_child(language_button)

func resume_game() -> void:
	state = "playing"
	paused = false
	shop_message = ""
	clear_ui()
	show_hud()
	if player:
		player.enabled = true

func try_interact() -> bool:
	if state == "home":
		return try_home_interact()
	if state != "playing" or not player or not shop_available:
		return false
	if player.global_position.distance_to(shop_position) > 92.0:
		return false
	state = "shop"
	paused = true
	player.enabled = false
	show_shop()
	return true

func try_home_interact() -> bool:
	if not player:
		return false
	var nearest_id := ""
	var nearest_distance := 99999.0
	for item in home_interactables:
		var station_pos: Vector2 = item["position"]
		var distance: float = player.global_position.distance_to(station_pos)
		if distance <= float(item.get("range", 76.0)) and distance < nearest_distance:
			nearest_distance = distance
			nearest_id = str(item.get("id", ""))
	if nearest_id == "":
		return false
	if nearest_id != "expedition":
		remember_home_position()
	else:
		has_home_resume_position = false
	player.enabled = false
	match nearest_id:
		"shop":
			show_home_shop()
		"core":
			show_core()
		"inventory":
			show_inventory()
		"settings":
			show_home_pause_menu()
		"expedition":
			start_game()
		_:
			player.enabled = true
			return false
	return true

func show_shop(message: String = "") -> void:
	shop_message = message
	clear_ui()
	add_translucent_overlay()
	ui_root.add_child(make_label(t("shop_title"), 34, Vector2(0, 82), Vector2(VIEWPORT_SIZE.x, 54), HORIZONTAL_ALIGNMENT_CENTER))
	ui_root.add_child(make_label("%s: %s    %s: %s/%s" % [t("coins"), coins, t("lives"), player_lives, max_lives], 18, Vector2(0, 138), Vector2(VIEWPORT_SIZE.x, 34), HORIZONTAL_ALIGNMENT_CENTER))

	var potion := make_button(t("buy_potion"), Vector2(330, 202), Vector2(300, 44))
	potion.pressed.connect(func() -> void: buy_potion())
	ui_root.add_child(potion)

	var sword := make_button(t("buy_sword"), Vector2(330, 258), Vector2(300, 44))
	sword.pressed.connect(func() -> void: buy_sword())
	ui_root.add_child(sword)

	var close := make_button(t("close_shop"), Vector2(360, 336), Vector2(240, 44))
	close.pressed.connect(func() -> void: resume_game())
	ui_root.add_child(close)

	if shop_message != "":
		var message_label := make_label(shop_message, 17, Vector2(0, 304), Vector2(VIEWPORT_SIZE.x, 30), HORIZONTAL_ALIGNMENT_CENTER)
		message_label.add_theme_color_override("font_color", Color(0.94, 0.84, 0.58))
		ui_root.add_child(message_label)

func buy_potion() -> void:
	if player_lives >= max_lives:
		show_shop(t("shop_full_life"))
		return
	if coins < POTION_COST:
		show_shop(t("shop_no_money"))
		return
	coins -= POTION_COST
	heal_player(potion_heal_amount())
	play_sfx("buy")
	save_run()
	show_shop(t("shop_bought_potion"))

func buy_sword() -> void:
	if has_long_sword:
		show_shop(t("shop_sword_owned"))
		return
	if coins < SWORD_COST:
		show_shop(t("shop_no_money"))
		return
	coins -= SWORD_COST
	has_long_sword = true
	purchased_items["long_sword"] = true
	if equipment.get("weapon", "short_sword") == "short_sword":
		equipment["weapon"] = "long_sword"
	update_hud()
	play_sfx("buy")
	save_run()
	show_shop(t("shop_bought_sword"))

func player_died() -> void:
	if state != "playing" and state != "paused":
		return
	state = "dead"
	paused = true
	if player:
		player.enabled = false
	play_sfx("death")
	save_run()
	show_death_screen()

func show_death_screen() -> void:
	clear_ui()
	add_translucent_overlay()
	ui_root.add_child(make_label(t("death"), 32, Vector2(0, 112), Vector2(VIEWPORT_SIZE.x, 50), HORIZONTAL_ALIGNMENT_CENTER))

	var revive := make_button(t("revive"), Vector2(350, 202), Vector2(260, 44))
	revive.disabled = coins < REVIVE_COST
	revive.pressed.connect(func() -> void: revive_from_death())
	ui_root.add_child(revive)

	var home := make_button(t("return_home"), Vector2(360, 258), Vector2(240, 44))
	home.pressed.connect(func() -> void: return_home_from_death())
	ui_root.add_child(home)
	if revive.disabled:
		home.call_deferred("grab_focus")

	var language_button := make_button(language_button_text(), Vector2(310, 314), Vector2(340, 44))
	language_button.pressed.connect(func() -> void: toggle_language())
	ui_root.add_child(language_button)

	if coins < REVIVE_COST:
		var note := make_label(t("revive_no_money"), 15, Vector2(0, 370), Vector2(VIEWPORT_SIZE.x, 26), HORIZONTAL_ALIGNMENT_CENTER)
		note.add_theme_color_override("font_color", Color(0.94, 0.7, 0.56))
		ui_root.add_child(note)

func retry_current_level() -> void:
	show_main_menu()

func return_home_from_death() -> void:
	player_lives = max_lives
	home_message = ""
	has_home_resume_position = false
	save_run()
	show_main_menu()

func revive_from_death() -> void:
	if coins < REVIVE_COST:
		show_death_screen()
		return
	coins -= REVIVE_COST
	player_lives = max_lives
	if player and is_instance_valid(player):
		player.reset_to(checkpoint_position, player_lives)
	state = "playing"
	paused = false
	clear_ui()
	show_hud()
	play_sfx("potion")
	save_run()

func level_complete() -> void:
	if state != "playing":
		return
	paused = true
	if player:
		player.enabled = false
	play_sfx("complete")
	if current_level + 1 < levels.size():
		unlocked_level = max(unlocked_level, current_level + 1)
		current_level += 1
		save_run()
		load_level(current_level)
		return
	unlocked_level = max(unlocked_level, current_level)
	home_message = t("home_complete")
	player_lives = max_lives
	has_home_resume_position = false
	save_run()
	show_main_menu()

func show_win_screen() -> void:
	clear_ui()
	add_translucent_overlay()
	ui_root.add_child(make_label(t("complete"), 36, Vector2(0, 100), Vector2(VIEWPORT_SIZE.x, 56), HORIZONTAL_ALIGNMENT_CENTER))
	ui_root.add_child(make_label(t("complete_note"), 16, Vector2(0, 160), Vector2(VIEWPORT_SIZE.x, 44), HORIZONTAL_ALIGNMENT_CENTER))

	var restart := make_button(t("play_again"), Vector2(360, 238), Vector2(240, 44))
	restart.pressed.connect(func() -> void: start_game())
	ui_root.add_child(restart)

	var language_button := make_button(language_button_text(), Vector2(310, 294), Vector2(340, 44))
	language_button.pressed.connect(func() -> void: toggle_language())
	ui_root.add_child(language_button)

	var menu := make_button(t("main_menu"), Vector2(360, 350), Vector2(240, 44))
	menu.pressed.connect(func() -> void: show_main_menu())
	ui_root.add_child(menu)

func draw_home_map_background() -> void:
	add_panel_background(Color(0.08, 0.09, 0.08, 1.0))
	var sky := ColorRect.new()
	sky.color = Color(0.12, 0.17, 0.18, 1.0)
	sky.size = Vector2(VIEWPORT_SIZE.x, 182)
	ui_root.add_child(sky)
	var dawn := ColorRect.new()
	dawn.color = Color(0.88, 0.58, 0.24, 0.72)
	dawn.position = Vector2(410, 94)
	dawn.size = Vector2(140, 14)
	ui_root.add_child(dawn)
	var ground := ColorRect.new()
	ground.color = Color(0.34, 0.28, 0.19, 1.0)
	ground.position = Vector2(0, 182)
	ground.size = Vector2(VIEWPORT_SIZE.x, 358)
	ui_root.add_child(ground)
	var road := ColorRect.new()
	road.color = Color(0.52, 0.43, 0.28, 1.0)
	road.position = Vector2(160, 356)
	road.size = Vector2(640, 38)
	ui_root.add_child(road)

	add_home_building(Vector2(122, 216), Vector2(220, 126), Color(0.24, 0.18, 0.12), Color(0.86, 0.42, 0.18), t("home_shop"))
	add_home_core_visual(Vector2(390, 188))
	add_home_gate_visual(Vector2(626, 178))
	add_home_building(Vector2(370, 302), Vector2(220, 90), Color(0.16, 0.18, 0.2), Color(0.44, 0.64, 0.68), t("inventory"))

func add_home_building(pos: Vector2, size: Vector2, body_color: Color, roof_color: Color, label_text: String) -> void:
	var body := ColorRect.new()
	body.position = pos
	body.size = size
	body.color = body_color
	ui_root.add_child(body)
	var roof := ColorRect.new()
	roof.position = pos + Vector2(-10, -18)
	roof.size = Vector2(size.x + 20, 18)
	roof.color = roof_color
	ui_root.add_child(roof)
	var label := make_label(label_text, 15, pos + Vector2(0, size.y - 30), size, HORIZONTAL_ALIGNMENT_CENTER)
	label.add_theme_color_override("font_color", Color(0.96, 0.9, 0.72))
	ui_root.add_child(label)

func add_home_core_visual(pos: Vector2) -> void:
	var plinth := ColorRect.new()
	plinth.position = pos + Vector2(34, 118)
	plinth.size = Vector2(160, 28)
	plinth.color = Color(0.28, 0.3, 0.31)
	ui_root.add_child(plinth)
	var core := ColorRect.new()
	core.position = pos + Vector2(70, 44)
	core.size = Vector2(88, 88)
	core.color = Color(0.86, 0.68, 0.25)
	ui_root.add_child(core)
	var label := make_label(t("core"), 15, pos + Vector2(0, 146), Vector2(230, 28), HORIZONTAL_ALIGNMENT_CENTER)
	label.add_theme_color_override("font_color", Color(0.96, 0.9, 0.72))
	ui_root.add_child(label)

func add_home_gate_visual(pos: Vector2) -> void:
	var left := ColorRect.new()
	left.position = pos + Vector2(0, 72)
	left.size = Vector2(38, 142)
	left.color = Color(0.34, 0.31, 0.26)
	ui_root.add_child(left)
	var right := ColorRect.new()
	right.position = pos + Vector2(168, 72)
	right.size = Vector2(38, 142)
	right.color = Color(0.34, 0.31, 0.26)
	ui_root.add_child(right)
	var lintel := ColorRect.new()
	lintel.position = pos + Vector2(-10, 52)
	lintel.size = Vector2(226, 34)
	lintel.color = Color(0.52, 0.43, 0.27)
	ui_root.add_child(lintel)
	var light := ColorRect.new()
	light.position = pos + Vector2(58, 98)
	light.size = Vector2(90, 116)
	light.color = Color(0.95, 0.66, 0.28, 0.42)
	ui_root.add_child(light)
	var label := make_label(t("start"), 15, pos + Vector2(-18, 218), Vector2(242, 28), HORIZONTAL_ALIGNMENT_CENTER)
	label.add_theme_color_override("font_color", Color(0.96, 0.9, 0.72))
	ui_root.add_child(label)

func add_panel_background(color: Color) -> void:
	var bg := ColorRect.new()
	bg.color = color
	bg.size = VIEWPORT_SIZE
	ui_root.add_child(bg)

func add_translucent_overlay() -> void:
	var overlay := ColorRect.new()
	overlay.color = Color(0.0, 0.0, 0.0, 0.68)
	overlay.size = VIEWPORT_SIZE
	ui_root.add_child(overlay)

func make_label(text: String, font_size: int, pos: Vector2, size: Vector2, align: int) -> Label:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.size = size
	label.horizontal_alignment = align
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	return label

func make_button(text: String, pos: Vector2, size: Vector2) -> Button:
	var button := Button.new()
	button.text = text
	button.position = pos
	button.size = size
	button.focus_mode = Control.FOCUS_ALL
	button.add_theme_font_override("font", FONT_UI)
	button.add_theme_font_size_override("font_size", 18)
	if not ui_focus_assigned:
		ui_focus_assigned = true
		button.call_deferred("grab_focus")
	button.pressed.connect(func() -> void: play_sfx("ui"))
	return button

func play_sfx(name: String) -> void:
	if audio_manager and audio_manager.has_method("play_sfx"):
		audio_manager.play_sfx(name)
