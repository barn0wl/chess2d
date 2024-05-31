extends Node

class_name board_controller

var my_board_model: board_model
var my_board_view: board_view
const my_square_view_sample: PackedScene = preload("res://square_view.tscn")
const my_sample_piece_view: PackedScene = preload("res://piece_view.tscn")

var current_player: bool
var selected_piece : piece_model = null
var move_queue : Array[move_command] = []
enum gamestates {ongoing, over}
var current_game_state: gamestates = gamestates.ongoing

func _init(boardModel: board_model = null, boardView: board_view = null):
	
	my_board_model = boardModel
	my_board_view = boardView
	add_child(my_board_view)
	initilize()
	
	current_player = randi_range(0,1) as bool

func initilize():
	#adding the squares
	for r in range(8):
		var row : Array[square_model]
		for c in range(8):
			var new_square = square_model.new(c, r)
			var new_square_view = my_square_view_sample.instantiate()
			var new_square_controller = square_controller.new(new_square, new_square_view)
			add_child(new_square_controller)
			new_square_controller.connect('square_pressed', on_square_pressed.bind())
			row.append(new_square)
			my_board_view.add_child(new_square_view)
		my_board_model.add_square_row(row)
		
		for child in get_children():
			if child is square_controller:
				child.update_position()
				
	#adding pieces
	for i in range(16):
		if i < 8:
			var new_piece = pawn_model.new(false, get_model(), get_model().get_square(Vector2(i, 1)))
			add_new_piece(new_piece)
		else:
			var new_piece = pawn_model.new(true, get_model(), get_model().get_square(Vector2(i - 8, 6)))
			add_new_piece(new_piece)
	
	var new_piece : piece_model
	new_piece = rook_model.new(false, get_model(), get_model().get_square(Vector2(0, 0)))
	add_new_piece(new_piece)
	new_piece = rook_model.new(true, get_model(), get_model().get_square(Vector2(0, 7)))
	add_new_piece(new_piece)
	new_piece = rook_model.new(false, get_model(), get_model().get_square(Vector2(7, 0)))
	add_new_piece(new_piece)
	new_piece = rook_model.new(true, get_model(), get_model().get_square(Vector2(7, 7)))
	add_new_piece(new_piece)
	
	new_piece = knight_model.new(false, get_model(), get_model().get_square(Vector2(1, 0)))
	add_new_piece(new_piece)
	new_piece = knight_model.new(true, get_model(), get_model().get_square(Vector2(1, 7)))
	add_new_piece(new_piece)
	new_piece = knight_model.new(false, get_model(), get_model().get_square(Vector2(6, 0)))
	add_new_piece(new_piece)
	new_piece = knight_model.new(true, get_model(), get_model().get_square(Vector2(6, 7)))
	add_new_piece(new_piece)
	
	new_piece = bishop_model.new(false, get_model(), get_model().get_square(Vector2(2, 0)))
	add_new_piece(new_piece)
	new_piece = bishop_model.new(true, get_model(), get_model().get_square(Vector2(2, 7)))
	add_new_piece(new_piece)
	new_piece = bishop_model.new(false, get_model(), get_model().get_square(Vector2(5, 0)))
	add_new_piece(new_piece)
	new_piece = bishop_model.new(true, get_model(), get_model().get_square(Vector2(5, 7)))
	add_new_piece(new_piece)
	
	new_piece = queen_model.new(false, get_model(), get_model().get_square(Vector2(3, 0)))
	add_new_piece(new_piece)
	new_piece = queen_model.new(true, get_model(), get_model().get_square(Vector2(3, 7)))
	add_new_piece(new_piece)
	
	new_piece = king_model.new(false, get_model(), get_model().get_square(Vector2(4, 0)))
	add_new_piece(new_piece)
	new_piece = king_model.new(true, get_model(), get_model().get_square(Vector2(4, 7)))
	add_new_piece(new_piece)
	
	for row in get_model().get_board_state():
		for isquare in row:
			if isquare.is_occupied():
				get_model().add_piece(isquare.get_occupying_piece())
				
func get_model() -> board_model:
	return my_board_model
	
func get_view() -> board_view:
	return my_board_view

func add_new_piece( newPiece: piece_model):
	var new_piece_view = my_sample_piece_view.instantiate()
	var new_piece_controller = piece_controller.new(newPiece, new_piece_view)
	add_child(new_piece_controller)
	my_board_view.add_child(new_piece_view)

func on_square_pressed(isquare: square_controller):
	if current_game_state != gamestates.over:
		if not my_board_model.in_check(current_player):
			
			if isquare.get_model().is_occupied() && (isquare.get_model().get_occupying_piece().get_color() == current_player):
				var myPiece : piece_model = isquare.get_model().get_occupying_piece()
				if selected_piece != null:
					reset_display()
				selected_piece = myPiece
				isquare.get_view().change_display(1)
				display_valid_moves(myPiece)
			
			elif selected_piece != null && isquare.get_model() in selected_piece.get_valid_moves():
				var new_move = move_command.new(get_model(), selected_piece, isquare.get_model())
				#after the move has been completed in the back end, we check to see if it doesnt
				#put the current player's own king in check. if it does, we undo the move and wait for another one
				var not_in_check = func():
					return not my_board_model.in_check(current_player)
					
				if new_move.try(not_in_check):
					#here, we simulate the move then check if the player inst in check after it
					new_move.execute()
					move_queue.append(new_move)
					get_view_from_model(selected_piece).update_position(selected_piece.get_coord())
					selected_piece = null
					reset_display()
					if my_board_model.in_check(not current_player):
						var square_in_check = my_board_model.get_king(not current_player).get_square()
						get_view_from_model(square_in_check).change_display(3)
						
						if my_board_model.get_out_of_check_pieces(not current_player).is_empty():
							current_game_state = gamestates.over
							print('checkmate! %s won' % current_player)
					current_player = not current_player
				else:
					print('move is not valid bc it puts your own king in check')
					
		else:
			#if the king of the current player is in check, only it can be selected
			if isquare.get_model().is_occupied() && (isquare.get_model().get_occupying_piece() in my_board_model.get_out_of_check_pieces(current_player)):
				reset_display()
				selected_piece = isquare.get_model().get_occupying_piece()
				isquare.get_view().change_display(1)
				display_valid_moves(selected_piece)
				
			elif (selected_piece in my_board_model.get_out_of_check_pieces(current_player)) && isquare.get_model() in selected_piece.get_out_of_check_moves():
				var new_move = move_command.new(get_model(), selected_piece, isquare.get_model())
				new_move.execute()
				move_queue.append(new_move)
				get_view_from_model(selected_piece).update_position(selected_piece.get_coord())
				selected_piece = null
				reset_display()
				current_player = not current_player
				
func display_valid_moves(iPiece: piece_model):
	if not my_board_model.in_check(current_player):
		for square in iPiece.get_valid_moves():
			square.valid_move.emit()
	else:
		for square in iPiece.get_out_of_check_moves():
			square.valid_move.emit()
			
func reset_display():
	for view in my_board_view.get_children():
		if view is square_view:
			view.change_display(0)

func get_view_from_model(mymodel):
	if mymodel is piece_model:
		for cont in get_children():
			if cont is piece_controller:
				if cont.my_piece_model == mymodel:
					return cont.my_piece_view
	elif mymodel is square_model:
		for cont in get_children():
			if cont is square_controller:
				if cont.my_square_model == mymodel:
					return cont.my_square_view
