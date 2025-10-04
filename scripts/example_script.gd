extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Eventbus.connect("on_collectable_pickup", on_pickup)


func on_pickup(bodyName: StringName) -> void:
	print_rich(bodyName, " ", Globals.collectables)
