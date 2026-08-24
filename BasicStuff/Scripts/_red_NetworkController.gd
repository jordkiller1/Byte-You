extends Node

const PORT: int = 42069
const IPADDRESS: String = "localhost"
var peer: ENetMultiplayerPeer

func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IPADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	
func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
