extends Node2D

const dragging_pos:Vector2=Vector2(0,43+55)
const normal_pos:Vector2=Vector2(0,43)

const dragging_size:Vector2=Vector2(1.5,0.5)
const normal_size:Vector2=Vector2(1,0.5)

func _draw()->void:
	draw_circle(self.position,25.0,Color.black)
	return

func _process(_delta:float)->void:
	if(get_parent().is_dragging==true):
		self.position=dragging_pos
		self.scale=lerp(self.scale,dragging_size,0.5)
	else:
		self.position=normal_pos
		self.scale=lerp(self.scale,normal_size,0.5)
	return
