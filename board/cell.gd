extends TextureButton

@export var label: Label

func set_token(token: Variant) -> void:
	label.text = str(token)
