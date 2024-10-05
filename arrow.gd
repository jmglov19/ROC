extends CharacterBody2D


const SPEED = 50000.0
var player




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	player = get_node("../../Player/Player")
	

	var direction = (player.position - self.position).normalized()
	
	if direction.x > 0:
			$".".scale.x =  scale.y * -1
			
	else:
		$".".scale.x =  scale.y * 1
	
	velocity.x = direction.x * SPEED * delta * -1
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	move_and_slide()


func _on_hitbox_area_entered(area):
	print("arrow hit")
	if area.name == "Hitbox":
		queue_free()
	
