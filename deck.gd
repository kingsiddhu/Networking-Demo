extends Control

var cards :Array= []

var card_obj = preload("res://card.tscn")
func _ready() -> void:
	_makedeck()
	
func _makedeck():
	for i in "RGBY":
		for X in range(1,11):
			cards.append(i+str(X))
		for X in "RSP":
			cards.append(i+X)
			
	for i in "WWWW":
		for X in "WP":
			cards.append(i+str(X))
	print(cards)
	
func _getcard():
	if cards.is_empty():
		_makedeck()
	var c = cards.pick_random()
	cards.erase(c)
	print("made",c)
	return c


func _on_button_pressed() -> void:
	if multiplayer.is_server():
		var c = card_obj.instantiate()
		c.card = _getcard()
		%Hand.add_child(c)
	else:
		prints("GIMME", multiplayer.get_unique_id())
		get_card.bind(multiplayer.get_unique_id(),"B0").rpc_id(1)

#Getting only from server
@rpc("any_peer")
func get_card(id,card):
	if multiplayer.is_server():
		get_card.bind(id,_getcard()).rpc_id(id)
	elif multiplayer.get_unique_id() == id:
		print("thanks",id)
		var c = card_obj.instantiate()
		c.card = card
		%Hand.add_child(c)
@rpc
func givecards(id, cards, no=0):
	if multiplayer.is_server():
		match no:
			2:
				givecards.bind(%Multiplayer.get_next(id),[_getcard(),_getcard()], no).rpc_id(%Multiplayer.get_next(id))
			4:
				givecards.bind(%Multiplayer.get_next(id),[_getcard(),_getcard(),_getcard(),_getcard()], no).rpc_id(%Multiplayer.get_next(id))
	elif multiplayer.get_unique_id() == id:
		for i in cards:
			print("thanks",id)
			var c = card_obj.instantiate()
			c.card = i
			%Hand.add_child(c)
