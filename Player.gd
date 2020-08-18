extends RigidBody2D

export var acc = 500
export var jumpforce = 600
export var maxspd = 400
var active_force = Vector2(0,0)
var jumps = 0
var jump = false
var on_ground = false
var glasses = load("res://glasses.tscn")
var startMousePos = Vector2(-1,0)
var lineStart = Vector2()
var lineEnd   = Vector2()
var throwForce= Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../camera/Camera2D".connect("throw", self, "_on_throw")
	
	
# warning-ignore:unused_argument
func _physics_process(delta):
	if jump and jumps > 0:
		self.linear_velocity[1] = 0
		self.apply_central_impulse(Vector2(0, -jumpforce))
		jumps -= 1
		jump = false
		

#func _input(event):
#	if event is InputEventKey:
#		if event.scancode == KEY_UP:
#			if event.pressed == true and event.echo == false: jump = true
#			if event.pressed == false: jump = false
func _on_throw(throwForce):
	var glass = glasses.instance()
	glass.linear_velocity = self.linear_velocity
	add_child_below_node(get_tree().get_root().get_child(0),glass)
	glass.global_position = self.global_position + Vector2(2, -12)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	var spd = 0
	var rspd = 0
	self.linear_damp = 1
	if Input.is_action_pressed("ui_right"):
		spd +=  1
	if Input.is_action_pressed("ui_left"):
		spd += -1
	if Input.is_action_pressed("ui_down"):
		self.gravity_scale  = 10
	else: self.gravity_scale= 1
	if Input.is_action_just_pressed("ui_up"):
		jump = true
	if Input.is_action_just_released("ui_up"):
		jump = false
	rspd = spd
	if abs(self.linear_velocity[0]) > maxspd: rspd = 0
		
	var new_force = Vector2(rspd*acc,0)
	if active_force != new_force:
		self.add_central_force(active_force*(-1))
		self.add_central_force(new_force)
		active_force = new_force
	
	if spd == 1: $Glasses.play("right")
	elif spd == -1: $Glasses.play("left")
	
	if on_ground:
		self.friction = 0.55
		if spd == 0: $AnimS.play("idle")		
		else: 
			if $AnimS.animation != "walk":
				$AnimS.play("walk")
				$AnimS.set_frame(randi()%2)
	else:
		self.friction = 0.01
		$AnimS.play("jump")
		
		


# warning-ignore:unused_argument
func _on_Area2D_body_entered(body):
	#if body != self:
	jumps = 2
	on_ground = true
	self.friction = 0.6

# warning-ignore:unused_argument
func _on_Area2D_body_exited(body):
	on_ground = false
	self.friction = 0.001
