extends Node3D

@onready var door = $door
# Called when the node enters the scene tree for the first time.

@onready var doorOpen = $AnimationPlayer
@onready var door_sound = $door_sound
var is_open = false

var enemies = []
var i : int = 0
func _input(event):
	pass
	
func _ready():
	pass
#	pass # This function is called when the node is added to the scene and ready to be used
	
#func _on_InteractZone_input_event(viewport, event, shape_idx):
#	# This function is called when the player interacts with the object
#	if event is InputEventMouseButton and event.pressed:
#		if !is_open:
#			open_door()
#		else:
#			close_door()
func open_door():
	# This function opens the door by rotating it 90 degrees around the Y-axis
	is_open = true
	doorOpen.play("door_open")
	door_sound.play()
	

func close_door():
	# This function closes the door by rotating it back to its original position
	is_open = false
	doorOpen.play("close")
	door_sound.play()




func _on_area_3d_body_entered(body):
	if body.is_in_group("players"):
		if is_open == true:
			close_door()
		else:
			open_door()
		


func _on_area_3d_body_exited(body):
	if body.is_in_group("players"):
		if is_open == true:
			close_door()
		else:
			open_door()
		


func _on_timer_timeout():
	
	i += 1
	print(i)
	if i == 5:
		$Timer.stop()
	else:
		pass

		
	
		
