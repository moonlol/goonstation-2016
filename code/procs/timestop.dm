/obj/effect/timefield
	name = "timefield"
	density = 0
	anchored = 1
	opacity = 1
	alpha = 125
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	var/list/immune = list()
	var/duration = 50
	var/freezerange = 5

/obj/effect/timefield/proc/timestop()
	target = get_turf(src)
	new/obj/effect/timefield(src, immune, duration)
	spawn(duration)
		qdel()
