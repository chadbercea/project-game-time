extends CharacterBody2D

@export_group("Growth")
@export var texture1: Texture
@export var texture2: Texture
@export var texture3: Texture
@export var texture4: Texture
@export var stage2: int = 15
@export var stage3: int = 40
@export var stage4: int = 80
@export var growth_scale_rate: Curve

@export_group("Movement")
@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.5

@export var jump_force =  -400.0
@export_range(0, 1) var decelerate_on_jump_release = 0.1

func _ready() -> void:
	%BlobCollisionShape.scale = Vector2(1.0, 1.0)
	%BlobSprite.texture = texture1
	Eventbus.on_collectable_pickup.connect(on_collect)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_force
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decelerate_on_jump_release
	
	var speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)

	move_and_slide()

func on_collect(_who) -> void:
	%BlobSprite.scale = scale_blob()
	%BlobCollisionShape.scale = scale_blob()
	%Hitbox.scale = scale_blob()
	
	## The collision gets out of whack because the blog textures are different sizes
	
	if Globals.collectables == stage2: # Cars
		print("stage 2")
		#%BlobSprite.texture = texture2
		jump_force -= 25
		%Hitbox.set_collision_layer_value(3, true) # Enable collision layer for medium
	elif Globals.collectables == stage3: # Buildings
		print("stage 3")
		#%BlobSprite.texture = texture3
		jump_force -= 25
		%Hitbox.set_collision_layer_value(4, true) # Enable collision layer for large
	elif Globals.collectables == stage4: # Meta (waiting on ui)
		print("stage 4")
		#%BlobSprite.texture = texture4
		jump_force -= 25
		%Hitbox.set_collision_layer_value(5, true) # Enable collision layer for meta

func scale_blob() -> Vector2:
	return Vector2(growth_scale_rate.sample(Globals.collectables) + 1,growth_scale_rate.sample(Globals.collectables) + 1)
