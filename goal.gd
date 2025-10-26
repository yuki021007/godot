extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	# Gentle floating animation
	position.y += sin(Time.get_ticks_msec() / 500.0) * 0.001

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Check if all coins collected
		if body.score >= 5:
			show_win_screen()
		else:
			show_message("Collect all coins first!")

func show_win_screen():
	var label = get_node("/root/Main/UI/WinLabel")
	if label:
		label.visible = true
		label.text = "YOU WIN!\nPress R to restart"

func show_message(msg):
	var label = get_node("/root/Main/UI/MessageLabel")
	if label:
		label.text = msg
		label.visible = true
		# Hide after 2 seconds
		await get_tree().create_timer(2.0).timeout
		label.visible = false
