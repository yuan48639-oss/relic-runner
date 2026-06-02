extends Node

const BUS_NAMES = ["Music", "SFX", "UI"]

var volumes := {
	"Master": 0.8,
	"Music": 0.8,
	"SFX": 0.8,
	"UI": 0.8
}

func _ready() -> void:
	ensure_buses()
	apply_all()

func ensure_buses() -> void:
	for bus_name in BUS_NAMES:
		if AudioServer.get_bus_index(bus_name) == -1:
			AudioServer.add_bus()
			AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, bus_name)

func set_volume(bus_name: String, value: float) -> void:
	volumes[bus_name] = clampf(value, 0.0, 1.0)
	var index := AudioServer.get_bus_index(bus_name)
	if index == -1:
		return
	AudioServer.set_bus_volume_db(index, linear_to_db(maxf(volumes[bus_name], 0.001)))

func get_volume(bus_name: String) -> float:
	return float(volumes.get(bus_name, 0.8))

func apply_all() -> void:
	for bus_name in volumes.keys():
		set_volume(bus_name, volumes[bus_name])

func export_settings() -> Dictionary:
	return volumes.duplicate(true)

func apply_settings(data: Dictionary) -> void:
	for bus_name in data.keys():
		if volumes.has(bus_name):
			set_volume(bus_name, float(data[bus_name]))

func play_sfx(name: String) -> void:
	var tone_map := {
		"ui": [660.0, 0.035, "UI"],
		"coin": [880.0, 0.07, "SFX"],
		"coin_drop": [720.0, 0.045, "SFX"],
		"coin_pickup": [1240.0, 0.075, "SFX"],
		"sword": [1320.0, 0.045, "SFX"],
		"hit": [260.0, 0.08, "SFX"],
		"martial_hit": [180.0, 0.105, "SFX"],
		"potion": [520.0, 0.12, "SFX"],
		"buy": [740.0, 0.11, "UI"],
		"skill": [620.0, 0.13, "SFX"],
		"fire": [96.0, 0.18, "SFX"],
		"complete": [980.0, 0.18, "SFX"],
		"death": [140.0, 0.2, "SFX"]
	}
	var tone: Array = tone_map.get(name, [440.0, 0.06, "SFX"])
	play_tone(float(tone[0]), float(tone[1]), str(tone[2]))

func play_tone(frequency: float, duration: float, bus_name: String) -> void:
	var player := AudioStreamPlayer.new()
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = 22050.0
	stream.buffer_length = duration + 0.08
	player.stream = stream
	player.bus = bus_name
	add_child(player)
	player.play()
	var playback: AudioStreamGeneratorPlayback = player.get_stream_playback()
	var frames := int(stream.mix_rate * duration)
	for i in range(frames):
		var value := sin(TAU * frequency * float(i) / stream.mix_rate) * 0.18
		playback.push_frame(Vector2(value, value))
	await get_tree().create_timer(duration + 0.08).timeout
	if is_instance_valid(player):
		player.queue_free()
