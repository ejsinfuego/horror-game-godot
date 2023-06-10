extends Node3D

@onready var game = preload("res://scenes/main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	var play = game.instantiate()
	$main.add_child(play)
	$ITblend.queue_free()
	$menu.hide()
	$menu/bg.stop()
