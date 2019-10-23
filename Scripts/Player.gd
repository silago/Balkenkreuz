extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var max_speed = 15000
export var min_speed = 10000
export var accell_speed   = 100
export var deaccell_speed = 100
var speed = min_speed

export var rotation_speed = 0.05
export var bullet_prefab : PackedScene
export(float) var shoot_speed = 1.0
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
var deg_per_frame : float = 25.0/360.0
onready var sprite : Sprite = $Sprite

enum States {IDLE=0, LEFT=1, RIGHT=2, SHOOT=4, ACELL=8}
onready var state = States.IDLE
onready var  area : Area2D =  $Area
var enemies_count = 0

func has_state(st):
    return (state & st)!=0
    
func add_state(st):
    state = state | st
    
func remove_state(st):
    state = state & ~st    

var rot = 0

func start_loop():
    #EventManager.re
    var timer = Timer.new()
    add_child(timer)
    timer.start(1)
    while true:
        yield(timer,"timeout")
        EventManager.invoke(EventManager.EVENTS.PLAYER_POSITION_CHANGED,{"position":global_position})
    
        
    

func on_enemy_enter(body):
    if !body.is_in_group("enemy"):
        return
        
    enemies_count+=1
    if enemies_count > 0 && !has_state(States.SHOOT):
        add_state(States.SHOOT)
        start_shoot()
    pass
    
func on_enemy_exit(body):
    if !body.is_in_group("enemy"):
        return
    enemies_count-=1
    if enemies_count <= 0 && has_state(States.SHOOT):
        enemies_count = 0
        remove_state(States.SHOOT)
    pass

func _ready():
    var _e 
    _e = area.connect("area_entered",self,"on_enemy_enter")
    _e = area.connect("area_exited",self,"on_enemy_exit")
    _e = area.connect("body_entered",self,"on_enemy_enter")
    _e = area.connect("body_exited",self,"on_enemy_exit")
    
    start_loop()
    
func shoot():
    var instance = bullet_prefab.instance()
    Game.root_node.add_child(instance)
    instance.position = position
    instance.rotation = instance.rotation+self.rotation#+deg2rad(rand_range(-3,3))
    pass
func start_shoot():
    #call_deferred(
    while true:
        call_deferred("shoot")
        if (has_state(States.SHOOT)):
            yield(get_tree().create_timer(shoot_speed),"timeout")
        else:
            return

#var acce
func _input(event):
    #if event is InputEventMouse:
    if event as InputEventMouseButton:
        if event.is_pressed():# && event.button_index == 1:
            add_state(States.ACELL)
        else:
            remove_state(States.ACELL)
            
            
func constrain_angle(x):
    x = fmod(x + PI,PI*2)
    if (x < 0):
        x += PI*2
    return x - PI

func dir_state(st):
    #print()
    if st == States.RIGHT:
        #print("rigjt")
        if has_state(States.LEFT): remove_state(States.LEFT)
        add_state(States.RIGHT)
            
    
    if st == States.LEFT:
        if has_state(States.RIGHT): remove_state(States.RIGHT)
        add_state(States.LEFT)
    pass


func _process(delta):  
    if has_state(States.ACELL):
        var ang_to_mouse = constrain_angle(get_angle_to(get_global_mouse_position()))
        rot = abs(ang_to_mouse)/PI
        if speed<max_speed:
            speed+=accell_speed*delta
        if ang_to_mouse > 0:
            dir_state(States.LEFT)
        elif ang_to_mouse < 0:        
            dir_state(States.RIGHT)
        pass
        
    else:        
        if speed>min_speed:
            speed-=deaccell_speed*delta
        pass
   

    var accel = 1.0 #top down accell
    rotation  = fmod(rotation,2*PI)
    accel = 1#accel*(sin(rotation)/2+1.25)
    position=position+Vector2(delta,0).rotated(rotation)*speed*delta*accel
    if has_state(States.LEFT):
        rotation = rotation + (rotation_speed *accel) * delta*accel*rot
        pass
    if has_state(States.RIGHT):
        rotation = rotation - (rotation_speed *accel) * delta*accel*rot
        pass


    var deg_angle_to_earth = rad2deg(get_angle_to(Vector2.ZERO.rotated(rotation)))-90
    if (deg_angle_to_earth < 0 ):
        deg_angle_to_earth += 360
    elif (deg_angle_to_earth>360):
        deg_angle_to_earth-=360
    var frame_num =floor(deg_angle_to_earth * deg_per_frame)
    sprite.frame = frame_num


func lerp_angle(from, to, weight):
    return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
    var max_angle = PI * 2
    var difference = fmod(to - from, max_angle)
    return fmod(2 * difference, max_angle) - difference
