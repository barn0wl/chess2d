extends Node

func _ready():
	var myBoardModel = board_model.new()
	var board_view_sample : PackedScene = preload('res://board/board_view.tscn')
	var myBoardView = board_view_sample.instantiate()
	var myBoard = board_controller.new(myBoardModel, myBoardView)
	add_child(myBoard)

	print(myBoard.current_player)
