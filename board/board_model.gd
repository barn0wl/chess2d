extends Object

class_name board_model

var board_state: Array[Array]
var pieces : Array[piece_model]
	
func add_square_row(new_row : Array[square_model]) -> void:
	board_state.append(new_row)

func add_piece(myPiece: piece_model) -> void:
	pieces.append(myPiece)
	
func get_square(coord : Vector2) -> square_model:
	if coord.x >= 0 && coord.x < 8 && coord.y >= 0 && coord.y < 8 :
		var element = board_state[coord.y][coord.x]
		return element
	else:
		return null

func get_king(king_color: bool) -> king_model:
	for ipiece in pieces:
		if ipiece is king_model && (ipiece.get_color() == king_color):
			return ipiece
	return null

func get_allied_pieces(mypiece: piece_model) -> Array[piece_model]:
	var allied_pieces : Array[piece_model]
	for ipiece in pieces:
		if not ipiece.is_enemy(mypiece):
			allied_pieces.append(ipiece)
	return allied_pieces
	
func get_enemy_pieces(mypiece: piece_model) -> Array[piece_model]:
	var enemy_pieces : Array[piece_model]
	for ipiece in pieces:
		if ipiece.is_enemy(mypiece):
			enemy_pieces.append(ipiece)
	return enemy_pieces
	
func in_check(player : bool):
	#this function checks if the passed player's king is under threat
	var myKing : king_model = get_king(player)
	var enemy_pieces = get_enemy_pieces(myKing)
	var king_square : square_model = myKing.get_square()
	for enemy in enemy_pieces:
		if king_square in enemy.get_valid_moves():
			return true
	return false
	
func capture(targetsquare: square_model) -> piece_model:
	var captured : piece_model = targetsquare.get_occupying_piece()
	var pieceId = pieces.find(captured)
	pieces.pop_at(pieceId)
	return captured
	
func get_board_state():
	return board_state

func get_out_of_check_pieces(player: bool) -> Array[piece_model]:
	var out_of_check_pieces : Array[piece_model]
	var allied_pieces = get_allied_pieces(get_king(player))
	for ally in allied_pieces:
		#the king has a dedicated function that computes his getoutofcheck moves so we separate him
		if ally is king_model:
			if not ally.get_out_of_check_moves().is_empty():
				out_of_check_pieces.append(ally)
		else:
			for possible_move in ally.get_valid_moves():
				var test_move = move_command.new(self, ally, possible_move)
				var notInCheck = func():
					return not in_check(player)
				if test_move.try(notInCheck):
					#if after this theoretical move, the king isnt in check anymore, then the piece
					#qualifies as being part of the get out of check pieces, and we can move on to a new piece
					out_of_check_pieces.append(ally)
					break
	return out_of_check_pieces
