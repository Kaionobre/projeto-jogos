extends RigidBody2D

var speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var fly_speed = 130.0
	var swim_speed = 200.0
	var walk_speed = 130.0

	
	# Obtem um array com os nomes das animações ["walk", "swim", "fly"]
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
   	# Inicia a animação definida aleatoriamente entre os índices 0 e 2 
	var random_animation_index = randi() % mob_types.size()
	var random_animation = mob_types[random_animation_index]
	
	if (random_animation == "walk"):
		speed = walk_speed
	elif (random_animation == "swim"):
		speed = swim_speed
	elif (random_animation == "fly"):
		speed = fly_speed
		
	$AnimatedSprite2D.play(random_animation)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
