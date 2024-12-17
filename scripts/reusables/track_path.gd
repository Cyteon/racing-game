@tool
extends Path3D

@export var light_count: int = 5:
	set (value):
		light_count = value
		spawn_items()
	get:
		return light_count

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
	var light_point_interval = 0 if light_count == 0 else len(points) / light_count
	
	if $Start and $End:
		$Start.position = points[50] + Vector3(0, 0, 7.389)
		$Start.look_at(points[51], up_vectors[50])
		$Start.rotation_degrees.y += 90
		
		$End.position = points[-50]
		$End.look_at(points[-49], up_vectors[-50])
		$End.position -= end_offset
		$End.rotation += end_rotation_offset
	
	if $Light:
		for child in $Items.get_children():
			child.free()
		
		for i in light_count:
			var point = points[i * light_point_interval]
			var up_vector = up_vectors[i * light_point_interval + 1]
			
			var item_ = $Light.duplicate()
			item_.visible = true
			item_.name = "item_"
			$Items.add_child(item_)
			item_.position = point
			item_.translate(Vector3(0, 0, -4))
			item_.look_at(points[i * light_point_interval + 1], up_vector)


func _on_area_3d_body_entered(body: Node3D) -> void:
	body_entered.emit(body)


func _on_curve_changed() -> void:
	spawn_items()
