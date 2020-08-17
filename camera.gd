extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = (get_node("../Player").position + get_node("../Player2").position)/2
	
	var diff = get_node("../Player").position - get_node("../Player2").position
	diff.x = abs(diff.x)
	diff.y = abs(diff.y)
	
