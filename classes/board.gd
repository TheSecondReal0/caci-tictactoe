extends RefCounted

var dimensions: Vector2i = Vector2i(3, 3)

var board: Array[Array] = []

func initialize(_dimensions: Vector2i = dimensions) -> void:
	board.clear()
	
