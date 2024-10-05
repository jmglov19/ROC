extends CharacterBody2D

var health = 10
var hurt = false
var attacking = false
var dead = false
const SPEED = 400.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

var arrow_scence = preload("res://arrow.tscn")

func _ready():
	anim.play("Idle")

func _input(delta):
	
	if Input.is_action_just_pressed("Press_C"):
			if velocity.y == 0:
				velocity.x = 0
			attacking = true
			anim.play("Shoot")
			await anim.animation_finished
			attacking = false
			if velocity.y == 0:
				velocity.x = 0
			var arrow = arrow_scence.instantiate()
			get_parent().add_child(arrow)
			arrow.position = $Marker2D.global_position
			
			print(arrow.position)
			
	if Input.is_action_just_pressed("Press_F") == true and velocity.x == 0:
		#print("Attack_")
		attacking = true
		anim.play("Attack_2")
		await anim.animation_finished
		attacking = false
		#print("done")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		$".".scale.x =  scale.y * -1
		#get_node("AnimatedSprite2D").flip_h = true
	if direction == 1:
		$".".scale.x =  scale.y * 1
		#get_node("AnimatedSprite2D").flip_h = false
		
	if direction:
		
		if Input.is_action_just_pressed("Press_F"):
			if velocity.y == 0:
				direction = 0
				velocity.x = 0
			attacking = true
			anim.play("Run Attack")
			await anim.animation_finished
			attacking = false
		
		if Input.is_action_just_pressed("Press_C"):
			if velocity.y == 0:
				velocity.x = 0
			attacking = true
			anim.play("Shoot")
			await anim.animation_finished
			print("Arrow")
			var arrow = arrow_scence.instantiate()
			get_parent().add_child(arrow)
			arrow.position = $Marker2D.global_position
			
			print(arrow.position)
		
			
		
		if velocity.y == 0 and !attacking and !hurt:
			if Input.is_action_pressed("Shift"):
				velocity.x = direction * (SPEED)
				anim.play("Run")
				
			else:
				
				velocity.x = direction * (SPEED/2)
				anim.play("Walk")
		
		#if velocity.y < 0:
			#anim.play("Jump")
	
		
	else:
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 and !attacking and !hurt: 
			anim.play("Idle")
		
		if velocity.y > 0:
			anim.play("Fall")
		
	

		

	move_and_slide()



func _on_hitbox_area_entered(area):
	print(area.name)
	if area.name == "Hurtbox" and !dead: 
		print("Hurt")
		hurt = true
		health -= 2
		if health <= 0:
			dead = true
			anim.play("Death")
			await anim.animation_finished
			queue_free()
			get_tree().change_scene_to_file("res://main.tscn")
		else:	
			anim.play("Hurt")
			await anim.animation_finished
			hurt = false
		
	



	
