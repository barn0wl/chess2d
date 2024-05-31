extends piece_model

class_name knight_model

func get_valid_moves() -> Array[square_model]:
	var valid_moves : Array[square_model]
	const moves_list = [Vector2(-2, 1), Vector2(-1, 2), Vector2(-2, -1), Vector2(-1, -2), Vector2(2, 1), Vector2(1, 2), Vector2(2, -1), Vector2(1, -2)]
	for vector in moves_list:
		var new_move = myboard.get_square(get_coord() + vector)
		if new_move != null:
			if (new_move.is_occupied() == true && new_move.get_occupying_piece().is_enemy(self)) || new_move.is_occupied() == false:
				valid_moves.append(new_move)
	return valid_moves
