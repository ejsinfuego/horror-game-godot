extends Node3D
@onready var node = $Intro

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	
	if event.is_action_pressed("jump"):
		node.hide()
		$Camera3D.clear_current()
