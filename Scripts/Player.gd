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



func _ready():
	print(deg_per_frame)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		#print("SHOOT")
		var instance = bullet_prefab.instance()
		Game.root_node.add_child(instance)
		instance.position = position
		instance.rotation = self.rotation-deg2rad(90)
	
func _process(delta):
	position=position+Vector2(delta,0).rotated(rotation)*speed*delta
	#var new_angle =  rotation+get_angle_to(get_global_mouse_position())
	#var lerp_new_angle = lerp_angle(rotation, new_angle,rotation_speed)
	#var lerp_new_angle = (new_angle-
	#rotation+=get_angle_to(get_global_mouse_position())
	#rotation=lerp_new_angle
	var ang = get_angle_to(get_global_mouse_position())
	ang = clamp(ang,-0.02,0.02)
	rotation = rotation +  ang#deg2rad(clamp(rad2deg(rotation-new_angle),-5,5))

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
