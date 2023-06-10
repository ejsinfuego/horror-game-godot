extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var armature = $Armature
@onready var anim_tree = $AnimationTree
@onready var shootTimer = $AnimationPlayer/shootTimer
@onready var raycast = $Armature/RayCast3D
@onready var timer =  $dead_timer
@onready var hitbox = $Armature/Area3D2/hitbox
@onready var hits : AnimationPlayer = $TextureRect/hit
@onready var state_machine : AnimationNodeStateMachinePlayback = anim_tree["parameters/StateMachine/playback"]
@export var blood_screen = preload("res://hit.tscn")
@onready var zombie_attack = $zombie_attack
@onready var killed_anim = $killed_anim
@onready var blood = $Armature/blood/blood_player
@onready var hit = $hit/AnimationPlayer

var SPEED = 0.8
var LERP_VAL = .15
var health: float = 100
var damage = 50

func _physics_process(delta):
	if health > 0:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		nav_agent.set_velocity(new_velocity)
		
		var direction = (transform.basis * Vector3(new_velocity.x, 0, new_velocity.y)).normalized()
		direction = direction.rotated(Vector3.UP, armature.rotation.y)
		if direction:
			velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
			velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
			armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
		else:
			velocity.x = lerp(velocity.x, 0.0 * SPEED, LERP_VAL)
			velocity.z = lerp(velocity.z, 0.0 * SPEED, LERP_VAL)
			
		anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() /SPEED)
		move_and_slide()
	else:
		timer.start()

func update_target_location(target_location):
	if health > 0:
		nav_agent.set_target_position(target_location)
	else:
		var current_location = global_transform.origin
		nav_agent.set_velocity(current_location)
		nav_agent.navigation_finished

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .20)


func _on_area_3d_2_body_entered(body):
		var b = blood_screen.instantiate()
		if body.is_in_group("players"):
			shootTimer.start()
			anim_tree.set("parameters/Transition/transition_request", "attacking")
			zombie_attack.play()
			blood.play("blood_emit")
			anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() /SPEED)
		else:
			if shootTimer.is_stopped():
				print("stop")
				pass
			else:
				print("still playing")
				shootTimer.stop()
			anim_tree.set("parameters/Transition/transition_request", "walking")
				

#	if $Area3D2/CollisionShape3D.is_colliding():
#			var collision = $Area3D2.get_collider()
#			if collision.is_in_group("player") && collision.damage > health:
#				anim_tree.set("parameters/Blend2/blend_amount", 1)
	

func _on_area_3d_2_body_exited(body):
	if health <= 0:
		queue_free()
	else:
		if body.is_in_group("players"):
			anim_tree.set("parameters/Transition/transition_request", "walking")
			anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() /SPEED)
			zombie_attack.stop()
			if shootTimer.is_stopped():
				print("stop")
				pass
			else:
				print("still playing")
				shootTimer.stop()
			anim_tree.set("parameters/Transition/transition_request", "walking")

		
func _process(delta):
	if health <= 0:
		anim_tree.set("parameters/Transition/transition_request", "killed")
		shootTimer.stop()
		zombie_attack.stop()
		
func _on_timer_timeout():
	queue_free()
	print("dead")

func _on_shoot_timer_timeout():
	if raycast.is_colliding():
		var target = raycast.get_collider()
		if target.is_in_group("players"):
			if target.health >= 0 :
				target.health -= damage
			else:
				target.health -= 0
			print(target.health)
			hit.play("hit")
	print("hit")

	

