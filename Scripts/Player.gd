extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 10000
export var rotation_speed = 0.05
export var bullet_prefab : PackedScene
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
var deg_per_frame : float = 25.0/360.0
onready var sprite : Sprite = $Sprite

enum States {IDLE=0, UP=1, DOWN=2, SHOOT=4}
onready var state = States.IDLE

func _ready():
	print(deg_per_frame)
	pass # Replace with function body.


func start_shoot():
	while true:
		var instance = bullet_prefab.instance()
		Game.root_node.add_child(instance)
		instance.position = position
		instance.rotation = self.rotation-deg2rad(90)
		if (state & States.SHOOT)!=0:
			yield(get_tree().create_timer(0.3),"timeout")
		else:
			return

func _input(event):
	
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_up"):
			state = state | States.UP
		if Input.is_action_just_released("ui_up"):
			state = state & ~States.UP
		if Input.is_action_just_pressed("ui_down"):
			state = state | States.DOWN
		if Input.is_action_just_released("ui_down"):
			state = state & ~States.DOWN
		if Input.is_action_just_pressed("ui_select"):
			state = state | States.SHOOT
			start_shoot()
			
		if Input.is_action_just_released("ui_select"):
			state = state & ~States.SHOOT
			
			
		print(state)
func _process(delta):
	position=position+Vector2(delta,0).rotated(rotation)*speed*delta	
	if (state & States.UP)!=0:
		rotation = rotation + rotation_speed * delta
		pass
	if (state & States.DOWN)!=0:
		rotation = rotation - rotation_speed * delta
		pass
	#if (state & States.SHOOT)!=0:
	#	shoot()
	#	pass
	#var new_angle =  rotation+clamp(get_angle_to(get_global_mouse_position()),-1,1)
	#var lerp_new_angle = lerp_angle(rotation, new_angle,0.05)
	#var lerp_new_angle = (new_angle-
	#rotation+=get_angle_to(get_global_mouse_position())
	#rotation=lerp_new_angle
	
	
	
	#var ang = get_angle_to(get_global_mouse_position())
	#ang = clamp(ang,-0.02,0.02)
	#rotation = rotation +  ang#deg2rad(clamp(rad2deg(rotation-new_angle),-5,5))

	var deg_angle_to_earth = rad2deg(get_angle_to(Vector2.ZERO.rotated(rotation)))-90
	if (deg_angle_to_earth < 0 ):
		deg_angle_to_earth += 360
	elif (deg_angle_to_earth>360):
		deg_angle_to_earth-=360
	var frame_num =floor(deg_angle_to_earth * deg_per_frame)
	#print(frame_num)
	sprite.frame = frame_num
	#print("1 ", rad2deg(angle_to_earth)-90)
	
	"""
		0 = 0
	
	"""
	#print("2 ", rad2deg(rotation))
	#print("3 ", rad2deg(angle_to_earth)+rad2deg(rotation)-90)
"""
func get_spawn_pos():
	randomize()
	var ang = randf() * PI * 2;
	var radius = yPos #abs(y_pos)#rand_range(radius_min,radius_max)
	#print(radius)
	var x = 0 + radius * sin(ang)
	var y = 0 + radius * cos(ang)
	return Vector2(x,y)	
"""

func lerp_angle(from, to, weight):
    return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
    var max_angle = PI * 2
    var difference = fmod(to - from, max_angle)
    return fmod(2 * difference, max_angle) - difference
