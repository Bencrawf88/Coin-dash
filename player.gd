extends Area2D
signal pickup
signal hurt

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2 (480,720)

func _ready():
	pass # Replace with function body. 

func start ():
	set_process(true)
	position = screensize/2
	$AnimatedSprite2D.animation = "idle"
	
func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)
	
func _process (delta):
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "3"
	else:
		$AnimatedSprite2D.animation = "idle"
	if velocity.x !=0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	position.x = clamp(position.x, $CollisionShape2D.shape.size.x/2.0, screensize.x-$CollisionShape2D.shape.size.x/2.0)
	position.y = clamp(position.y, $CollisionShape2D.shape.size.y , screensize.y)

	
	
	
# Called when the node enters the scene tree for the first time.


func _on_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
	if area.is_in_group("bound"):
		position = position - velocity
	pass # Replace with function body.
