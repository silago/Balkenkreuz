extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var health = 10
export var speed = 10
onready var smoke : Particles2D = $Smoke
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	position+=Vector2(speed*delta,0).rotated(rotation)
	if dead and rotation>deg2rad(-65):
		rotation-=deg2rad(3*delta)

func _on_hit(body):
	health-=1
	if health==0:
		smoke.visible = true
		dead = true