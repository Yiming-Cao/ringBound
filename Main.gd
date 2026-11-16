extends Control

var home_page: CenterContainer
var game_page: CenterContainer

func _ready() -> void:
	home_page = _new_page()
	game_page = _new_page()

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 16)
	var home_content := _new_content(home_page)
	_add_label(home_content, "RING-BOUND", 32)
	_add_button(home_content, "Start", Callable(self, "_show_game"))

	var game_content := _new_content(game_page)
	_add_label(game_content, "Prototype", 28)
	_add_label(game_content, "Add your game here.")
	_add_button(game_content, "Back", Callable(self, "_show_home"))

	_show_home()

func _new_page() -> CenterContainer:
	var page := CenterContainer.new()
	page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(page)
	return page

func _new_content(page: CenterContainer) -> VBoxContainer:
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	content.custom_minimum_size.x = 320
	page.add_child(content)
	return content

func _add_label(content: VBoxContainer, text: String, size: int = 20) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", size)
	content.add_child(label)

func _add_button(content: VBoxContainer, text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(action)
	content.add_child(button)

func _show_home() -> void:
	home_page.visible = true
	game_page.visible = false

func _show_game() -> void:
	home_page.visible = false
	game_page.visible = true
