extends Control

@export var span: float = 60

func _ready() -> void:
	Bus.cardplaced.connect(cardsent)

func organize() -> void:
	var hand_size = get_children().size()
	if hand_size>7:
		span = 90
	elif hand_size>9:
		span = 120
	else:
		span = 60
	if hand_size> 1:
		for i in hand_size:
			var ratio:=.5
			var hand_ratio:=.5
			hand_ratio = float(i)/(float(hand_size)-1)
			get_child(i).rotation_degrees = hand_ratio*span - (span/2)
	else:
		get_child(0)


func cardsent(card):
	add_card.bind(card).rpc()
	if not get_child_count()-1: 
		print("WINNER", multiplayer.get_unique_id())



@rpc("any_peer","call_local","reliable")
func add_card(card):
	$"/root/Main/table".card = card
	$"/root/Main/table".update()
	var sender_id = multiplayer.get_remote_sender_id()
	prints(sender_id,card)
