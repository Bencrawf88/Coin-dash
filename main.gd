extends Node

@export var coin_scene : PackedScene
@export var powerup_scene: PackedScene
@export var obstacles_scene: PackedScene
@export var playtime = 30

var level = 1 
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false
var obstacles = []

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
	

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	spawn_obstacles()
	$HUD.update_score(score)
	$HUD.update_time(time_left)
	$PowerupTimer.wait_time = randi_range(1,5)
	$PowerupTimer.start()
	
func spawn_obstacles():
	for i in range(1+(level/3)): #[0,1,2]
		var obstacle = obstacles_scene.instantiate()
		add_child(obstacle)
		obstacle.screensize = screensize
		obstacle.position = Vector2 (randi_range (23, screensize.x-23), randi_range(23, screensize.y-30))
		obstacles.append(obstacle)
	
func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2 (randi_range (50, screensize.x-50), randi_range(50, screensize.y-50))
	$LevelSound.play()

func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		for obstacle in obstacles: 
			print(obstacle)
			obstacle.queue_free()
		obstacles = []
		spawn_coins ()
		spawn_obstacles()
		$PowerupTimer.wait_time = randi_range(1,5)
		$PowerupTimer.start()

func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_time(time_left)
	if time_left <=0:
		game_over()
		


func _on_player_hurt():
	$Player.die()
	game_over() 


func _on_player_pickup(type):
	match type:
		"coin":
			score += 1
			$HUD.update_score(score)
			$CoinSound.play()
		"powerup":
			$PowerupSound.play()
			$Player.speed = 600
			$Timer.start()

			#time_left += 5
			#$HUD.update_time(time_left)

func game_over():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	for obstacle in obstacles: 
		print(obstacle)
		obstacle.queue_free()
	obstacles = []
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play() 
	await $HUD/Timer.timeout
	$Player.hide ()


func _on_hud_start_game():
	new_game()


func _on_powerup_timer_timeout():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(50, screensize.x-50), randi_range(50, screensize.y-50))


func _on_timer_timeout():
	$Player.speed = 350
	
	
