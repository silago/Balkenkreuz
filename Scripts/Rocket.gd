extends Node2D

export var speed = 10000
export var rotation_speed = 0.05

#export(float) var shoot_speed = 1.0
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
var deg_per_frame : float = 25.0/360.0
export (Array,String) var collision_groups
#onready var sprite : Sprite = $Sprite

enum States {IDLE=0, UP=1, DOWN=2, SHOOT=4, TARGET = 5}
onready var state = States.IDLE

onready var detection_area : Area2D = $DetectionArea
onready var collision_area : Area2D = $CollisionArea
var target = null
export var health = 3
onready var anim = $Anim

func _ready():
    detection_area.connect("body_entered", self, "on_body_entered_into_detectiob")
    detection_area.connect("area_entered", self, "on_body_entered_into_detectiob")  
    
    collision_area.connect("body_entered", self, "on_body_enter")
    collision_area.connect("area_entered", self, "on_body_enter")
    
    #print(deg_per_frame)
    pass # Replace with function body.

func on_body_enter(body):
    if body == self:
        return
    for group in collision_groups:
        if body.is_in_group(group):
            if body.has_method("_on_hit"):
                print(body.name)
                body._on_hit(body)
                _on_hit(self)
                return
                
func on_body_entered_into_detectiob(body):
    if target == null && body.is_in_group("player"):
        target = body
        state = States.TARGET
        #print(body.name)
func die():
    pass 

func _on_hit(body):
    #print("!!")
    health-=1
    if health==0:
        anim.play("explode")
        $Sprite.hide()
        yield(anim,"animation_finished")
        queue_free()        
        pass
    #elif health>0:
    #    anim.play("damage")
    pass	
            

func _process(delta):
    var accel = 1.0
    accel = 1#accel*(sin(rotation)/2+1.25)
    position=position+Vector2(delta,0).rotated(rotation)*speed*delta*accel
    if (target):#&& state == States.TARGET):
        #print(target.name)
        var angle_to_target = get_angle_to(target.global_position)
        rotation = rotation+clamp(angle_to_target,-rotation_speed,rotation_speed)*delta*accel#delta*clamp(angle_to_target,-rotation_speed,rotation_speed)
        rotation  = fmod(rotation,2*PI)
        
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
