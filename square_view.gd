extends Node2D

class_name square_view

signal square_clicked
@onready var mysprite : Sprite2D = get_node('sprite')

func set_color(color: bool):
	match color:
		false:
			pass
		true:
			mysprite.modulate = Color('737373')

func update_position(coord: Vector2):
	position = coord * 32

func change_display(state: int):
	match  state:
		0:
			#default state
			modulate = Color('ffffff')
		1:
			#when a square has been selected
			modulate = Color('61b5ff')
		2:
			#when a piece can be moved onto this square
			modulate = Color('96ceff')
		3:
			#when a piece is in check
			modulate = Color('ff8282')

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT :
			if event.pressed:
				square_clicked.emit()
