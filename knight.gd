extends piece

class_name knight

func get_valid_moves(iboard : board) -> Array[square]:
	var valid_moves : Array[square]
	const moves_list = [Vector2(-2, 1), Vector2(-1, 2), Vector2(-2, -1), Vector2(-1, -2), Vector2(2, 1), Vector2(1, 2), Vector2(2, -1), Vector2(1, -2)]
	for vector in moves_list:
		var new_move = iboard.get_square(get_coord() + vector)
		if new_move != null:
			if (new_move.is_occupied() == true && new_move.get_occupying_piece().is_enemy(self)) || new_move.is_occupied() == false:
				valid_moves.append(new_move)
	return valid_moves
