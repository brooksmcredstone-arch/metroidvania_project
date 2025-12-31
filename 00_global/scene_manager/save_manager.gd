#Save_Manager Script
extends Node

var current_slot : int = 0
var save_data : Dictionary
var discovered_areas : Array = []
var persistent_data : Dictionary = {}

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent)-> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P:
			save_game()
		elif event.keycode == KEY_O:
			load_game()
	pass

func create_new_game_save() -> void:
	var new_game_scene: String = "uid://545uvo36q808"
	discovered_areas.append(new_game_scene)
	save_data = {
		"scene path" : new_game_scene,
		"x" : 37,
		"y" : 232,
		"hp" : 20,
		"max_hp" : 20,
		"mp" : 20,
		"max_mp" : 20,
		"dash" : false,
		"double_jump" : false,
		"ground_pound" : false,
		"floatation" : false,
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
	}
	## Save Data
	var save_file = FileAccess.open("user://save.sav", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	pass


func save_game() -> void:
	print("game saved")
	var player : Player = get_tree().get_first_node_in_group("Player")
	save_data = {
		"scene_path" : SceneManager.current_scene_uid,
		"x" : player.global_position.x,
		"y" : player.global_position.y,
		"hp" : player.hp,
		"max_hp" : player.max_hp,
		"mp" : player.mp,
		"max_mp" : player.max_mp,
		"lvl" : player.lvl,
		"experience" : player.experience,
		"dash" : player.dash,
		"double_jump" : player.double_jump,
		"ground_pound" : player.ground_pound,
		"floatation" : player.floatation,
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
	}
	## Save Data
	var save_file = FileAccess.open("user://save.sav", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	pass


func load_game() -> void:
	print("game loaded")
	
	if not FileAccess.file_exists("user://save.sav"):
		return
	
	var save_file = FileAccess.open("user://save.sav", FileAccess.READ)
	save_data = JSON.parse_string(save_file.get_line() )
	
	persistent_data = save_data.get("persistent_data", {} )
	discovered_areas = save_data.get("discovered_areas", []  )
	var scene_path : String = save_data.get("scene_path", "uid://545uvo36q808")
	SceneManager.transition_to_scene(scene_path, "", Vector2.ZERO, "up")
	setup_player()
	pass

func setup_player() -> void:
	var player : Player = null
	while not player:
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().process_frame
	
	player.max_hp = save_data.get("max_hp", 20)
	player.hp = save_data.get("hp", 20)
	player.max_mp = save_data.get("max-mp", 20)
	player.mp = save_data.get("mp", 20)
	player.lvl = save_data.get("lvl", 1)
	player.experience = save_data.get("experience", 0)
	player.dash = save_data.get("dash", false)
	player.double_jump = save_data.get("double_jump", false)
	player.floatation = save_data.get("floatation", false)
	
	player.global_position = Vector2(save_data.get("x", 0), save_data.get("y", 0) )
	pass
