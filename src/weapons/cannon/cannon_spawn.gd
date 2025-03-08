class_name CannonSpawn extends Object

static var cannon_ball = preload("res://src/projectiles/cannon_ball/cannon_ball.tscn")

static func spawn_cannon_ball(proj_owner, ball_speed, global_position, forward_dir, velocity, offset):
		var instance = cannon_ball.instantiate()
		instance.position = global_position + forward_dir * offset
		instance.scale = Vector2(0.5, 0.5)
		instance.apply_force(ball_speed * forward_dir + velocity)
		instance.add_collision_exception_with(proj_owner)
		return instance
