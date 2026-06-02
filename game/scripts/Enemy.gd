extends CharacterBody2D

const LAYER_WORLD = 1
const LAYER_ENEMY = 4

var game
var active := true
var speed := 72.0
var gravity := 1100.0
var left_x := 0.0
var right_x := 0.0
var direction := -1.0
var enemy_type := "patrol"
var base_y := 0.0
var flight_time := 0.0
var anim_time := 0.0
var hp := 1
var max_hp := 1

func setup(spawn: Vector2, patrol_width: float, owner: Node, type_name: String = "patrol", hp_value: int = 1) -> void:
	global_position = spawn
	left_x = spawn.x - patrol_width
	right_x = spawn.x + patrol_width
	game = owner
	enemy_type = type_name
	base_y = spawn.y
	max_hp = max(1, hp_value)
	hp = max_hp
	if enemy_type == "shield":
		speed = 44.0
	elif enemy_type == "crawler":
		speed = 110.0
	elif enemy_type == "boss":
		speed = 38.0

func _ready() -> void:
	collision_layer = LAYER_ENEMY
	collision_mask = 0 if enemy_type == "flyer" else LAYER_WORLD
	var collision := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(46.0, 42.0) if enemy_type == "boss" else Vector2(30.0, 30.0)
	collision.shape = rect
	collision.position = Vector2(0.0, -21.0) if enemy_type == "boss" else Vector2(0.0, -15.0)
	add_child(collision)
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not active:
		return
	if game and game.has_method("is_game_paused") and game.call("is_game_paused"):
		return
	anim_time += delta
	if enemy_type == "flyer":
		flight_time += delta
		global_position.x += direction * speed * delta
		global_position.y = base_y + sin(flight_time * 3.0) * 18.0
		if global_position.x <= left_x:
			direction = 1.0
		elif global_position.x >= right_x:
			direction = -1.0
		queue_redraw()
		return
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * speed
	move_and_slide()
	if global_position.x <= left_x:
		direction = 1.0
	elif global_position.x >= right_x:
		direction = -1.0
	queue_redraw()

func defeat() -> void:
	if not active:
		return
	active = false
	queue_free()

func take_damage(amount: int = 1) -> bool:
	if not active:
		return false
	hp -= amount
	if hp <= 0:
		return true
	queue_redraw()
	return false

func _draw() -> void:
	var color := Color(0.94, 0.28, 0.28)
	if enemy_type == "flyer":
		color = Color(0.72, 0.36, 0.92)
	elif enemy_type == "shield":
		color = Color(0.5, 0.62, 0.72)
	elif enemy_type == "crawler":
		color = Color(0.94, 0.5, 0.18)
	elif enemy_type == "boss":
		color = Color(0.75, 0.22, 0.12)
	if hp < max_hp:
		color = color.lightened(0.25)
	var bob := sin(anim_time * 7.0) * 1.6
	if enemy_type == "boss":
		draw_polygon(PackedVector2Array([Vector2(-17.0, -42.0 + bob), Vector2(-27.0, -58.0 + bob), Vector2(-8.0, -47.0 + bob)]), PackedColorArray([Color(0.95, 0.78, 0.42), Color(0.95, 0.78, 0.42), Color(0.95, 0.78, 0.42)]))
		draw_polygon(PackedVector2Array([Vector2(17.0, -42.0 + bob), Vector2(27.0, -58.0 + bob), Vector2(8.0, -47.0 + bob)]), PackedColorArray([Color(0.95, 0.78, 0.42), Color(0.95, 0.78, 0.42), Color(0.95, 0.78, 0.42)]))
		draw_circle(Vector2(0.0, -24.0 + bob), 25.0, color)
		draw_circle(Vector2(-8.0, -33.0 + bob), 7.0, color.lightened(0.22))
		draw_circle(Vector2(-9.0, -30.0 + bob), 3.2, Color(0.08, 0.02, 0.02))
		draw_circle(Vector2(9.0, -30.0 + bob), 3.2, Color(0.08, 0.02, 0.02))
		draw_circle(Vector2(-14.0, -23.0 + bob), 3.0, Color(1.0, 0.45, 0.38, 0.45))
		draw_circle(Vector2(14.0, -23.0 + bob), 3.0, Color(1.0, 0.45, 0.38, 0.45))
		draw_rect(Rect2(-12.0, -14.0 + bob, 24.0, 4.0), Color(0.32, 0.06, 0.04))
		draw_rect(Rect2(-27.0, -24.0 + bob, 8.0, 16.0), color.darkened(0.18))
		draw_rect(Rect2(19.0, -24.0 + bob, 8.0, 16.0), color.darkened(0.18))
		draw_line(Vector2(22.0, -16.0 + bob), Vector2(38.0, -26.0 + bob), color.darkened(0.18), 4.0)
		draw_circle(Vector2(40.0, -27.0 + bob), 3.0, Color(0.95, 0.78, 0.42))
		draw_rect(Rect2(-18.0, -52.0, 36.0 * float(hp) / float(max_hp), 5.0), Color(0.9, 0.16, 0.12))
		return
	if enemy_type == "flyer":
		var wing := 8.0 + sin(anim_time * 11.0) * 4.0
		draw_polygon(PackedVector2Array([Vector2(-12.0, -17.0 + bob), Vector2(-30.0, -26.0 - wing), Vector2(-18.0, -10.0 + bob)]), PackedColorArray([color.lightened(0.15), color.lightened(0.15), color.lightened(0.15)]))
		draw_polygon(PackedVector2Array([Vector2(12.0, -17.0 + bob), Vector2(30.0, -26.0 - wing), Vector2(18.0, -10.0 + bob)]), PackedColorArray([color.lightened(0.15), color.lightened(0.15), color.lightened(0.15)]))
		draw_circle(Vector2(0.0, -18.0 + bob), 15.0, color)
	elif enemy_type == "crawler":
		draw_circle(Vector2(-7.0, -15.0 + bob), 12.0, color)
		draw_circle(Vector2(8.0, -15.0 + bob), 12.0, color)
		for i in range(4):
			draw_line(Vector2(-13.0 + i * 8.0, -5.0 + bob), Vector2(-17.0 + i * 8.0, -1.0), color.darkened(0.25), 2.0)
	elif enemy_type == "shield":
		draw_circle(Vector2(0.0, -18.0 + bob), 15.0, color)
		draw_rect(Rect2(-18.0, -27.0 + bob, 10.0, 24.0), Color(0.72, 0.8, 0.86))
	else:
		draw_circle(Vector2(0.0, -18.0 + bob), 15.0, color)
	draw_polygon(PackedVector2Array([Vector2(-10.0, -29.0 + bob), Vector2(-16.0, -42.0 + bob), Vector2(-3.0, -33.0 + bob)]), PackedColorArray([Color(0.96, 0.78, 0.42), Color(0.96, 0.78, 0.42), Color(0.96, 0.78, 0.42)]))
	draw_polygon(PackedVector2Array([Vector2(10.0, -29.0 + bob), Vector2(16.0, -42.0 + bob), Vector2(3.0, -33.0 + bob)]), PackedColorArray([Color(0.96, 0.78, 0.42), Color(0.96, 0.78, 0.42), Color(0.96, 0.78, 0.42)]))
	draw_line(Vector2(12.0, -11.0 + bob), Vector2(24.0, -20.0 + bob), color.darkened(0.2), 3.0)
	draw_circle(Vector2(25.0, -21.0 + bob), 2.6, Color(0.96, 0.78, 0.42))
	draw_circle(Vector2(-5.0, -25.0 + bob), 4.5, color.lightened(0.2))
	draw_rect(Rect2(-12.0, -4.0 + bob, 8.0, 4.0), color.darkened(0.25))
	draw_rect(Rect2(4.0, -4.0 + bob, 8.0, 4.0), color.darkened(0.25))
	draw_circle(Vector2(-5.0, -23.0 + bob), 2.6, Color(0.1, 0.02, 0.02))
	draw_circle(Vector2(6.0, -23.0 + bob), 2.6, Color(0.1, 0.02, 0.02))
	draw_circle(Vector2(-9.0, -17.0 + bob), 2.0, Color(1.0, 0.48, 0.42, 0.45))
	draw_circle(Vector2(10.0, -17.0 + bob), 2.0, Color(1.0, 0.48, 0.42, 0.45))
	draw_rect(Rect2(-8.0, -10.0 + bob, 16.0, 3.0), Color(0.4, 0.08, 0.08))
