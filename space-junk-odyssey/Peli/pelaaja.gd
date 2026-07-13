extends CharacterBody3D

@export var NOPEUS = 5.0

var painovoima = 10
@onready var säde = %PelaajaCast
var xform : Transform3D
@export var KÄÄNTÖNOPEUS = 10.0

var katsomissuunta: Vector2
@onready var kamera = %Kamera
var kamera_sens = 10

var hiirikiinni = false

@onready var alus = %Alus
var painovoimaylös = Vector3.UP

func _physics_process(delta: float) -> void:
	
	# Haetaan painovoiman suunta
	if säde.is_colliding():
		painovoimaylös = säde.get_collision_normal()
	
	# Käännetään lattian mukaisesti
	var eteen = global_transform.basis.z
	
	var tavoiteltu = global_transform.looking_at(global_position - eteen, painovoimaylös)
	global_transform.basis = global_transform.basis.slerp(tavoiteltu.basis, 0.1)
	
	up_direction = painovoimaylös
	
	velocity.y -= painovoimaylös.y * painovoima * delta
	
	# Minne ollaan menossa
	var input_suunta = Input.get_vector("vasen", "oikea", "eteen", "taakse")
	var suunta = (transform.basis * Vector3(input_suunta.x, 0, input_suunta.y)).normalized()
	
	# Liikutus
	if suunta != Vector3.ZERO:
		velocity.x = suunta.x * NOPEUS
		velocity.z = suunta.z * NOPEUS
	else:
		velocity.x = move_toward(velocity.x, 0, NOPEUS)
		velocity.z = move_toward(velocity.z, 0, NOPEUS)
	
	# Hiiren lukitseminen
	if Input.is_action_just_pressed("pause"):
		hiirikiinni = !hiirikiinni
		if hiirikiinni:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Kameran ja liikkeen päivitys
	_käännä_kamera()
	move_and_slide()
	
	# Lattiassa kiinni pitäminen ja oikea asento
	if not is_on_floor():
		apply_floor_snap()
	
	var n = säde.get_collision_normal()
	var suoristus = align_with_y(global_transform, n)
	global_transform = global_transform.interpolate_with(suoristus, 12 * delta)
	
	return

# Asennon korjauksen avustin
func align_with_y(suoristus, uusi_y):
	suoristus.basis.y = uusi_y
	suoristus.basis.x = -suoristus.basis.z.cross(uusi_y)
	suoristus.basis = suoristus.basis.orthonormalized()
	return suoristus

# Kameran ja hahmon kääntäminen
func _käännä_kamera():
	if Input.is_action_pressed("kameraoikea"):
		%Pelaaja.rotate_object_local(Vector3(0,1,0), deg_to_rad(-1.0))
	if Input.is_action_pressed("kameravasen"):
		%Pelaaja.rotate_object_local(Vector3(0,1,0), deg_to_rad(1.0))
