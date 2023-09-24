extends State
class_name EnemyIdle

@export var enemy: EnemyBase
@export var move_speed := 10.0

var move_direction: Vector2
var wander_time: float
var stop_time: float
var timer: Timer
var stopped: bool

func _ready():
	timer = Timer.new()
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	stop_time = randf_range(1, 2)

func enter():
	wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		if !stopped:
			stopped = true
			timer.start(stop_time)

func Physics_Update(delta: float):
	if enemy and enemy.alive:
		if !stopped:
			enemy.velocity = move_direction * move_speed
			enemy.look_towards(move_direction)
			enemy.play_animation("run")
		else:
			enemy.velocity = Vector2.ZERO
			enemy.play_animation("idle")
			
func _on_timer_timeout():
	stopped = false
	wander()
		
