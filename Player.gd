extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var respawn_position: Vector3 = Vector3.ZERO
@export var total_coins: int = 0

var score: int = 0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _score_label: Label = get_tree().get_first_node_in_group("ui_score_label") as Label
@onready var _message_label: Label = get_tree().get_first_node_in_group("ui_message_label") as Label
@onready var _instruction_label: Label = get_tree().get_first_node_in_group("ui_instruction_label") as Label
@onready var _win_label: Label = get_tree().get_first_node_in_group("ui_win_label") as Label

func _ready() -> void:
    add_to_group("player")
    respawn_position = respawn_position == Vector3.ZERO ? global_position : respawn_position
    call_deferred("_initialize_ui")

func _initialize_ui() -> void:
    if total_coins <= 0:
        total_coins = get_tree().get_nodes_in_group("coin_pickup").size()
    var goal := get_tree().get_first_node_in_group("goal")
    if goal and goal.has_method("get_required_coins"):
        var required := goal.get_required_coins()
        if required > 0:
            total_coins = required
    if total_coins <= 0:
        total_coins = 1
    score = clamp(score, 0, total_coins)
    update_score_display()
    _set_instruction("Collect every coin and reach the glowing goal!")

func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        get_tree().reload_current_scene()
        return

    if not is_on_floor():
        velocity.y -= gravity * delta

    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = jump_velocity

    var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)

    move_and_slide()

    if global_position.y < -10.0:
        reset_position()

func collect_coin() -> void:
    score += 1
    score = clamp(score, 0, max(total_coins, 1))
    update_score_display()

    if has_all_coins():
        _set_instruction("Great! Step into the goal to finish.")

func update_score_display() -> void:
    if _score_label:
        var total := max(total_coins, 1)
        _score_label.text = "Coins: %d/%d" % [score, total]

func reset_position() -> void:
    global_position = respawn_position
    velocity = Vector3.ZERO

    if _message_label:
        _message_label.visible = false
    if _win_label:
        _win_label.visible = false

    if not has_all_coins():
        _set_instruction("Collect every coin and reach the glowing goal!")

func has_all_coins() -> bool:
    return score >= max(total_coins, 1)

func _set_instruction(text: String) -> void:
    if _instruction_label:
        _instruction_label.visible = true
        _instruction_label.text = text
