extends KinematicBody2D

const PRE_SPEAR = preload("res://prefabs/spear_hand.tscn")
const MAX_LIFE = 100
const SPEED = 200

var life = MAX_LIFE
var has_spear = false
var loaded = true

func _ready():
	$area_hit.connect("hitted", self, "on_area_hitted")
	$area_hit.connect("destroid", self, "on_area_destroid")
	pass

func _physics_process(delta):
	var x_dir = 0
	var y_dir = 0
	
	if Input.is_action_pressed("ui_right"):
		x_dir += 1
		$anim_sprite.play("walk")
	if Input.is_action_pressed("ui_left"):
		x_dir -= 1
		$anim_sprite.play("walk")
	if Input.is_action_pressed("ui_up"):
		y_dir -= 1
		$anim_sprite.play("walk")
	if Input.is_action_pressed("ui_down"):
		y_dir += 1
		$anim_sprite.play("walk")
	
	if not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		$anim_sprite.play("idle")
	
	if Input.is_action_just_pressed("ui_attack"):
		shoot_spear()
	
	if has_spear:
		$spear_hand.show()
	else:
		$spear_hand.hide()
	
	look_at(get_global_mouse_position())
	move_and_slide(Vector2(x_dir, y_dir) * SPEED)

func shoot_spear():
#	if has_spear and loaded:
	get_tree().call_group("spear", "spear_false")
	
	var position_mouse = global_position.distance_to(get_global_mouse_position())
	var angle = atan2(get_global_mouse_position().y - global_position.y, get_global_mouse_position().x - global_position.x)
	var correct
	var spear_attack = PRE_SPEAR.instance()
	
	if position_mouse < 100:
		correct = 0.19
	elif position_mouse < 250:
		correct = 0.075
	elif position_mouse < 400:
		correct = 0.050
	elif position_mouse < 550:
		correct = 0.032
	elif position_mouse < 700:
		correct = 0.026
	elif position_mouse < 850:
		correct = 0.023
	elif position_mouse < 1000:
		correct = 0.020
	elif position_mouse < 1200:
		correct = 0.017
	else:
		correct = 0.50
	
	spear_attack.global_position = $spear_hand.global_position / 2
	spear_attack.rotation = global_rotation
	spear_attack.dir = Vector2(cos(angle - correct), sin(angle - correct))
	#spear_attack.scale = spear_attack.scale / 2
	spear_attack.target_position = get_global_mouse_position()
	spear_attack.type = "player_attack"
	get_parent().add_child(spear_attack)
	
	has_spear = false
	loaded = false
	$reload.start()

func take_spear():
	get_tree().call_group("spear", "spear_true")
	if not has_spear:
		has_spear = true

func _on_reload_timeout():
	$reload.stop()
	loaded = true
	
func on_area_hitted(damage, health, node):
	pass

func on_area_destroid():
#	queue_free()
	pass
