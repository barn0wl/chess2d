extends piece_model

class_name bishop_model

func get_valid_moves() -> Array[square_model]:
	var valid_moves : Array[square_model]
	const DIRECTIONS = [Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]
	var current_square : square_model
	for dir in DIRECTIONS:
		current_square = myboard.get_square(get_coord() + dir)
		while current_square != null:
			valid_moves.append(current_square)
			if current_square.is_occupied():
				if current_square.get_occupying_piece().is_enemy(self) == false:
					valid_moves.pop_back()
				break
			current_square = myboard.get_square(current_square.get_coord() + dir)
	return valid_moves
