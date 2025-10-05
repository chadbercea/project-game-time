extends Area2D

signal has_died

func _on_area_entered(area: Area2D) -> void:
	Globals.collectables += 1
	Eventbus.on_collectable_pickup.emit(area.name)
	has_died.emit()
	self.queue_free()
