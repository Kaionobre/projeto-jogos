extends Area2D

@export var speed = 400
var screen_size

signal hit
signal power_up
signal bomb


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1	
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	position += velocity * speed * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	var flipHorizontal = velocity.x < 0
	var flipVertical = velocity.y > 0
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = flipHorizontal
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = flipVertical
		
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		hit.emit()
	if body.is_in_group("power_up"):
		body.hide()
		var collision_shape = body.get_node("CollisionShape2D")
		if collision_shape:
			collision_shape.set_deferred("disabled", true)
		power_up.emit()
	if body.is_in_group("bomb"):
		body.hide()
		var collision_shape = body.get_node("CollisionShape2D")
		if collision_shape:
			collision_shape.set_deferred("disabled", true)
		bomb.emit()
		
