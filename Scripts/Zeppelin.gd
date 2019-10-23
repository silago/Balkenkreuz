extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var health = 10
export var speed = 10
onready var smoke : Particles2D = $Smoke
var dead     = false
var shooting = 0 #0 - ready, 1 - shooting , 2  - about to stop
var timer    = Timer.new()
export var shoot_timer = 2
export var shoot_interval = 1
export var shoot_speed = 0.3
const lower_diff = 5
const max_dist   = 600
export(PackedScene) var bullet_prefab

onready var spawn_pos_1 = $SpawnPos1.position
onready var spawn_pos_2 = $SpawnPos2.position

func _ready():    
    add_child(timer)
    var fr = funcref(self,"on_player_position_changed")
    EventManager.subscribe(EventManager.EVENTS.PLAYER_POSITION_CHANGED,fr)
    connect("tree_exited",EventManager,"unsubscribe",[EventManager.EVENTS.PLAYER_POSITION_CHANGED,fr])
    
func on_player_position_changed(args):
    if health<1:
        return
    if shooting!=0:
        return
    var is_close = is_close_enough(args["position"])
    #print(is_close)
    if is_close:
        start_shooting(args["position"])

func shoot(player_pos):    
    var shoot_timer = Timer.new()
    add_child(shoot_timer)
    var r = rotation+get_angle_to(player_pos)
    while shooting==1:
        var bullet
        bullet = bullet_prefab.instance()
        Game.root_node.add_child(bullet) as Node2D
        bullet.global_position = global_position+spawn_pos_1#global_position
        bullet.rotation = r
        
        
        bullet = bullet_prefab.instance()
        Game.root_node.add_child(bullet) as Node2D
        bullet.global_position = global_position+spawn_pos_2
        bullet.rotation = r
        
        
        
            
        shoot_timer.start(shoot_speed)
        yield(shoot_timer,"timeout")
    shoot_timer.queue_free()
    
func start_shooting(player_pos):
    if shooting!=0:
        return
    shooting = 1
    timer.start(shoot_timer)
    shoot(player_pos)
    yield(timer,"timeout")
    shooting = 2
    timer.start(shoot_interval)
    yield(timer,"timeout")
    shooting = 0
    pass
        


func is_close_enough(player_pos : Vector2):
    #print  (player_pos.y , " - ", global_position.y  , " >  ", lower_diff , " ",global_position.distance_to(player_pos)  , " <", max_dist)
    return  (player_pos.y - global_position.y > lower_diff)  && (global_position.distance_to(player_pos) < max_dist)
                

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
        yield($VisibilityNotifier2D,"screen_exited")
        queue_free()