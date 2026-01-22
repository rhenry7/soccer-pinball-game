extends RigidBody2D

# Physics properties
@export var bounce_force_multiplier: float = 1.5  # How much to amplify bounce on collision
@export var decay_rate: float = 1.0  # How quickly the ball loses speed (0.98 = 2% loss per physics frame)
@export var min_velocity_threshold: float = 10.0  # Minimum velocity before stopping amplification
@export var rotation_speed: float = 5.0  # How fast the ball rotates while moving

var is_boosted: bool = false

func _ready():
	# Enable physics and set up bounce
	gravity_scale = 1.0
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.bounce = 0.8  # Base bounciness
	
func _physics_process(delta):
	# Gradually decay velocity when not boosted
	if not is_boosted and linear_velocity.length() > min_velocity_threshold:
		linear_velocity *= decay_rate
	
	# Add rotation based on movement speed and direction
	var velocity_magnitude = linear_velocity.length()
	if velocity_magnitude > 1.0:
		# Rotate proportional to speed (negative for rolling effect)
		angular_velocity = -linear_velocity.x * rotation_speed / 100.0
	
	# Reset boost flag each frame
	is_boosted = false

func _integrate_forces(state):
	# Check for collisions
	if state.get_contact_count() > 0:
		# Get the collision normal and current velocity
		var collision_normal = state.get_contact_local_normal(0)
		var current_velocity = linear_velocity
		
		# Calculate the reflection with amplification
		var reflected_velocity = current_velocity.bounce(collision_normal)
		var amplified_velocity = reflected_velocity * bounce_force_multiplier
		
		# Apply the boosted velocity
		linear_velocity = amplified_velocity
		is_boosted = true
