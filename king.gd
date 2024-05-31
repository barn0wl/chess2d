extends piece

class_name king

func get_valid_moves(iboard : board):
	var valid_moves : Array[square]
	const moves_list = [Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	for vector in moves_list:
		var new_move = iboard.get_square(get_coord() + vector)
		if new_move != null :
			valid_moves.append(new_move)
			if new_move.is_occupied():
				if new_move.get_occupying_piece().is_enemy(self) == false:
					valid_moves.pop_back()
	return valid_moves

func get_out_of_check_moves(iboard: board):
	var valid_moves: Array[square] = get_valid_moves(iboard)
	var enemy_pieces: Array[piece] = iboard.get_enemy_pieces(self)
	for move in valid_moves:
		for enemy in enemy_pieces:
			if move in enemy.get_valid_moves(iboard):
				var mov_id = valid_moves.find(move)
				valid_moves.pop_at(mov_id)
	return valid_moves
