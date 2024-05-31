extends piece_model

class_name pawn_model

func _init(icolor: bool, iboard: board_model, start_square: square_model):
	super._init(icolor, iboard, start_square)
	self.sprite = preload("res://Chess_plt45.svg")

func get_valid_moves() -> Array[square_model]:
	var valid_moves : Array[square_model]
	if color == true:
		var move1 = myboard.get_square(get_coord() + Vector2(0,-1))
		if not move1.is_occupied():
			valid_moves.append(move1)
			if get_coord().y == 6:
				var move2 = myboard.get_square(get_coord() + Vector2(0,-2))
				if not move2.is_occupied():
					valid_moves.append(move2)
		#capture
		var spemoves : Array[square_model] = [myboard.get_square(get_coord() + Vector2(1,-1)), myboard.get_square(get_coord() + Vector2(-1,-1))]
		for move in spemoves:
			if move != null && move.is_occupied() && move.get_occupying_piece().is_enemy(self):
				valid_moves.append(move)
		return valid_moves
	else:
		var move1 = myboard.get_square(get_coord() + Vector2(0,1))
		if not move1.is_occupied():
			valid_moves.append(move1)
			if get_coord().y == 1:
				var move2 = myboard.get_square(get_coord() + Vector2(0,2))
				if not move2.is_occupied():
					valid_moves.append(move2)
		#capture
		var spemoves : Array[square_model] = [myboard.get_square(get_coord() + Vector2(1,1)), myboard.get_square(get_coord() + Vector2(-1,1))]
		for move in spemoves:
			if move != null && move.is_occupied() && move.get_occupying_piece().is_enemy(self):
				valid_moves.append(move)
		return valid_moves
