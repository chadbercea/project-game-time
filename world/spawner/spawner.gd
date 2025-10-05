extends Node2D

@export var unit: PackedScene
@export var ms: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Timer.wait_time = ms
	%Timer.start()

func _on_timer_timeout() -> void:
	var unit_node = unit.instantiate()
	unit_node.global_position = self.global_position
	if unit_node.has_signal("has_died"):
		unit_node.connect("has_died", on_has_died)
	self.get_parent().add_child(unit_node)
	%Timer.paused = true

func on_has_died() -> void:
	%Timer.paused = false
