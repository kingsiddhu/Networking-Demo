extends Node

var peer = ENetMultiplayerPeer.new()
var players :Array= [1]
var current = 1
@export var myturn: bool = false
var card_obj = preload("res://card.tscn")
var card 

func _peerconnected(i):
	print(i)
	players.append(i)
func _on_host_pressed() -> void:
	$Panel/VBoxContainer/Button.visible = true
	peer.create_server(42069)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_peerconnected)

func _on_join_pressed() -> void:
	peer.create_client($Panel/VBoxContainer/TextEdit.text, 42069)
	multiplayer.multiplayer_peer = peer
	print(multiplayer.get_unique_id())

func _on_button_pressed() -> void:
	print(multiplayer.get_unique_id())
	peer.refuse_new_connections = true
	for i in players:
		if i!=1:
			var arr := []
			for x in 5:
				card = %Deck.cards.pick_random()
				arr.append(card)
				%Deck.cards.erase(card)
			start.bind(arr).rpc_id(i)
	var arr := []
	for x in 5:
		card = %Deck.cards.pick_random()
		arr.append(card)
		%Deck.cards.erase(card)
	start(arr)
@rpc
func start(cards):
	print(cards)
	for i in cards:
		var c = card_obj.instantiate()
		c.card = i
		%Hand.add_child(c)
	%Hand.organize()
@rpc
func reverse(player_id):
	if multiplayer.is_server():
		players.reverse()
func get_next(player_id):
	if multiplayer.is_server():
		return players[wrap(players.find(player_id)+1,0,players.size())]
