
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
var current_state=States.Walking
var is_dragging:bool=false

var speed=360

var velocity:Vector2=Vector2(0.0,0.0)

# TODO: find a better name for this variable; for now I don't really have a better idea for it
var tmp:float=100.0

func set_state(new_state)->void:
	var _previous_state=current_state
	current_state=new_state
	match(current_state):
		States.Dragging:
			velocity=Vector2.ZERO
		States.Sleeping:
			velocity=Vector2.ZERO
		States.Walking:
			choose_timer.start()
		States.Eating:
			velocity=Vector2.ZERO
		States.Idling:
			velocity=Vector2.ZERO
	return

func _ready()->void:
	randomize()
	return

func _physics_process(_delta:float)->void:
	move_and_slide(velocity*_delta)
#	if(current_state==States.Walking):
#		var xaction=rand_range(-10.0,10.0)
#		var yaction=rand_range(-10.0,10.0)
#		velocity=Vector2(xaction*speed*_delta,yaction*speed*_delta)
	return

func _input(_event:InputEvent)->void:
	if(_event is InputEventMouseButton):
		if(!_event.pressed && _event.button_index==BUTTON_LEFT):
			is_dragging=false
			set_state(States.Walking)
		else:
			var pos=_event.position
			var spr_size=Vector2(sprite.scale.x*tmp,sprite.scale.y*tmp)
# adjusted position so the pet is held by its center
			var spr_pos=Vector2(self.global_position.x-(spr_size.x/2),self.global_position.y-(spr_size.y/2))
# conditional to check whether the touch was inside the pet; it's being checked here instead in the InputEventScreenDrag conditional
#	because then, when the pet is being already held, it won't be 'dropped' if the fingers gets out of its bounds during the movement
			if((pos.x>spr_pos.x&&pos.x<spr_pos.x+spr_size.y)&&(pos.y>spr_pos.y&&pos.y<spr_pos.y+spr_size.y)):
				is_dragging=true
				set_state(States.Dragging)
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

func _on_choosetimer_timeout():
	if(current_state==States.Walking):
		var xaction=rand_range(-10.0,10.0)
		var yaction=rand_range(-10.0,10.0)
		velocity=Vector2(xaction*speed,yaction*speed)
	
	var new_wait_time=rand_range(1.0,5.0)
	choose_timer.wait_time=new_wait_time
	
