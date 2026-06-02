extends CharacterBody2D

const WIDTH = 24.0
const HEIGHT = 44.0
const LAYER_WORLD = 1
const LAYER_PLAYER = 2

var game
var enabled := false
var spawn_point := Vector2.ZERO
var previous_global_position := Vector2.ZERO
var was_falling := false
var lives := 3
var facing := 1.0
var jumps_left := 2
var invulnerable_time := 0.0
var attack_time := 0.0
var attack_cooldown := 0.0
var dash_time := 0.0
var dash_cooldown := 0.0
var walk_time := 0.0

@export var speed: float = 230.0
@export var jump_velocity: float = -430.0
@export var gravity: float = 1200.0
@export var max_jumps: int = 2
@export var dash_speed: float = 520.0
@export var dash_duration: float = 0.12
@export var dash_cooldown_time: float = 0.45

func _ready() -> void:
	collision_layer = LAYER_PLAYER
	collision_mask = LAYER_WORLD
	var collision := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(WIDTH, HEIGHT)
	collision.shape = rect
	collision.position = Vector2(0, -HEIGHT / 2.0)
	add_child(collision)
	queue_redraw()

func reset_to(new_spawn: Vector2, new_lives: int = 3) -> void:
	spawn_point = new_spawn
	global_position = spawn_point
	previous_global_position = spawn_point
	velocity = Vector2.ZERO
	lives = new_lives
	jumps_left = max_jumps
	invulnerable_time = 0.35
	was_falling = false
	attack_time = 0.0
	attack_cooldown = 0.0
	dash_time = 0.0
	dash_cooldown = 0.0
	enabled = true
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not enabled:
		return

	previous_global_position = global_position
	invulnerable_time = maxf(invulnerable_time - delta, 0.0)
	attack_time = maxf(attack_time - delta, 0.0)
	attack_cooldown = maxf(attack_cooldown - delta, 0.0)
	dash_time = maxf(dash_time - delta, 0.0)
	dash_cooldown = maxf(dash_cooldown - delta, 0.0)

	if is_on_floor():
		jumps_left = max_jumps
	else:
		velocity.y += gravity * delta

	var direction := Input.get_axis("move_left", "move_right")
	if absf(direction) > 0.05:
		facing = signf(direction)
		walk_time += delta * 9.0
	elif not is_on_floor():
		walk_time += delta * 4.0
	else:
		walk_time += delta * 2.0
	velocity.x = direction * speed

	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = jump_velocity
		jumps_left -= 1

	if Input.is_action_just_pressed("dash") and dash_cooldown <= 0.0:
		dash_time = dash_duration
		dash_cooldown = dash_cooldown_time

	if dash_time > 0.0:
		velocity.x = facing * dash_speed
		velocity.y = 0.0

	if Input.is_action_just_pressed("attack") and attack_cooldown <= 0.0:
		if game and game.has_method("try_interact") and game.call("try_interact"):
			return
		attack_time = 0.14
		attack_cooldown = 0.32
		if game and game.has_method("player_attack"):
			game.call("player_attack", global_position, facing)

	was_falling = velocity.y > 0.0
	move_and_slide()
	queue_redraw()

func take_hit(from_x: float) -> void:
	if invulnerable_time > 0.0 or not enabled:
		return
	if game and game.has_method("should_block_hit") and game.call("should_block_hit", from_x):
		invulnerable_time = 0.75
		var block_knock_dir := signf(global_position.x - from_x)
		if block_knock_dir == 0.0:
			block_knock_dir = -facing
		velocity = Vector2(block_knock_dir * 160.0, -260.0)
		queue_redraw()
		return
	lives -= 1
	if game and game.has_method("set_player_lives"):
		game.call("set_player_lives", lives)
	if game and game.has_method("update_hud"):
		game.call("update_hud")
	if lives <= 0:
		enabled = false
		if game and game.has_method("player_died"):
			game.call("player_died")
		return

	invulnerable_time = 1.1
	var knock_dir := signf(global_position.x - from_x)
	if knock_dir == 0.0:
		knock_dir = -facing
	velocity = Vector2(knock_dir * 190.0, -330.0)
	queue_redraw()

func bounce_after_stomp() -> void:
	velocity.y = jump_velocity * 0.65

func _draw() -> void:
	var bob := sin(walk_time) * 2.0 if is_on_floor() else 0.0
	var weapon := "short_sword"
	var boots := "worn_boots"
	var armor := "cloth"
	var charm := "none"
	if game and game.has_method("get_equipped_visual"):
		weapon = str(game.call("get_equipped_visual", "weapon"))
		boots = str(game.call("get_equipped_visual", "boots"))
		armor = str(game.call("get_equipped_visual", "armor"))
		charm = str(game.call("get_equipped_visual", "charm"))
	var body_color := Color(0.28, 0.78, 0.94)
	if dash_time > 0.0:
		body_color = Color(0.72, 0.94, 1.0)
	if invulnerable_time > 0.0 and int(invulnerable_time * 16.0) % 2 == 0:
		body_color = Color(0.85, 0.95, 1.0, 0.55)

	draw_rect(Rect2(-13.0, -4.0, 26.0, 4.0), Color(0.05, 0.09, 0.1, 0.45))
	draw_circle(Vector2(0, -31 + bob), 14.0, body_color)
	draw_circle(Vector2(-4.0, -43.0 + bob), 5.0, Color(0.95, 0.82, 0.48))
	draw_circle(Vector2(4.0, -43.0 + bob), 5.0, Color(0.95, 0.82, 0.48))
	draw_rect(Rect2(-10.0, -28.0 + bob, 20.0, 23.0), body_color.darkened(0.08))
	if armor == "bronze_armor":
		draw_rect(Rect2(-11.0, -29.0 + bob, 22.0, 18.0), Color(0.58, 0.34, 0.16))
		draw_rect(Rect2(-8.0, -26.0 + bob, 16.0, 5.0), Color(0.88, 0.62, 0.28))
		draw_rect(Rect2(-10.0, -13.0 + bob, 20.0, 3.0), Color(0.25, 0.16, 0.09))
	draw_polygon(PackedVector2Array([
		Vector2(-12.0, -25.0 + bob),
		Vector2(-22.0 * facing, -11.0 + bob),
		Vector2(-8.0, -8.0 + bob)
	]), PackedColorArray([Color(0.95, 0.68, 0.28), Color(0.95, 0.68, 0.28), Color(0.95, 0.68, 0.28)]))
	draw_circle(Vector2(5.0 * facing, -35.0 + bob), 2.2, Color(0.03, 0.07, 0.09))
	draw_circle(Vector2(10.0 * facing, -35.0 + bob), 2.2, Color(0.03, 0.07, 0.09))
	draw_circle(Vector2(10.5 * facing, -30.0 + bob), 2.0, Color(1.0, 0.48, 0.48, 0.55))
	draw_line(Vector2(-5.0, -26.0 + bob), Vector2(6.0, -26.0 + bob), Color(0.1, 0.32, 0.38), 2.0)
	draw_rect(Rect2(-12.0, -24.0 + bob, 24.0, 4.0), Color(0.95, 0.28, 0.24))
	if charm != "none":
		var charm_color := Color(0.95, 0.78, 0.24) if charm == "coin_charm" else Color(0.9, 0.28, 0.42)
		draw_line(Vector2(-4.0, -23.0 + bob), Vector2(4.0, -23.0 + bob), Color(0.9, 0.82, 0.58), 1.5)
		draw_circle(Vector2(0.0, -18.0 + bob), 4.0, charm_color)
		draw_circle(Vector2(0.0, -18.0 + bob), 1.5, Color(1.0, 0.96, 0.72, 0.8))
	var leg_swing := sin(walk_time * 1.6) * 3.0
	var boot_color := Color(0.11, 0.25, 0.3)
	if boots == "swift_boots":
		boot_color = Color(0.2, 0.72, 0.92)
	elif boots == "wing_boots":
		boot_color = Color(0.72, 0.9, 1.0)
	draw_rect(Rect2(-8.0 + leg_swing, -7.0, 5.0, 7.0), boot_color)
	draw_rect(Rect2(3.0 - leg_swing, -7.0, 5.0, 7.0), boot_color.darkened(0.12))
	if boots == "wing_boots":
		draw_rect(Rect2(8.0 - leg_swing, -9.0, 7.0, 2.5), Color(0.96, 0.98, 1.0))
		draw_rect(Rect2(-15.0 + leg_swing, -9.0, 7.0, 2.5), Color(0.96, 0.98, 1.0))
	var sheath_color := Color(0.86, 0.72, 0.38)
	var blade_sheath := Color(0.72, 0.82, 0.86)
	if weapon == "long_sword":
		sheath_color = Color(0.9, 0.62, 0.25)
		blade_sheath = Color(0.86, 0.9, 0.92)
	elif weapon == "dawn_blade":
		sheath_color = Color(0.92, 0.78, 0.32)
		blade_sheath = Color(0.72, 0.96, 1.0)
	draw_line(Vector2(-8.0 * facing, -27.0 + bob), Vector2(-18.0 * facing, -14.0 + bob), sheath_color, 3.0)
	draw_line(Vector2(-17.0 * facing, -14.0 + bob), Vector2(-25.0 * facing, -7.0 + bob), blade_sheath, 2.6)

	if attack_time > 0.0:
		var reach := 34.0
		if game and game.has_method("get_attack_reach"):
			reach = game.call("get_attack_reach")
		var blade_color := Color(1.0, 0.86, 0.28, 0.72)
		if weapon == "long_sword":
			blade_color = Color(0.96, 0.9, 0.72, 0.78)
		elif weapon == "dawn_blade" or reach > 80.0:
			blade_color = Color(0.8, 0.96, 1.0, 0.82)
		var start := Vector2(12.0 * facing, -27.0 + bob)
		var tip := Vector2((18.0 + reach) * facing, -31.0 + bob)
		var edge := Vector2((12.0 + reach * 0.7) * facing, -13.0 + bob)
		draw_polygon(PackedVector2Array([start, tip, edge]), PackedColorArray([blade_color, blade_color, Color(blade_color.r, blade_color.g, blade_color.b, 0.2)]))
		draw_line(start, tip, Color(1.0, 0.98, 0.72, 0.9), 4.0)
