extends Node2D

export var duree_day = 1
export var color_day = Color("#ffffff")
export var color_night = Color("#9a7bc4")

signal night
signal day


var tick = 0
var length_day = 0
var hours = 0
var nb_day = 0

enum {JOUR, NUIT}
var cycle = JOUR

func _ready():
	length_day = 60 * 60 * duree_day
	
	tick = length_day / 2
	$Player/Light2D.hide()

func _physics_process(delta):
	tick += 1
	day_cycle()

func day_cycle():
	hours = int(tick / (length_day / 24))
	
	if tick > length_day:
		tick = 0
		nb_day += 1
	
	if hours < 7 or hours > 18:
		cycle_test(NUIT)
	else:
		cycle_test(JOUR)
		
	print(str(tick) + "     -     " + str(hours) + " - " + str(cycle))

func cycle_test(new_cycle):
	if cycle != new_cycle:
		cycle = new_cycle
		var twe = Tween.new()
		
		if cycle == NUIT:
			add_child(twe)
			twe.interpolate_property($CanvasModulate, "color", color_day, color_night, 5, Tween.TRANS_SINE, Tween.EASE_IN)
			twe.start()
			yield(twe, 'tween_completed')
			remove_child(twe)
			$Player/Light2D.show()
			emit_signal("night")
			
		else:
			add_child(twe)
			twe.interpolate_property($CanvasModulate, "color", color_night, color_day, 5, Tween.TRANS_SINE, Tween.EASE_IN)
			twe.start()
			yield(twe, 'tween_completed')
			remove_child(twe)
			$Player/Light2D.hide()
			emit_signal("day")























