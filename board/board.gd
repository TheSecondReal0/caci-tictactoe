extends Control
class_name BoardNode

@export var dimensions: Vector2i = Vector2i(3, 3)

@export_group("internal")
@export var row_container: Container
@export var row_scene: PackedScene
@export var cell_scene: PackedScene

var cell_nodes: Array[Array] = []

signal cell_pressed(row: int, col: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	create_board()

# called when a cell is pressed
func on_cell_pressed(row: int, col: int) -> void:
	print("cell pressed: ", row, " ", col)
	# emit the cell_pressed signal to notify any listeners
	cell_pressed.emit(row, col)

# display board data from a Board object
func display_board(board: Board) -> void:
	dimensions = board.dimensions
	# create nodes
	create_board(dimensions)
	
	# update cell tokens
	for row in dimensions.y:
		for col in dimensions.x:
			cell_nodes[row][col].set_token(board.get_cell(row, col))

# clears board nodes and array
func clear_board() -> void:
	for node in row_container.get_children():
		node.queue_free()
	# reset cell_nodes to an empty array
	cell_nodes.clear()

func create_board(_dimensions: Vector2i = dimensions) -> void:
	# make sure the board is clear before (re)building it
	clear_board()
	
	# create the amount of rows we need
	for row in _dimensions.y:
		create_row(row, _dimensions.x)
		# add a line between rows, but not after the last one
		if row < _dimensions.y - 1:
			var separator: HSeparator = HSeparator.new()
			row_container.add_child(separator)

# this function handles creation of a row, it will instance a container
# for each row and a button for each column
# it also attaches signals to call on_cell_pressed when a cell is clicked
func create_row(row: int, columns: int = dimensions.x) -> void:
	# create a new container to add cell nodes to
	var row_node: Container = row_scene.instantiate()
	var row_array: Array[Control] = []
	for col in columns:
		var cell: Control = instantiate_cell()
		# connect pressed signal so that on_cell_pressed() will be called
		# when a cell is clicked
		# bind(row, col) lets us keep track of the position of the cell that
		# was pressed without having to add complexity to the cell node
		cell.pressed.connect(on_cell_pressed.bind(row, col))
		# add it to row_array
		row_array.append(cell)
		row_node.add_child(cell)
		
		# add a line between columns, but not after the last one
		if col < columns - 1:
			var separator: VSeparator = VSeparator.new()
			row_node.add_child(separator)
	
	# add row_array to cell_nodes
	cell_nodes.append(row_array)
	row_container.add_child(row_node)

func instantiate_cell() -> Control:
	var cell: Control = cell_scene.instantiate()
	return cell
