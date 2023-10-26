extends Control

# dimensions of the tictactoe board
@export var dimensions: Vector2i = Vector2i(3, 3)
# one token for each player (player 0's token is at idx 0, 
# 	player 1's token at idx 1, etc.)
# size of this array is the amount of players in the game
@export var tokens: Array[Variant] = ["X", "O"]

@export_group("internal")
@export var title: Label
@export var board_container: AspectRatioContainer
@export var board_node: BoardNode
@export var reset_button: Button

var board: Board

# keep track of who's turn it is
var current_player: int = 0

# called when the node enters the scene tree for the first time.
func _ready() -> void:
	# listen for when a cell is clicked
	board_node.cell_pressed.connect(on_cell_pressed)
	# listen for when the reset button is pressed
	reset_button.pressed.connect(on_reset_pressed)
	
	# set up the game
	setup()

func on_cell_pressed(row: int, col: int) -> void:
	# make sure there's not already a token on this cell
	if board.get_cell(row, col) != null:
		return
	# make sure there isn't already a win condition on the board
	if board.check_win_conditions() != null:
		return
	# make sure the game isn't a draw
	if board.check_draw():
		return
	
	# update cell
	board.set_cell(row, col, get_current_player_token())
	# update board
	board_node.display_board(board)
	
	# check win conditions
	var victory_token: Variant = board.check_win_conditions()
	# if victory_token is not null, a player has won
	if victory_token != null:
		display_victory(victory_token)
		return
	
	# if there's a draw, update UI accordingly
	if board.check_draw():
		display_draw()
		return
	
	# otherwise advance to the next player's turn
	advance_turn()

func on_reset_pressed() -> void:
	setup()

# creates a new Board object, updates UI, resets current player to zero
func setup() -> void:
	board = Board.new()
	board.initialize(dimensions)
	
	board_node.display_board(board)
	
	# update board aspect ratio to match dimensions
	# avoids stretched look/non square cells
	board_container.ratio = dimensions.aspect()
	
	current_player = 0
	update_turn_text()
	
	reset_button.text = "Reset"

func display_victory(token: Variant) -> void:
	title.text = "Player {0} wins!".format([token]) 
	reset_button.text = "Play again?"

func display_draw() -> void:
	title.text = "Draw!"
	reset_button.text = "Play again?"

# advances to the next player's turn and updates UI text as needed
func advance_turn() -> void:
	current_player = (current_player + 1) % tokens.size()
	update_turn_text()

func update_turn_text() -> void:
	var token: Variant = get_current_player_token()
	title.text = "Your turn, player {0}".format([token]) 

# returns the token belonging to the player who's turn it is
func get_current_player_token() -> Variant:
	return tokens[current_player]
