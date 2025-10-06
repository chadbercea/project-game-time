extends Area2D

signal has_died
var direction = 1.0
@export var speed = 100.0

func _ready() -> void:
	direction = pick_direction()

func _physics_process(delta: float) -> void:
	self.get_parent().position.x += speed * delta * direction

func _on_area_entered(area: Area2D) -> void:
	Globals.collectables += 1
	Eventbus.on_collectable_pickup.emit(area.name)
	has_died.emit()
	self.get_parent().queue_free()

func pick_direction() -> float:
	return randf_range(-1.0, 1.0)

func _on_timer_timeout() -> void:
	direction = pick_direction()
