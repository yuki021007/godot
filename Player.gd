extends CharacterBody3D

# Movement constants
const SPEED := 5.0
const JUMP_VELOCITY := 4.5

# Score tracking
var score := 0

# Get the gravity from the project settings
var gravity := ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
    add_to_group("player")
    update_score_display()

func _physics_process(delta: float) -> void:
    # Add gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle jump
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # Get input direction
    var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()

    # Reset if fallen off
    if global_position.y < -10:
        reset_position()

func collect_coin() -> void:
    score += 1
    update_score_display()

func update_score_display() -> void:
    var label := get_node_or_null("/root/Main/UI/ScoreLabel")
    if label:
        label.text = "Coins: %d/5" % score

func reset_position() -> void:
    global_position = Vector3(0, 2, 0)
    velocity = Vector3.ZERO
