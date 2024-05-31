extends piece

class_name bishop

func get_valid_moves(iboard : board):
	var valid_moves : Array[square]
	const DIRECTIONS = [Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]
	var current_square : square
	for dir in DIRECTIONS:
		current_square = iboard.get_square(get_coord() + dir)
		while current_square != null:
			valid_moves.append(current_square)
			if current_square.is_occupied():
				if current_square.get_occupying_piece().is_enemy(self) == false:
					valid_moves.pop_back()
				break
			current_square = iboard.get_square(current_square.get_coord() + dir)
	return valid_moves
