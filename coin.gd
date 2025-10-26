extends Area3D

@export var rotation_speed_deg: float = 120.0
@export var bob_height: float = 0.35
@export var bob_speed: float = 2.2

var _base_height: float = 0.0

func _ready() -> void:
    add_to_group("coin_pickup")
    body_entered.connect(_on_body_entered)
    _base_height = global_position.y

func _process(delta: float) -> void:
    rotate_y(deg_to_rad(rotation_speed_deg) * delta)
    var time := Time.get_ticks_msec() / 1000.0
    global_position.y = _base_height + sin(time * bob_speed) * bob_height

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player"):
        if body.has_method("collect_coin"):
            body.collect_coin()
        queue_free()
