extends StaticBody2D

onready var terrain = get_parent().get_parent()

export var protectedDistance = 100
export var size = 512
#export var mass = 10.
var max_size = 512
var min_size = 4
var explosion_scale = 2

var shape
var region_origin = Vector2(0,0)
var newNode = []
onready var  poly = $Poly as CollisionPolygon2D
onready var  image = $Image as Polygon2D
onready var  player = get_node("../../Player") 
onready var  occluder = $Occluder
var thread = Thread.new()

#func _ready():	
#	image.polygon = poly.polygon

onready var explosionParticlesPrefab : Particles2D = $"../ParticleTemplate"

#var clipper = Clipper.new()		
func _make_damage(body : Area2D):
    #print("CLIP")
    var rect_1 = poly.polygon
    #var rect_2 = [Vector2(50, 50), Vector2(150, 50), Vector2(150, 150), Vector2(50, 150)]
    var poly_2 = body.get_node("Poly") as CollisionPolygon2D
    print(poly_2)
    var rect_2 = []
    var poly_2_rot = poly_2.global_rotation
    for p in poly_2.polygon:
        rect_2.append(p.rotated(body.global_rotation) + poly_2.global_position)#+ (body.size)/2)#Vector2(-94,)#body.global_position - (body.size/2))
    #var clipper = Clipper.new()
    player.call_deferred("recalc_path",poly_2)
    clipper.set_mode(Clipper.MODE_CLIP)
    # Subject
    clipper.path_type = Clipper.ptSubject
    clipper.add_points(rect_1)
    # Clip
    clipper.path_type = Clipper.ptClip
    clipper.add_points(rect_2)
    
    # Execute
    clipper.clip_type = Clipper.ctDifference
    clipper.execute()
    # Get result
    #print(clipper.get_solution_count())
    var i = 0
    var last_len = 0
    var solutions_count = clipper.get_solution_count()
    var solutions = []
    print(solutions_count)
    for idx in solutions_count:
        var points = clipper.get_solution(idx)
        if len(points)>last_len:
            i = idx
            last_len = len(points)
        #print(i)
        solutions.append(points)
        
    
    
    
    for solution_index in range(solutions.size()):
        if solution_index == i:
            #var points = solutions[solution_index]
            call_deferred("_update_poly", solutions[solution_index])
        else:
            #continue
            var new_node = self.duplicate()
            self.get_parent().add_child(new_node)
            new_node._update_poly(solutions[solution_index])
    clipper.clear()
    #return points

var shapeOwner = 0
func _update_poly(points):
    #var points = thread.wait_to_finish()
    occluder.occluder.polygon = points  
    poly.polygon = points
    #print("poly")
    image.set_polygon(points)
    locked = false
    
var locked = false

func _ready():
    occluder.occluder = OccluderPolygon2D.new()
    explosionParticlesPrefab.look_at(Vector2.ZERO)
    explosionParticlesPrefab.rotation+=deg2rad(-180)
    var shapeOwner = 0
        
    var p = []
    var degree = 0
    var radius = 200
    while degree<360:
        degree+=10
        var radians = degree * PI/180
        var x = 0 + radius * cos(radians)
        var y = 0 + radius * sin(radians)
        p.append(Vector2(x,y))
    poly.polygon = p
    occluder.occluder.polygon = p	
    image.set_polygon(poly.polygon)

    
func _on_hit(body : Area2D):
    #print("1")
    #print(body.global_position.distance_to(Vector2.ZERO))
    if body.global_position.distance_to(Vector2.ZERO) < protectedDistance:
    #	print("2")
        return
    var explosion = explosionParticlesPrefab.duplicate()
    Game.root_node.add_child(explosion)	
    explosion.global_position = body.global_position
    explosion.look_at(Vector2.ZERO)
    explosion.rotation+=deg2rad(-180)
    explosion.global_position-=Vector2(0,25).rotated(explosion.rotation+deg2rad(-90))

    explosion.emitting = true
    #explosion.one_shot = true

    #print("!!!")
    #print("ON AREA HIT")
    #print("3")
    if locked:
        return
    #if thread.is_active():
    #	return
    locked = true
    #print("4")
    call_deferred("_make_damage", body)
    
    
    #thread.start(self,"_make_damage",body)
    pass

