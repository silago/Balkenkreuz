extends Node

var events = {}

enum EVENTS { PLAYER_POSITION_CHANGED }

func _ready():
    pass # Replace with function body.

func subscribe(name, ref : FuncRef):
    if !events.has(name):
        events[name] = []
    events[name].append(ref)
    #print("subscribe")
func unsubscribe(name, ref : FuncRef):
    if !events.has(name):
        return
    for i in events[name] as Array:
        if i == ref:
            events[name].erase(i)
            return
            
func invoke(name, args):
    if !events.has(name):
        return
    if args:
        for i in events[name]:
            i.call_func(args)
    else:
        for i in events[name]:
            i.call_func()
   
        
            