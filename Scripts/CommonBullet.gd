extends Area2D



var dying = false
export var speed = 200

#export var speedLimit = 1000

export var collisionGroups = ["earth","enemy"]
export var   bullet_degree = 20.0
export var 	 accell = 0.0;
#export var bullet_spreading = 3
onready var additional_rotation = rand_range(-bullet_degree,bullet_degree)

func _ready():
    if accell == 0:
        accell = 1
    var _e = self.connect("body_entered",self,"_on_enter")
    #explosion_anim.visible = false
    global_rotation = 0
    rotation = 0
    look_at(Vector2.ZERO)
    rotation=deg2rad(additional_rotation)
    yield($VisibilityNotifier2D,"screen_exited")
    queue_free()
    #dying = true
    
func destroy():
    pass
    
func _on_enter(body):
    #var collide = false
    for collisionGroup in collisionGroups:
        if body.is_in_group(collisionGroup):
            if body.has_method("_on_hit"):
                    body._on_hit(self)
            explode()
            return
            
func explode():
    queue_free()
    
func _physics_process(delta):
    if dying:
        return
    position+=Vector2.RIGHT.rotated(rotation)* delta*speed
    
