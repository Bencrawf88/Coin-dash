extends Area2D

var screensize = Vector2.ZERO


func _on_area_entered(area):
	if area.is_in_group("Player"):
		position = Vector2(randi_range(0, screensize.x-23), randi_range(0, screensize.y-30))
