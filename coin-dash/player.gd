extends Area2D
signal pickup
signal hurt
@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)

#variables for invincibility timer powerup coin
var is_invincible = false 
var invincibility_timer: Timer 

#dash variables 
var dash_speed = 600  # Speed during the dash
var dash_duration = 0.2  # Duration of the dash in seconds
var dash_cooldown = 1.0  # Cooldown between dashes in seconds
var can_dash = true  # Tracks if the player can dash
var is_dashing = false  # Tracks if the player is currently dashing



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	invincibility_timer = $InvincibilityTimer  # Get the Timer node
	invincibility_timer.one_shot = true
	invincibility_timer.connect("timeout", Callable(self, "_on_invincibility_timeout"))  # Connect the signal
	#is_invincible = true

	
	
func start_invincibility():
	is_invincible = true
	$CollisionShape2D.disabled = true  # Disable collisions
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 0.5)  # Optional visual feedback
	invincibility_timer.start(5)
	print("Invincibility started. is_invincible =", is_invincible)

	
func _on_invincibility_timeout() -> void:
	is_invincible = true
	$CollisionShape2D.disabled = false  # Re-enable collisions
	$AnimatedSprite2D.modulate = Color(1, 1, 1)  # Reset visual feedback
	print("Invincibility ended. is_invincible =", is_invincible)





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("left","right","up","down")
	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	if Input.is_action_just_pressed("dash"):
		start_dash()
	
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func start():
	set_process(true)
	position = screensize / 2 
	$AnimatedSprite2D.animation = "idle"
	
func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	elif area.is_in_group("powerup"):
		area.pickup()
		pickup.emit("powerup")
	elif area.is_in_group("invincibilityPowerup"):
		print("Invincibility power-up collected")
		area.pickup()
		start_invincibility()
	elif area.is_in_group("obstacles"):
		print("collected with obstacles. Invincible= ", is_invincible)
		if not is_invincible:  # Only hurt the player if they are not invincible
			hurt.emit()
			die()

		
func start_dash():
	is_dashing = true
	can_dash = false  # Prevent consecutive dashes
	
	# Determine dash direction based on current input
	var dash_direction = velocity.normalized()
	if dash_direction == Vector2.ZERO:  # Default to a direction if idle
		dash_direction = Vector2(1, 0)
	
	var dash_vector = dash_direction * dash_speed
	position += dash_vector * dash_duration

	# Reset after dash duration
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false

	# Start cooldown timer
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true



		
	


func _on_invincibility_timer_timeout() -> void:
	pass # Replace with function body.
