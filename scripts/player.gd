extends CharacterBody3D

@onready var armature = $character
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : AnimationNodeBlend2
@onready var hit = $Node/AnimationPlayer
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var timer = $Timer
@onready var jump = $AnimationTree/jumpTimer
@onready var aimcast : RayCast3D = $character/Armature/aimcast
@onready var punch = $punch_sound
@onready var enemy_time = $enemy_timer
@onready var running = $running
@onready var movement = $character/AnimationPlayer
@onready var die_timer = $character/die_timer

var SPEED = 4.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = .15
var seed = velocity.x / SPEED
var health = 100

var is_locked = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var damage = 25

func _process(delta):

	if Input.is_action_just_pressed("fire"):
		animation_tree.set("parameters/Transition/transition_request", "aim")
		punch.play()
		is_locked = true
		timer.start()
		if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("enemy"):
				target.health -= damage
				print("hit enemy")
				
				print(target.health)
		
	
	if Input.is_action_just_pressed("kick"):
		jump.start()
		animation_tree.set("active", false)
		movement.play("kick")
		punch.play()
		is_locked = true
		if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("enemy"):
				target.health -= 50
				print("hit enemy")
				
				print(target.health)

	if Input.is_action_just_pressed("open"):
		if aimcast.is_colliding():
			var doors = aimcast.get_collider()
			if doors.is_in_group("doors"):
				print("f")
				if doors.is_open == true:
					doors.close_door()
				else:
					doors.open_door()		
		

func dam():
	
	if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("enemy"):
				target.health -= damage
				print("hit enemy")
				
				print(target.health)
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if health <= 0:
		killed()
		
	
func _unhandled_input(event):
	#quick quit
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * .005)
		spring_arm.rotate_x(-event.relative.y * .005)
		spring_arm.rotation.x - clamp(spring_arm.rotation.x, -PI/4, PI/4)
			
func _physics_process(delta):
	
	#run movement
	var root_motion = animation_tree.get_root_motion_position()
	if Input.is_action_pressed("run"):
		SPEED = 10.0
		run()
		animation_tree.set("parameters/BlendSpace2D/blend_position", Vector2(2,0))
	else:
		SPEED = 4.0
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		animation_tree.set("active", false)
		jump.start()
		movement.play("jump")
		is_locked = false
		

	if health == 0:
		animation_tree.set("active", false)
		movement.play("killed")
		die_timer.start()
		$go.show()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	if direction:
		if SPEED <= 4.0:
			animation_tree.set("parameters/BlendSpace1D/blend_position", 1)
		else:
			animation_tree.set("parameters/BlendSpace1D/blend_position", 2)
		if !is_locked:
			velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
			velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
			armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		animation_tree.set("parameters/BlendSpace1D/blend_position", 0)
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
	
	if !is_locked:
		move_and_slide()
		
	
func killed():
	die_timer.start()
	print("dead")
	is_locked = true
	animation_tree.set("active", false)
	movement.play("killed")
	
	

func _on_timer_timeout():
	animation_tree.set("parameters/Transition/transition_request", "moving")
	punch.stop()
	is_locked = false

func _on_jump_timer_timeout():
	animation_tree.set("parameters/Blend2/blend_amount", 0.0)
	movement.stop()
	animation_tree.set("active", true)
	is_locked = false
	punch.stop()
	
func run():
	
	if SPEED > 4.0:
		running.autoplay = true
	else:
		running.stop()

func _on_die_timer_timeout():
	print("patay")
	$go.show()
	get_tree().paused = true
	


