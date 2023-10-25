extends Control

@export var dimensions: Vector2i = Vector2i(3, 3)

@export_group("internal")
@export var row_container: Container
@export var cell_scene: PackedScene

var cell_nodes: Array[Array]

# Called when the node enters the scene tree for the first time.
func _ready():
	create_board()

func on_cell_pressed(row: int, col: int) -> void:
	print("cell pressed: ", row, " ", col)

func create_board(_dimensions: Vector2i = dimensions) -> void:
	for row in _dimensions.y:
		create_row(row, _dimensions.x)

# this function handles creation of a row, it will instance a container
# for each row and a button for each column
# it also attaches signals to call on_cell_pressed when a cell is clicked
func create_row(row: int, columns: int = dimensions.x) -> void:
	# create a new container to add cell nodes to
	var row_node: Container = HBoxContainer.new()
	for col in columns:
		var cell: Control = instantiate_cell()
		cell.pressed.connect(on_cell_pressed.bind(row, col))
		row_node.add_child(cell)
	row_container.add_child(row_node)

func instantiate_cell() -> Control:
	var cell: Control = cell_scene.instantiate()
	return cell
