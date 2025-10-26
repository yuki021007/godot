extends Area3D

# Rotation speed
var rotation_speed = 2.0

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _process(delta):
	# Rotate the coin
	rotate_y(rotation_speed * delta)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Tell player to add score
		body.collect_coin()
		# Play sound (if you have AudioStreamPlayer)
		# $AudioStreamPlayer.play()
		# Remove coin
		queue_free()
