extends Area2D



var dying = false
export var speed = 200

export var speedLimit = 1000

var collisionGroups = ["earth","player"]
export var   bullet_degree = 20.0
export var 	 accell = 0.0;

#onready var playerDestroyer = $PlayerAreaDestroyer
#onready var explosion_anim= get_node("Explosion")
onready var additional_rotation = rand_range(-bullet_degree,bullet_degree)

func _ready():
	if accell == 0:
		accell = 1
	self.connect("body_entered",self,"_on_enter")
	#explosion_anim.visible = false
	global_rotation = 0
	rotation = 0
	look_at(Vector2.ZERO)
	rotation-=deg2rad(90)+deg2rad(additional_rotation)
	#dying = true
	
func destroy():
	pass
	
func _on_enter(body):
	if not dying:
		for body in get_overlapping_bodies():
			for collisionGroup in collisionGroups:
				if body.is_in_group(collisionGroup):
					if body.has_method("_on_hit"):
						body._on_hit(self)
						print("HIT")
		explode()
	
func explode():
	if (dying):
		return
	dying = true
	var sprite = $Sprite
	if sprite:
		sprite.hide()
	#$Sprite.hide()
	#explosion_anim.visible = true
	#var anim = get_node("Explosion/Anim")
	#get_node("Sprite").visible = false
	#anim.play("default")

	#yield(anim,"animation_finished")
	queue_free()
	
func _physics_process(delta):
	if dying:
		return
	#if speed < speedLimit:
	#	speed *= accell
	#var target = Game.player.position
	#look_at(target)
	#rotation+=deg2rad(-90)
	position+=Vector2.DOWN.rotated(rotation)* delta*speed
	