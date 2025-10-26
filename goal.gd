extends Area3D

const REQUIRED_COINS := 5

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
    position.y += sin(Time.get_ticks_msec() / 500.0) * 0.001

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player"):
        if body.score >= REQUIRED_COINS:
            show_win_screen()
        else:
            show_message("Collect all coins first!")

func show_win_screen() -> void:
    var label := get_node_or_null("/root/Main/UI/WinLabel")
    if label:
        label.visible = true
        label.text = "YOU WIN!\nPress R to restart"

func show_message(msg: String) -> void:
    var label := get_node_or_null("/root/Main/UI/MessageLabel")
    if label:
        label.text = msg
        label.visible = true
        await get_tree().create_timer(2.0).timeout
        label.visible = false
