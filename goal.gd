extends Area3D

@export var required_coins: int = 5
@export var hover_height: float = 0.5
@export var hover_speed: float = 1.4
@export var rotation_speed_deg: float = 45.0

var _base_height: float = 0.0
var _player: Node = null
var _message_token: int = 0

var _message_label: Label
var _win_label: Label
var _instruction_label: Label

func _ready() -> void:
    add_to_group("goal")
    body_entered.connect(_on_body_entered)

    _player = get_tree().get_first_node_in_group("player")
    _message_label = get_tree().get_first_node_in_group("ui_message_label") as Label
    _win_label = get_tree().get_first_node_in_group("ui_win_label") as Label
    _instruction_label = get_tree().get_first_node_in_group("ui_instruction_label") as Label

    _base_height = global_position.y
    if required_coins <= 0:
        required_coins = max(get_tree().get_nodes_in_group("coin_pickup").size(), 1)

func _process(delta: float) -> void:
    rotate_y(deg_to_rad(rotation_speed_deg) * delta)
    var time := Time.get_ticks_msec() / 1000.0
    global_position.y = _base_height + sin(time * hover_speed) * hover_height

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player"):
        if _player == null:
            _player = body
        var enough_coins := false
        if body.has_method("has_all_coins"):
            enough_coins = body.has_all_coins()
        else:
            enough_coins = int(body.get("score")) >= required_coins

        if enough_coins:
            show_win_screen()
        else:
            show_message("Collect all coins first!")

func show_win_screen() -> void:
    _message_token += 1
    if _message_label:
        _message_label.visible = false

    if _win_label:
        _win_label.visible = true
        _win_label.text = "YOU WIN!\nPress Esc to restart"

    if _instruction_label:
        _instruction_label.visible = true
        _instruction_label.text = "Press Esc to play again."

func show_message(msg: String) -> void:
    _message_token += 1
    var token := _message_token

    if _message_label:
        _message_label.visible = true
        _message_label.text = msg
    if _win_label:
        _win_label.visible = false
    if _instruction_label:
        _instruction_label.visible = false

    await get_tree().create_timer(2.0).timeout

    if token != _message_token:
        return

    if _message_label:
        _message_label.visible = false

    _restore_instruction()

func get_required_coins() -> int:
    return required_coins

func _restore_instruction() -> void:
    if not _instruction_label:
        return

    var show_goal_prompt := false
    if _player and _player.has_method("has_all_coins"):
        show_goal_prompt = _player.has_all_coins()

    _instruction_label.visible = true
    if show_goal_prompt:
        _instruction_label.text = "Great! Step into the goal to finish."
    else:
        _instruction_label.text = "Collect every coin and reach the glowing goal!"
