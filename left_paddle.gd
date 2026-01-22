extends StaticBody2D

# Flipper settings
@export var flip_key: String = "left_paddle"  # Input action to activate flipper
@export var rest_angle: float = 0.0  # Angle when flipper is down (in degrees)
@export var active_angle: float = -15.0  # Angle when flipper is up (in degrees)
@export var flip_speed: float = 100.0  # How fast the flipper moves (degrees per second)

var target_angle: float = 0.0
var current_angle: float = 0.0

func _ready():
	# Set initial rotation
	current_angle = rest_angle
	rotation_degrees = current_angle
	target_angle = rest_angle

func _process(delta):
	# Check if the flip key is pressed
	if Input.is_action_pressed(flip_key):
		target_angle = active_angle  # Flipper up
	else:
		target_angle = rest_angle  # Flipper down
	
	# Smoothly interpolate to target angle
	if current_angle != target_angle:
		var angle_diff = target_angle - current_angle
		var step = flip_speed * delta
		
		if abs(angle_diff) < step:
			current_angle = target_angle
		else:
			current_angle += sign(angle_diff) * step
		
		rotation_degrees = current_angle
