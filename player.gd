'''extends CharacterBody2D


@export var speed : float = 150.0

@onready var animation_tree : AnimationTree = $AnimationTree

var direction : Vector2 = Vector2.ZERO

func _ready():
	animation_tree.active = true
	
func _process(_delta):
	update_animation_parameters()

	
func _physics_process(_delta):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		
		
	move_and_slide()
	
func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		$AnimationTree.get("parameters/playback").travel("idle")
	else:
		$AnimationTree.set("parameters/idle/blend_position", velocity)
		$AnimationTree.set("parameters/walk/blend_position", velocity)'''
		
extends CharacterBody2D


@export var speed : float = 150.0
@export var movement_threshold : float = 0.1  # Threshold for determining idle vs moving

# Node references
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var animation_state : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

# Variables to handle movement and animation
var direction : Vector2 = Vector2.ZERO
var last_direction : Vector2 = Vector2(0, 1)  # Default to down direction for idle state

func _ready():
	animation_tree.active = true

func _process(_delta):
	update_animation_parameters()

func _physics_process(_delta):
	# Get input from arrow keys or WASD
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()

	# If direction is not zero, update velocity
	if direction != Vector2.ZERO:
		velocity = direction * speed
		last_direction = direction  # Store the last movement direction
	else:
		velocity = Vector2.ZERO

	# Move the player
	move_and_slide()

# Update the animation based on player movement
func update_animation_parameters():
	if velocity.length() < movement_threshold:
		# Player is idle, use the last known direction
		set_idle_animation()
	else:
		# Player is moving, use the current direction
		set_walk_animation()

# Helper function to set idle animation
func set_idle_animation():
	# Set the blend position to the last direction (so the idle face direction is correct)
	$AnimationTree.set("parameters/idle/blend_position", get_direction_blend_position(last_direction))
	animation_state.travel("idle")

# Helper function to set walk animation
func set_walk_animation():
	# Set the blend position to the current movement direction
	$AnimationTree.set("parameters/walk/blend_position", get_direction_blend_position(direction))
	animation_state.travel("walk")

# Function to determine the blend position based on input direction
func get_direction_blend_position(direction: Vector2) -> Vector2:
	# Returns a blend position for the 4 main directions (up, down, left, right)
	if direction.x > 0:
		return Vector2(1, 0)  # Right
	elif direction.x < 0:
		return Vector2(-1, 0)  # Left
	elif direction.y > 0:
		return Vector2(0, 1)  # Down
	elif direction.y < 0:
		return Vector2(0, -1)  # Up
	else:
		# Default to down-facing idle if no direction is given
		return Vector2(0, 1)  # Down




