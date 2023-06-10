extends Node3D

@export var enemy = preload("res://zombie.tscn")
@export var p = preload("res://player.tscn")
@export var npc1_scene = preload("res://scenes/npc1.tscn")
@export var npc2_scene = preload("res://scenes/npc2.tscn")
@export var finale = preload("res://scenes/final.tscn")

@export var main_menu = preload("res://main_menu.tscn")

@onready var pause = $environment/Pause
@onready var timer = $environment/Timer
@onready var game_over = $environment/game_over
@onready var playerspawn = $environment/Characters/playerspawn
@onready var main_cam = $environment/main_cam
@onready var menu = $environment/menu
@onready var player = $environment/Node3D/player
@onready var intro_timer = $environment/intro
@onready var intro = $environtment/intro/introduction/Intro/AnimationPlayer
@onready var introduction = $environment/intro/introduction

var e = enemy.instantiate()
var paused = false
var playing = false
var i : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#	var spawns = [$enemy_spawn1.global_transform.origin, $enemy_spawn2.global_transform.origin, $enemy_spawn3.global_transform.origin]
#	var spawn_location = spawns[randi() % spawns.size()]
#	print(spawn_location)
#	e.position = spawn_location
#	var final_location = spawns[2]
	get_tree().paused = true
	$environment.visible = false
	playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("end"):
		queue_free()
	
	
#	if enemies.size() >= 5:
#		timer.stop()
#	else:
#		timer.start()
#	if player1.health <= 0:
#		game_over.show()
	
	
	
		
func _physics_process(delta):
	if playing == false:
		pass
	else:
		get_tree().call_group("enemy", "update_target_location", player.global_transform.origin)
	
	
	if get_tree().paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
func _on_timer_timeout():
	randomize()
	
	var spawns = [$enemy_spawn1.global_transform.origin, $enemy_spawn2.global_transform.origin, $enemy_spawn3.global_transform.origin]
	var spawn_location = spawns[randi() % spawns.size()]
	var e = enemy.instantiate()
	e.position = spawn_location
	var final_location = spawns[2]
	add_child(e)
	i += 1
	if i == 5:
		timer.stop()
	else:
		pass



func _on_button_pressed():
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu.hide()
	$main_cam.clear_current()
	$intro/introduction.show()
	intro_timer.start()
	$intro/introduction/Intro.show()
	intro.play("intro")
	end_intro()
#	var player = p.instantiate()
#	playerspawn.add_child(player)
	

#TIMER TO ENT THE INTRO
func _on_intro_timeout():
	
	end_intro()

#WILL SHOW THE INTRO
func end_intro():
	
	if $intro/introduction/Intro.visible == true :
		pass
	else:
		playing = true
		get_tree().paused = false
		$intro/introduction/Intro.hide()
		$main_cam.clear_current()
		intro_timer.stop()
		$intro/introduction/Camera3D.clear_current()
		
func _input(event):
	
	
#	if event.is_action_pressed("pause"):
#		if $menu.visible == true or $intro/introduction/Intro.visible == true:
#
#			if get_tree().paused == false:
#				playing = false
#				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#				$pause.show()
#				get_tree().paused = true
#			else:
#				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#				get_tree().paused = false
#				$pause.hide()
				
#	if event.is_action_pressed("pause") != true:
#		process_mode = Node.PROCESS_MODE_PAUSABLE
#
#		var current_state = get_tree().paused
#		if current_state == true:
#			playing = true
#			$pause.hide()
#			get_tree().paused = !current_state
#		else:
#			$pause.show()
#			get_tree().paused = true
#			playing = false
	pass
func _unhandled_input(event):
	
	#button for play in main menu
	if event.is_action_pressed("play") and menu.visible == true :
		menu.hide()
		$main_cam.clear_current()
		$intro/introduction.show()
		intro_timer.start()
		$intro/introduction/Intro.show()
		intro.play("intro")
		end_intro()
			
	if event.is_action_pressed("tab"):
		$environment/hint.show()
	
	if event.is_action_released("tab"):
		$environment/hint.hide()
	
	if event.is_action_pressed("credit") and menu.visible == true :
		process_mode = Node.PROCESS_MODE_PAUSABLE
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$environment/credits.show()

	
func _on_npc_1_detetctor_body_entered(body):
	if body.is_in_group("players"):
		var npc = npc1_scene.instantiate()
		player.is_locked = true
		$environment/npcs.add_child(npc)
		print("entered")
		
func _on_button_4_pressed():
	get_tree().quit()
		
##FIX PAUSED // UMIIKOT LANG ANG ZOMBIES

func _on_npc_2_detetctor_2_body_entered(body):
	if body.is_in_group("players"):
		var npc = npc2_scene.instantiate()
		player.is_locked = true
		$environment/npcs.add_child(npc)
		print("entered")


func _on_resume_pressed():
	if get_tree().paused == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Pause.show()
		get_tree().paused = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().paused = false
		$Pause.hide()
		
func _on_final_2_body_entered(body):
	if body.is_in_group("players"):
		var finals = finale.instantiate()
		$environment/final.add_child(finals)
		print("entered")


func _on_exit_pressed():
	var mmenu = main_menu.instantiate()
	$menuu.add_child(mmenu)
	get_tree().reload_current_scene()
	playing = false
	
	
	
	

func _on_go_body_entered(body):
	if body.is_in_group("players"):
		$game_over.show()

func _on_g_restart_pressed():
	$Pause.hide()
	$game_over.hide()
	get_tree().reload_current_scene()
	
func _on_restart_pressed():
	var mmenu = main_menu.instantiate()
	$menuu.add_child(mmenu)
	$Pause.hide()
	queue_free()
	
func _on_g_exit_pressed():
	$Pause.hide()
	get_tree().quit()

func _on_back_credits_pressed():
	get_tree().reload_current_scene()

func _on_button_2_pressed():
	get_tree().reload_current_scene()

func _on_npc_timer_timeout():
	$player.is_locked = false
