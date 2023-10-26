extends TextureButton
class_name CellNode

@export var label: Label

func set_token(token: Variant) -> void:
	# don't display anything if token is null
	if token == null:
		return
	
	label.text = str(token)
