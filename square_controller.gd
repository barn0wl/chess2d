extends Node

class_name square_controller

var my_square_model : square_model
var my_square_view : square_view
signal square_pressed

func _init(squModel: square_model = null, squView: square_view = null):
	my_square_model = squModel
	my_square_view = squView
	
func _ready():
	var color = bool(int(my_square_model.get_coord().x + my_square_model.get_coord().y) % 2)
	my_square_view.set_color(color)
	
	my_square_view.connect('square_clicked', on_square_view_pressed)
	my_square_model.connect('valid_move', on_valid_move)
	
func get_model() -> square_model:
	return my_square_model
	
func get_view() -> square_view:
	return my_square_view

func update_position():
	var coord = my_square_model.get_coord()
	my_square_view.update_position(coord)

func on_square_view_pressed():
	square_pressed.emit(self)
	
func on_valid_move():
	my_square_view.change_display(2)
