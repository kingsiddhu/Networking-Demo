extends Control

@export var card: String = "R1"
var color
var text
func _ready() -> void:
	update()
	
func update():
	match card[0]:
		"R":
			color = Color(1,0,0)
		"G":
			color = Color(0,1,0)
		"B":
			color = Color(0,0,1)
		"Y":
			color = Color(1,1,0)
		"W":
			color = Color("000000")
	$ColorRect/ColorRect2.color = Color(color)
	$ColorRect/ColorRect2/Label.text = card[1]


func _on_button_pressed() -> void:
	Bus.cardplaced.emit(card)
	queue_free()
