extends piece

class_name pawn

func get_valid_moves(iboard : board) -> Array[square]:
	var valid_moves : Array[square]
	if get_color() == 1:
		var move1 = iboard.get_square(get_coord() + Vector2(0,-1))
		if move1.is_occupied() == false:
			valid_moves.append(move1)
			if get_coord().y == 6:
				var move2 = iboard.get_square(get_coord() + Vector2(0,-2))
				if move2.is_occupied() == false:
					valid_moves.append(move2)
		#pawn captures
		var spemoves : Array[square] = [iboard.get_square(get_coord() + Vector2(1,-1)), iboard.get_square(get_coord() + Vector2(-1,-1))]
		for move in spemoves:
			if move != null && move.is_occupied() && move.get_occupying_piece().is_enemy(self):
				valid_moves.append(move)
	else:
		var move1 = iboard.get_square(get_coord() + Vector2(0,1))
		if move1.is_occupied() == false:
			valid_moves.append(move1)
			if get_coord().y == 1:
				var move2 = iboard.get_square(get_coord() + Vector2(0,2))
				if move2.is_occupied() == false:
					valid_moves.append(move2)
		#pawn captures
		var spemoves : Array[square] = [iboard.get_square(get_coord() + Vector2(1,1)), iboard.get_square(get_coord() + Vector2(-1,1))]
		for move in spemoves:
			if move != null && move.is_occupied() && move.get_occupying_piece().is_enemy(self):
				valid_moves.append(move)
	return valid_moves
