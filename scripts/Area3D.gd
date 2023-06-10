extends Node3D

@onready var player = $np1/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Node3D.is_locked = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_end_timeout():
	queue_free()
