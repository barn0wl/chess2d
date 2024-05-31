extends Object

class_name piece_model

var color : bool
#false = black and true = white
var myboard : board_model
var current_square : square_model :
	set = set_square
var sprite : CompressedTexture2D

signal piece_captured
signal piece_capture_cancelled

func _init(icolor: bool, iboard: board_model = null, start_square: square_model = null):
	color = icolor
	myboard = iboard
	current_square = start_square

func get_square():
	return current_square

func get_valid_moves() -> Array[square_model]:
	return []
	
func get_color():
	return color

func get_coord():
	return current_square.get_coord()

func set_square(new: square_model):
	current_square = new
	current_square.set_occupying_piece(self)

func is_enemy(refPiece: piece_model) -> bool:
	if color != refPiece.get_color():
		return true
	else:
		return false

func get_out_of_check_moves() -> Array[square_model]:
	var out_of_check_moves : Array[square_model]
	
	for move in get_valid_moves():
		var test_move = move_command.new(myboard, self, move)
		var notInCheck = func():
			return not myboard.in_check(get_color())
		
		if test_move.try(notInCheck):
			out_of_check_moves.append(move)
	
	return out_of_check_moves
