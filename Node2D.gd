extends Node2D

var lineStart = Vector2()
var lineEnd   = Vector2()
var startMousePos = Vector2(-1,0)

signal throw(throwForce)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.



func _unhandled_input(event):
	var playerPos = self.get_global_transform_with_canvas().get_origin()
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if not event.is_pressed():
				emit_signal("throw", lineEnd - lineStart)
				startMousePos = Vector2(-1,0)
				lineStart = 0
				lineEnd = 0
				self.update()
			else:
				startMousePos = event.position
				lineStart = startMousePos - playerPos
				lineEnd   = startMousePos - playerPos
				
	elif event is InputEventMouseMotion:
		if startMousePos[0] > -1:
			if lineStart != event.position - playerPos:
				lineStart = event.position - playerPos
				self.update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _draw():
	#draw_line(Vector2(0,0), Vector2(100,100), Color(1,1,1,1), 1, false)
	var points
	if lineStart != lineEnd:
		print('drawing')
		print(lineStart, lineEnd)
		var l = lineStart.distance_to(lineEnd)
		print('DISTANCE', l)
		var phi = lineStart.angle_to_point(lineEnd) + deg2rad(90)
		print('ROTATION', rad2deg(phi))
		var xoff = sqrt(l/5)
		var yoff = sqrt(l/7)
		points = PoolVector2Array([Vector2(0,0), Vector2(xoff, l - yoff), Vector2(0,l), Vector2(-xoff, l - yoff)])
		for a in range(len(points)):
			var i = points[a]
			i = i.rotated(phi)
			i = i + lineStart
			points[a] = i
		print(points)
		draw_colored_polygon(points, Color(1,0,0,0.5), PoolVector2Array(), null, null, true)
