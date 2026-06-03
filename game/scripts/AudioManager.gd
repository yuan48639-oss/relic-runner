extends Node

const BUS_NAMES = ["Music", "SFX", "UI"]
const SFX_UI_CLICK = preload("res://assets/kenney/audio/ui_click.ogg")
const SFX_UI_CONFIRM = preload("res://assets/kenney/audio/ui_confirm.ogg")
const SFX_UI_BACK = preload("res://assets/kenney/audio/ui_back.ogg")

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
	var imported := imported_sfx(name)
	if imported:
		play_imported_sfx(imported, "UI")
		return
	if name == "sword":
		play_sword_whoosh()
		return
	if name == "hit":
		play_impact(false)
		return
	if name == "martial_hit":
		play_martial_hit()
		return
	if name == "spike_hit":
		play_spike_hit()
		return
	if name == "coin" or name == "coin_pickup":
		play_coin_jingle(true)
		return
	if name == "coin_drop":
		play_coin_jingle(false)
		return
	var tone_map := {
		"ui": [660.0, 0.035, "UI"],
		"potion": [520.0, 0.12, "SFX"],
		"buy": [740.0, 0.11, "UI"],
		"skill": [620.0, 0.13, "SFX"],
		"fire": [96.0, 0.18, "SFX"],
		"complete": [980.0, 0.18, "SFX"],
		"death": [140.0, 0.2, "SFX"]
	}
	var tone: Array = tone_map.get(name, [440.0, 0.06, "SFX"])
	play_tone(float(tone[0]), float(tone[1]), str(tone[2]))

func imported_sfx(name: String) -> AudioStream:
	match name:
		"ui":
			return SFX_UI_CLICK
		"buy", "skill", "complete":
			return SFX_UI_CONFIRM
		"back":
			return SFX_UI_BACK
	return null

func play_imported_sfx(stream: AudioStream, bus_name: String) -> void:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = bus_name
	add_child(player)
	player.play()
	await get_tree().create_timer(maxf(stream.get_length(), 0.12) + 0.04).timeout
	if is_instance_valid(player):
		player.queue_free()

func play_sword_whoosh() -> void:
	var player := AudioStreamPlayer.new()
	var stream := AudioStreamGenerator.new()
	var duration := 0.18
	stream.mix_rate = 44100.0
	stream.buffer_length = duration + 0.08
	player.stream = stream
	player.bus = "SFX"
	add_child(player)
	player.play()
	var playback: AudioStreamGeneratorPlayback = player.get_stream_playback()
	var frames := int(stream.mix_rate * duration)
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var previous_noise := 0.0
	for i in range(frames):
		var t := float(i) / maxf(float(frames - 1), 1.0)
		var attack := clampf(t / 0.18, 0.0, 1.0)
		var decay := pow(1.0 - t, 1.7)
		var envelope := sin(PI * attack) * decay
		var frequency := lerpf(1900.0, 280.0, t)
		var blade_tone := sin(TAU * frequency * float(i) / stream.mix_rate) * 0.08
		var raw_noise := rng.randf_range(-1.0, 1.0)
		var air_noise := (raw_noise - previous_noise * 0.42) * 0.17
		previous_noise = raw_noise
		var shimmer := sin(TAU * 4100.0 * float(i) / stream.mix_rate) * 0.025 * (1.0 - t)
		var value := (blade_tone + air_noise + shimmer) * envelope
		var pan := lerpf(-0.18, 0.18, t)
		playback.push_frame(Vector2(value * (1.0 - pan), value * (1.0 + pan)))
	await get_tree().create_timer(duration + 0.08).timeout
	if is_instance_valid(player):
		player.queue_free()

func play_impact(heavy: bool) -> void:
	var player := AudioStreamPlayer.new()
	var stream := AudioStreamGenerator.new()
	var duration := 0.13 if heavy else 0.09
	stream.mix_rate = 44100.0
	stream.buffer_length = duration + 0.06
	player.stream = stream
	player.bus = "SFX"
	add_child(player)
	player.play()
	var playback: AudioStreamGeneratorPlayback = player.get_stream_playback()
	var frames := int(stream.mix_rate * duration)
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in range(frames):
		var t := float(i) / maxf(float(frames - 1), 1.0)
		var envelope := pow(1.0 - t, 2.2)
		var low := sin(TAU * (120.0 if heavy else 190.0) * float(i) / stream.mix_rate) * (0.28 if heavy else 0.18)
		var crack := rng.randf_range(-1.0, 1.0) * (0.12 if heavy else 0.08) * pow(1.0 - t, 5.0)
		var value := (low + crack) * envelope
		playback.push_frame(Vector2(value, value))
	await get_tree().create_timer(duration + 0.06).timeout
	if is_instance_valid(player):
		player.queue_free()

func play_martial_hit() -> void:
	var player := AudioStreamPlayer.new()
	var stream := AudioStreamGenerator.new()
	var duration := 0.18
	stream.mix_rate = 44100.0
	stream.buffer_length = duration + 0.06
	player.stream = stream
	player.bus = "SFX"
	add_child(player)
	player.play()
	var playback: AudioStreamGeneratorPlayback = player.get_stream_playback()
	var frames := int(stream.mix_rate * duration)
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var last_noise := 0.0
	for i in range(frames):
		var t := float(i) / maxf(float(frames - 1), 1.0)
		var thud_env := exp(-t * 20.0)
		var slap_t := maxf(t - 0.035, 0.0)
		var slap_env := exp(-slap_t * 42.0) if t >= 0.035 else 0.0
		var crack_env := exp(-t * 86.0)
		var low_thud := sin(TAU * lerpf(92.0, 54.0, t) * float(i) / stream.mix_rate) * 0.72 * thud_env
		var body_knock := sin(TAU * 205.0 * float(i) / stream.mix_rate) * 0.34 * thud_env
		var raw_noise := rng.randf_range(-1.0, 1.0)
		var filtered_noise := raw_noise - last_noise * 0.58
		last_noise = raw_noise
		var palm_slap := filtered_noise * 0.42 * slap_env
		var snap := rng.randf_range(-1.0, 1.0) * 0.34 * crack_env
		var air := sin(TAU * 1320.0 * float(i) / stream.mix_rate) * 0.12 * slap_env
		var value := clampf(low_thud + body_knock + palm_slap + snap + air, -0.95, 0.95)
		var pan := sin(t * PI) * 0.1
		playback.push_frame(Vector2(value * (1.0 - pan), value * (1.0 + pan)))
	await get_tree().create_timer(duration + 0.06).timeout
	if is_instance_valid(player):
		player.queue_free()

func play_coin_jingle(pickup: bool) -> void:
	var player := AudioStreamPlayer.new()
	var stream := AudioStreamGenerator.new()
	var duration := 0.34 if pickup else 0.22
	stream.mix_rate = 44100.0
	stream.buffer_length = duration + 0.06
	player.stream = stream
	player.bus = "SFX"
	add_child(player)
	player.play()
	var playback: AudioStreamGeneratorPlayback = player.get_stream_playback()
	var frames := int(stream.mix_rate * duration)
	var pitches := [1760.0, 2217.46, 2637.02] if pickup else [1318.51, 1760.0]
	var delays := [0.0, 0.055, 0.12] if pickup else [0.0, 0.05]
	var gains := [0.34, 0.25, 0.2] if pickup else [0.2, 0.15]
	for i in range(frames):
		var t := float(i) / stream.mix_rate
		var value := 0.0
		for j in range(pitches.size()):
			var local_t := t - float(delays[j])
			if local_t < 0.0:
				continue
			var env := exp(-local_t * (13.0 if pickup else 18.0))
			var ring := sin(TAU * float(pitches[j]) * t) + sin(TAU * float(pitches[j]) * 2.01 * t) * 0.18
			value += ring * float(gains[j]) * env
		var sparkle := sin(TAU * 3951.0 * t) * 0.025 * exp(-t * 10.0)
		value = clampf(value + sparkle, -0.9, 0.9)
		var pan := -0.08 if pickup else 0.06
		playback.push_frame(Vector2(value * (1.0 - pan), value * (1.0 + pan)))
	await get_tree().create_timer(duration + 0.06).timeout
	if is_instance_valid(player):
		player.queue_free()

func play_spike_hit() -> void:
	var player := AudioStreamPlayer.new()
	var stream := AudioStreamGenerator.new()
	var duration := 0.12
	stream.mix_rate = 44100.0
	stream.buffer_length = duration + 0.06
	player.stream = stream
	player.bus = "SFX"
	add_child(player)
	player.play()
	var playback: AudioStreamGeneratorPlayback = player.get_stream_playback()
	var frames := int(stream.mix_rate * duration)
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i in range(frames):
		var t := float(i) / maxf(float(frames - 1), 1.0)
		var envelope := pow(1.0 - t, 2.8)
		var stab := sin(TAU * lerpf(1380.0, 520.0, t) * float(i) / stream.mix_rate) * 0.16
		var scrape := rng.randf_range(-1.0, 1.0) * 0.09 * pow(1.0 - t, 5.0)
		var low_punch := sin(TAU * 150.0 * float(i) / stream.mix_rate) * 0.12
		var value := (stab + scrape + low_punch) * envelope
		playback.push_frame(Vector2(value, value))
	await get_tree().create_timer(duration + 0.06).timeout
	if is_instance_valid(player):
		player.queue_free()

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
