extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var timer := Timer.new()
var attack = false
var health = 15
var chase = false
var SPEED = 50
const JUMP_VELOCITY = -400.0
var player
var hurt = false
var player_in_area = false
var blocking = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")


func _ready():
	anim.play("Idle")
	
func _physics_process(delta):
	
	if player_in_area and !attack:
		var action = rng.randf()
		if action > 0.58:
			swing()
		else:
			block()	
	#print(anim.animation)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if chase == true:
		player = get_node("../../Player/Player")
	
	
		var distance = abs(player.position.x - self.position.x)
		#print(distance)
		var direction = (player.position - self.position).normalized()
		
		if direction.x > 0:
			$".".scale.x =  scale.y * 1
			
		else:
			$".".scale.x =  scale.y * -1
		if !hurt and !attack:
			if distance > 100:
				anim.play("Run")
				velocity.x = direction.x * SPEED * 3
			else:
				anim.play("Walk")
				velocity.x = direction.x * SPEED
	else:
		if !hurt and !attack:
			velocity.x = 0
			anim.play("Idle")
	
	move_and_slide()

func on_death():
	return

func _on_shield_area_entered(area):
	if area.name == "SwordHit" or area.name ==  "Arrow":
		blocking = true
		block()

func _on_hitbox_area_entered(area):
	if (area.name == "SwordHit" or area.name == "Arrow") and !blocking:
		print("Hit")
		health -= 4
		hurt = true
		if health > 0:
			anim.play("Hurt")
			velocity.x = 0
			await anim.animation_finished
			hurt = false
		else:
			print("Spearman Dead")
			anim.play("Dead")
			await anim.animation_finished
			self.queue_free()
		
	
func _on_swing_body_entered(body):
	if body.name == "Player" or body.name == "Arrow":
		print("Swing")
		player_in_area = true
		

func _on_swing_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		print("Run")
		

		
func swing():
	if !hurt:
		attack = true
		velocity.x = 0
		anim.play("Attack_1")
		await anim.animation_finished
		attack = false
		
func block():
	if !hurt:
		attack = true
		velocity.x = 0
		anim.play("Block")
		await anim.animation_finished
		attack = false
		blocking = false


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		print("Player Entered")


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false
		print("Player Exited")
