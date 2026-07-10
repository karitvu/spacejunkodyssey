extends CharacterBody3D

@export var NOPEUS = 5.0

var painovoima = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var säde = %PelaajaCast
var xform : Transform3D
@export var KÄÄNTÖNOPEUS = 0.3

var katsomissuunta: Vector2
@onready var kamera = %Kamera
var kamera_sens = 50

var hiirikiinni = false

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y -= painovoima * delta
	
	# Minne ollaan menossa
	var input_suunta = Input.get_vector("vasen", "oikea", "eteen", "taakse")
	var suunta = (transform.basis * Vector3(input_suunta.x, 0, input_suunta.y)).normalized()
	
	# Liikutus
	if suunta:
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
	_käännä_kamera(delta)
	move_and_slide()
	
	# Käännetään lattian mukaisesti
	if is_on_floor():
		käännä_lattialle(säde.get_collision_normal())
	
	
	return

#
func käännä_lattialle(lattianormaali):
	xform = global_transform
	var nyt_ylös = xform.basis.y
	
	var uusi_ylös = lattianormaali
	var uusi_oikea = nyt_ylös.cross(uusi_ylös).normalized()
	var uusi_eteen = uusi_oikea.cross(uusi_ylös).normalized()
	
	xform.basis = Basis(uusi_oikea, uusi_ylös, uusi_eteen)
	
	global_transform = global_transform.interpolate_with(xform, KÄÄNTÖNOPEUS).orthonormalized()

# Kameran kääntäminen
func _input(tapahtuma: InputEvent):
	if tapahtuma is InputEventMouseMotion: katsomissuunta = tapahtuma.relative * 0.01

# Kameran kääntäminen
func _käännä_kamera(delta: float, sens: float = 1.0):
	#var input = Input.get_vector("katso_vasen", "katso_oikea", "katso_alas", "katso_ylös")
	#katsomissuunta += input
	rotation.y -= katsomissuunta.x * kamera_sens * delta
	kamera.rotation.x = clamp(kamera.rotation.x - katsomissuunta.y * kamera_sens * sens * delta, -1.5, 1.5)
	katsomissuunta = Vector2.ZERO
