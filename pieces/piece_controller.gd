extends Node

class_name piece_controller

var my_piece_model: piece_model
var my_piece_view: piece_view
var myPieceType : String
var myPieceColor : bool

func _init(pieceModel: piece_model = null, pieceView: piece_view = null):
	my_piece_model = pieceModel
	my_piece_view = pieceView

func _ready():
	
	my_piece_model.connect('piece_captured', on_piece_captured)
	my_piece_model.connect('piece_capture_cancelled', on_piece_capture_cancelled)
	my_piece_view.update_position(my_piece_model.get_coord())
	
	if my_piece_model is pawn_model:
		myPieceType = 'p'
	elif my_piece_model is rook_model:
		myPieceType = 'r'
	elif my_piece_model is bishop_model:
		myPieceType = 'b'
	elif my_piece_model is knight_model:
		myPieceType = 'k'
	elif my_piece_model is queen_model:
		myPieceType = 'Q'
	elif my_piece_model is king_model:
		myPieceType = 'K'
		
	myPieceColor = my_piece_model.get_color()
	my_piece_view.update_texture(myPieceType, myPieceColor)

func on_piece_captured():
	my_piece_view.hide_sprite()

func on_piece_capture_cancelled():
	my_piece_view.show_sprite()
