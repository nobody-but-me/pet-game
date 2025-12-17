
extends KinematicBody2D

export var DEBUGGING:bool=true

onready var choose_timer:Timer=$"choose-timer"
onready var sprite:Sprite=$Sprite2D

enum States{
	Dragging,
	
	Sleeping,
	Walking,
	Eating,
	Idling,
}
var current_state=States.Walking setget set_state
var is_dragging:bool=false

#var velocity:Vector2=Vector2(0.0,0.0)

# TODO: find a better name for this variable; for now I don't really have a better idea for it
var tmp:float=100.0

func set_state(new_state)->void:
	var _previous_state=current_state
	current_state=new_state
	match(current_state):
		States.Dragging:
			pass
		States.Sleeping:
			pass
		States.Walking:
			pass
		States.Eating:
			pass
		States.Idling:
			pass
	return

func _physics_process(_delta:float)->void:
	if(current_state==States.Walking):
		pass
	return

func _input(_event:InputEvent)->void:
	if(_event is InputEventMouseButton):
		if(!_event.pressed && _event.button_index==BUTTON_LEFT):
			is_dragging=false
# NOTE: that's bad
			current_state=States.Idling
		else:
			var pos=_event.position
			var spr_size=Vector2(sprite.scale.x*tmp,sprite.scale.y*tmp)
# adjusted position so the pet is held by its center
			var spr_pos=Vector2(self.global_position.x-(spr_size.x/2),self.global_position.y-(spr_size.y/2))
# conditional to check whether the touch was inside the pet; it's being checked here instead in the InputEventScreenDrag conditional
#	because then, when the pet is being already held, it won't be 'dropped' if the fingers gets out of its bounds during the movement
			if((pos.x>spr_pos.x&&pos.x<spr_pos.x+spr_size.y)&&(pos.y>spr_pos.y&&pos.y<spr_pos.y+spr_size.y)):
				is_dragging=true
	elif(_event is InputEventMouseMotion):
		var pos=_event.position
		
		if(DEBUGGING):
# for debugging
			var spr_size=Vector2(sprite.scale.x*tmp,sprite.scale.y*tmp)
			var spr_pos=Vector2(self.global_position.x-(spr_size.x/2),self.global_position.y-(spr_size.y/2))
			if((pos.x>spr_pos.x&&pos.x<spr_pos.x+spr_size.y)&&(pos.y>spr_pos.y&&pos.y<spr_pos.y+spr_size.y)):
				Input.set_default_cursor_shape(Input.CURSOR_DRAG)
				sprite.modulate=Color.red
			else:
				Input.set_default_cursor_shape(Input.CURSOR_ARROW)
				sprite.modulate=Color.white
		
		if(is_dragging):
# updating the actual pet position
			self.global_position=lerp(self.global_position,pos,0.5)
	
	return
