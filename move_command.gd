extends Object

class_name move_command

var Iboard : board_model
var Ipiece : piece_model
var targetSquare : square_model
var startSquare : square_model
var capturedPiece : piece_model

func _init(iboard: board_model = null, ipiece: piece_model = null, target: square_model = null):
	Iboard = iboard
	Ipiece = ipiece
	targetSquare = target
	startSquare = Ipiece.get_square()
		
func execute():
	if targetSquare.is_occupied() && targetSquare.get_occupying_piece().is_enemy(Ipiece):
		capturedPiece = Iboard.capture(targetSquare)
		capturedPiece.piece_captured.emit()
	Ipiece.set_square(targetSquare)
	startSquare.set_occupying_piece(null)

func undo():
	Ipiece.set_square(startSquare)
	if capturedPiece != null:
		Iboard.add_piece(capturedPiece)
		capturedPiece.set_square(targetSquare)
		capturedPiece.piece_capture_cancelled.emit()
	else:
		targetSquare.set_occupying_piece(null)

func try(callback: Callable) -> bool:
	#this code is there to run simulations and test stuff
	#it excutes a move, checks if a condition is valid after it, then returns the value of the condition after the move is done
	#also undoes the move right after
	execute()
	var my_bool: bool = callback.call()
	undo()
	return my_bool
