extends Object

class_name square_model

var x_coord: int
var y_coord: int
var occupying_piece: piece_model
signal valid_move

func _init(x:int, y:int):
	x_coord = x
	y_coord = y

func is_occupied() -> bool:
	return occupying_piece != null

func get_coord() -> Vector2:
	return Vector2(x_coord, y_coord)

func set_occupying_piece(iPiece : piece_model):
	occupying_piece = iPiece
	
func get_occupying_piece() -> piece_model:
	return occupying_piece
