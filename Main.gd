extends Control

var enemy_health: int = 30
var player_health: int = 30
var selected_ring: String = "Fire"

var home_page: Control
var encounter_page: Control
var player_health_label: Label
var enemy_health_label: Label
var selection_label: Label
var result_label: Label
var cast_button: Button

func _ready() -> void:
	_build_home_page()
	_build_encounter_page()
	_show_home()

func _build_home_page() -> void:
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	home_page = center

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 16)
	content.custom_minimum_size.x = 420
	center.add_child(content)

	var title := Label.new()
	title.text = "RING-BOUND"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 42)
	content.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "A small prototype"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(subtitle)

	var start_button := Button.new()
	start_button.text = "Start encounter"
	start_button.custom_minimum_size.y = 48
	start_button.pressed.connect(_start_encounter)
	content.add_child(start_button)

func _build_encounter_page() -> void:
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	encounter_page = center

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	content.custom_minimum_size.x = 520
	center.add_child(content)

	var title := Label.new()
	title.text = "First Encounter"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	content.add_child(title)

	player_health_label = Label.new()
	player_health_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(player_health_label)

	enemy_health_label = Label.new()
	enemy_health_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(enemy_health_label)

	var ring_title := Label.new()
	ring_title.text = "Choose a ring"
	ring_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(ring_title)

	var ring_buttons := HBoxContainer.new()
	ring_buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	ring_buttons.add_theme_constant_override("separation", 8)
	content.add_child(ring_buttons)
	_add_ring_button(ring_buttons, "Fire")
	_add_ring_button(ring_buttons, "Wind")
	_add_ring_button(ring_buttons, "Ice")

	selection_label = Label.new()
	selection_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(selection_label)

	cast_button = Button.new()
	cast_button.text = "Cast spell"
	cast_button.custom_minimum_size.y = 44
	cast_button.pressed.connect(_cast_spell)
	content.add_child(cast_button)

	result_label = Label.new()
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(result_label)

	var home_button := Button.new()
	home_button.text = "Back to home"
	home_button.pressed.connect(_show_home)
	content.add_child(home_button)

func _add_ring_button(parent: HBoxContainer, ring_name: String) -> void:
	var button := Button.new()
	button.text = ring_name
	button.custom_minimum_size = Vector2(110, 42)
	button.pressed.connect(_select_ring.bind(ring_name))
	parent.add_child(button)

func _start_encounter() -> void:
	enemy_health = 30
	player_health = 30
	selected_ring = "Fire"
	result_label.text = "Select a ring, then cast a spell."
	cast_button.disabled = false
	_update_hud()
	_show_encounter()

func _select_ring(ring_name: String) -> void:
	selected_ring = ring_name
	_update_hud()

func _cast_spell() -> void:
	if enemy_health <= 0 or player_health <= 0:
		return

	var damage := 10
	if selected_ring == "Fire":
		damage = 12
	elif selected_ring == "Ice":
		damage = 8

	enemy_health = maxi(0, enemy_health - damage)
	if enemy_health == 0:
		result_label.text = "%s spell deals %d damage. You win!" % [selected_ring, damage]
		cast_button.disabled = true
	else:
		player_health = maxi(0, player_health - 5)
		if player_health == 0:
			result_label.text = "%s spell deals %d damage. The enemy defeats you." % [selected_ring, damage]
			cast_button.disabled = true
		else:
			result_label.text = "%s spell deals %d damage. The enemy hits back for 5." % [selected_ring, damage]
	_update_hud()

func _update_hud() -> void:
	player_health_label.text = "Player health: %d / 30" % player_health
	enemy_health_label.text = "Training dummy health: %d / 30" % enemy_health
	selection_label.text = "Selected ring: %s" % selected_ring

func _show_home() -> void:
	if home_page != null:
		home_page.visible = true
	if encounter_page != null:
		encounter_page.visible = false

func _show_encounter() -> void:
	home_page.visible = false
	encounter_page.visible = true
