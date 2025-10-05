extends Area2D

signal has_died

func _on_body_entered(body: Node2D) -> void:
	Globals.collectables += 1
	Eventbus.on_collectable_pickup.emit(body.name)
	has_died.emit()
	self.queue_free()
