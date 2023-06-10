extends Node3D

@export var p = preload("res://player.tscn")
@export var npc1 = preload("res://scenes/npc1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	pass
		



func _on_area_3d_body_entered(body):
	if body.is_in_group("players"):
		var npc12 = npc1.instantiate()
		$spawn.add_child(npc12)
		get_tree().paused = true
