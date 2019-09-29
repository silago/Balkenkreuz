extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready  var muzzle = $muzzle
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	loop()
	
	
onready var start_rotation = rotation
onready var target_rotation = rotation
func loop():
	while true:
		#print("...")
		var r = randi() % 2
		
		yield(get_tree().create_timer(r),"timeout")
		start_rotation = muzzle.rotation
		target_rotation = randi()%90 - 45
		#print(target_rotation)
		target_rotation = deg2rad(target_rotation)
		
		yield(get_tree().create_timer(2),"timeout")
		pass
	
func _process(delta):
	if rotation!=target_rotation:
		muzzle.rotation = lerp_angle(muzzle.rotation,target_rotation,0.1)
	
func lerp_angle(from, to, weight):
    return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
    var max_angle = PI * 2
    var difference = fmod(to - from, max_angle)
    return fmod(2 * difference, max_angle) - difference

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
