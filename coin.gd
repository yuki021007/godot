extends Area3D

# Rotation speed
var rotation_speed := 2.0

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
    rotate_y(rotation_speed * delta)

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player"):
        body.collect_coin()
        queue_free()
