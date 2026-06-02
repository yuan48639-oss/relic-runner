extends Node

signal status_changed(message: String)

const DEFAULT_PORT = 24567
const MAX_CLIENTS = 2

var peer: ENetMultiplayerPeer
var is_hosting := false

func host(port: int = DEFAULT_PORT) -> bool:
	stop()
	peer = ENetMultiplayerPeer.new()
	var result := peer.create_server(port, MAX_CLIENTS)
	if result != OK:
		status_changed.emit("Host failed: %s" % result)
		return false
	multiplayer.multiplayer_peer = peer
	is_hosting = true
	status_changed.emit("Hosting on UDP %s" % port)
	return true

func join(address: String, port: int = DEFAULT_PORT) -> bool:
	stop()
	peer = ENetMultiplayerPeer.new()
	var result := peer.create_client(address, port)
	if result != OK:
		status_changed.emit("Join failed: %s" % result)
		return false
	multiplayer.multiplayer_peer = peer
	is_hosting = false
	status_changed.emit("Joining %s:%s" % [address, port])
	return true

func stop() -> void:
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	peer = null
	is_hosting = false

func status() -> String:
	if multiplayer.multiplayer_peer == null:
		return "Offline"
	if is_hosting:
		return "Hosting"
	return "Client"

