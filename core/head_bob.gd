extends HeadMovement

class_name HeadBob

@export_node_path var step_path
@onready var step : Step = get_node(step_path)
var speed : float = 0
@export var lerp_bob_curve = (Resource)

var original_position

func _ready():
	original_position = position
	setup_bob(step.interval * 2);
	
func head_bob_process(speed:float, is_on_floor:bool, delta:float):
	lerp_bob_curve.bob_process(delta)
	var head = do_head_bob(speed,delta)
	var new_position = original_position
	if(is_on_floor):
		new_position += head
#	new_position.y -= lerp_bob_curve.offset
#	position = new_position

#Lerp bob	
@export var bob_range = Vector2(0.1, 0.1)
@export var bob_curve = (Curve)
@export var curve_multiplier = Vector2(4,2)

@export var vertical_horizontal_ratio = 2

var cycle_position_x: float = 0;
var cycle_position_y: float = 0;
var bob_base_interval: float = 0;

func setup_bob(bob_base_interval: float):
	self.bob_base_interval = bob_base_interval
	print(bob_base_interval)

func do_bob_jump():
	lerp_bob_curve.do_bob_cycle()

func do_head_bob(speed: float, delta: float) -> Vector3: 
	var x_pos = (bob_curve.sample(cycle_position_x) * curve_multiplier.x * bob_range.x)
	var y_pos = (bob_curve.sample(cycle_position_y) * curve_multiplier.y * bob_range.y)

	var tick_speed = (speed * delta) / bob_base_interval
	cycle_position_x += tick_speed
	cycle_position_y += tick_speed * vertical_horizontal_ratio

	if(cycle_position_x > 1):
		cycle_position_x -= 1
	if(cycle_position_y > 1):
		cycle_position_y -= 1

	return Vector3(x_pos,y_pos,0)