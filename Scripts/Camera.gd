extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
export var target : NodePath
onready var target_obj = get_node(target)
func _ready():
	pass # Replace with function body.
	#position = 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = target_obj.global_position
	#look_at(Vector2.ZERO)
	#position=position+Vector2(delta,0).rotated(rotation)*speed*delta
	var new_angle = rotation+get_angle_to(target_obj.position)
	#rotation+=get_angle_to(get_global_mouse_position())
	rotation=lerp_angle(rotation, target_obj.rotation,0.05)
	pass

func lerp_angle(from, to, weight):
    return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
    var max_angle = PI * 2
    var difference = fmod(to - from, max_angle)
    return fmod(2 * difference, max_angle) - difference
