extends piece_model

class_name king_model

func get_valid_moves() -> Array[square_model]:
	var valid_moves : Array[square_model]
	const moves_list = [Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]
	for vector in moves_list:
		var new_move = myboard.get_square(get_coord() + vector)
		if new_move != null :
			valid_moves.append(new_move)
			if new_move.is_occupied():
				if new_move.get_occupying_piece().is_enemy(self) == false:
					valid_moves.pop_back()
	return valid_moves

func get_out_of_check_moves() -> Array[square_model]:
	var valid_moves = get_valid_moves()
	for move in valid_moves:
		for enemy in myboard.get_enemy_pieces(self):
			if move in enemy.get_valid_moves():
				var move_id = valid_moves.find(move)
				valid_moves.pop_at(move_id)
				#go to the next move
				break
	#the first part of the code computes moves that would get you out of the current check state
	#but it doesnt guarantee that on the next turn you will still be out of check
	#in order to make sure the king won't be in check right after, we need to run a similuation
	
	for move in valid_moves:
		var new_move = move_command.new(myboard, self, move)
		var inCheck = func():
			return myboard.in_check(get_color())
			
		if new_move.try(inCheck):
			#this code will return true if the king is still in check after it moves on this square
			var move_id = valid_moves.find(move)
			valid_moves.pop_at(move_id)
		
	return valid_moves
