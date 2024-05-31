extends Node2D

class_name piece_view

@onready var my_sprite = %sprite

func update_position(coord: Vector2):
	position = coord * 32

func update_texture(pieceType: String, pieceColor : bool):
	match pieceType:
		'p':
			my_sprite.texture = preload("res://Chess_plt45.svg")
		'r':
			my_sprite.texture = preload("res://Chess_rlt45.svg")
		'b':
			my_sprite.texture = preload("res://Chess_blt45.svg")
		'k':
			my_sprite.texture = preload("res://Chess_nlt45.svg")
		'Q':
			my_sprite.texture = preload("res://Chess_qlt45.svg")
		'K':
			my_sprite.texture = preload("res://Chess_klt45.svg")
	
	if pieceColor == false :
		my_sprite.modulate = Color('3e3e3e')

func hide_sprite():
	my_sprite.visible = false

func show_sprite():
	my_sprite.visible = true
