extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Globals.collectables += 1
	Eventbus.on_collectable_pickup.emit(body.name)
	self.queue_free()
