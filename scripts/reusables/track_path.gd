@tool
extends Path3D

@export var items: Array[PackedScene] = []:
	set (value):
		items = value
		spawn_items()
	get:
		return items

@export var item_counts: Array[int] = []:
	set (value):
		item_counts = value
		spawn_items()
	get:
		return item_counts

@export var end_offset: Vector3 = Vector3(4, 0, 0):
	set (value):
		end_offset = value
		spawn_items()
	get:
		return end_offset

@export var end_rotation_offset: Vector3 = Vector3(0, 0, 0):
	set (value):
		end_rotation_offset = value
		spawn_items()
	get:
		return end_rotation_offset

signal body_entered(body: Node3D)

func _ready() -> void:
	spawn_items()

func spawn_items() -> void:
	var points = curve.get_baked_points()
	var up_vectors = curve.get_baked_up_vectors()
	
	if $Start and $End:
		$Start.position = points[50] + Vector3(0, 0, 7.389)
		$Start.look_at(points[51], up_vectors[50])
		$Start.rotation_degrees.y += 90
		
		$End.position = points[-50]
		$End.look_at(points[-49], up_vectors[-50])
		$End.position -= end_offset
		$End.rotation += end_rotation_offset


func _on_area_3d_body_entered(body: Node3D) -> void:
	body_entered.emit(body)
