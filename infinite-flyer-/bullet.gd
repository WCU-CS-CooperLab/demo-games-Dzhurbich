extends Area3D

@export var bullet_scene: PackedScene


@export var speed: float = 50.0  # Speed of the bullet
var direction: Vector3 = Vector3.ZERO  # Direction the bullet moves in

func _ready():
	var test_bullet = preload("res://bullet.tscn").instance()
	test_bullet.global_transform = global_transform
	get_parent().add_child(test_bullet)

func _process(delta):
	# Move the bullet forward in the set direction
	global_transform.origin += direction * speed * delta

	# Optional: Remove the bullet if it travels too far from the origin
	if global_transform.origin.length() > 1000:
		queue_free()

func _on_body_entered(body):
	# Handle collisions
	if body.has_method("take_damage"):
		body.take_damage(10)  # Example damage value
	queue_free()  # Destroy the bullet after a collision

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
