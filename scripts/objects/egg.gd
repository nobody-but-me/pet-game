extends KinematicBody2D

var is_mouse_in: bool = false;
var is_pressed: bool = false;

enum STATES {
	DRAGGING,
	IDLE,
};
var state = STATES.IDLE;

func _on_egg_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if (_event is InputEventScreenTouch):
		if (_event.pressed and _event.get_index() == 0):
			self.position = _event.get_position();
	return

func _process(_delta: float) -> void:
	if (!Input.is_mouse_button_pressed(BUTTON_LEFT)): is_pressed = false;
	else:                                             is_pressed = true;
	
	if (is_pressed && is_mouse_in):
		var mouse_position = get_viewport().get_mouse_position();
		self.global_position = lerp(self.global_position, Vector2(mouse_position.x, mouse_position.y), 0.5);
	return

func _on_egg_mouse_entered() -> void: is_mouse_in = true;
func _on_egg_mouse_exited() -> void: is_mouse_in = false;
