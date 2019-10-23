extends Node2D

export var speed = 10000
export var rotation_speed = 0.05
export var bullet_prefab : PackedScene
export(float) var shoot_speed = 1.0
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
var deg_per_frame : float = 25.0/360.0
#onready var sprite : Sprite = $Sprite

enum States {IDLE=0, UP=1, DOWN=2, SHOOT=4, TARGET = 5}
onready var state = States.IDLE

onready var area : Area2D = $DetectionArea
var target = null
export var health = 3
onready var anim = $Anim

func _ready():
    area.connect("body_entered", self, "body_entered")
    #print(deg_per_frame)
    pass # Replace with function body.

func body_entered(body):
    #print(body.name)
    if target == null && body.is_in_group("player"):
        target = body
        state = States.TARGET

var shooting = false
func start_shoot():
    #return
    var shots = 10
    if shooting:
        return
    while true:
        shooting = true
        var instance = bullet_prefab.instance()
        Game.root_node.add_child(instance)
        instance.position = position
        instance.rotation = self.rotation#-deg2rad(90)
        yield(get_tree().create_timer(shoot_speed),"timeout")
        shots-=1
        if (shots<=0):
            shooting = false
            return

func die():
    pass 

func _on_hit(body):
    #print("!!")
    health-=1
    if health==0:
        anim.play("explosion")
        yield(anim,"animation_finished")
        queue_free()        
        pass
    elif health>0:
        anim.play("damage")
    pass	
            

func _process(delta):
    var accel = 1.0
    rotation  = fmod(rotation,2*PI)
    accel = 1#accel*(sin(rotation)/2+1.25)
    position=position+Vector2(delta,0).rotated(rotation)*speed*delta*accel

    
    if (target):#&& state == States.TARGET):
        var angle_to_target = get_angle_to(target.global_position)
        rotation = rotation+clamp(angle_to_target,-rotation_speed,rotation_speed)*delta*accel#delta*clamp(angle_to_target,-rotation_speed,rotation_speed)
        if (shooting==false && abs(rad2deg(angle_to_target))<25):
            start_shoot()
        
        #look_at(target.global_position)
    var deg_angle_to_earth = rad2deg(get_angle_to(Vector2.ZERO.rotated(rotation)))-90
    if (deg_angle_to_earth < 0 ):
        deg_angle_to_earth += 360
    elif (deg_angle_to_earth>360):
        deg_angle_to_earth-=360
    var frame_num =floor(deg_angle_to_earth * deg_per_frame)
#    sprite.frame = frame_num



func lerp_angle(from, to, weight):
    #fmod(
    return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
    var max_angle = PI * 2
    var difference = fmod(to - from, max_angle)
    return fmod(2 * difference, max_angle) - difference
