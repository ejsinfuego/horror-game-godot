extends CanvasLayer

@onready var anim = $CanvasLayer/AnimationPlayer

func _on_line_edit_text_submitted(new_text):
	if new_text == "parsu":
		$CanvasLayer.show()
		$lineEdit/indicator.text = "password accepted"
		$lineEdit.visible = false
		$CanvasLayer/AnimationPlayer.play("finals")
	else:
		$lineEdit/indicator.text = "password incorrect, try again"
		


func _on_line_edit_text_changed(new_text):
	$lineEdit/indicator.text = ""
	
func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("return"):
		queue_free()
