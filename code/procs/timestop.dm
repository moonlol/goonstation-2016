/obj/effect/timefield
	name = "timefield"
	desc = "/shrug"
	density = 0
	anchored = 1
	opacity = 0
	alpha = 125
	pixel_x = -256
	pixel_y = -256
	var/list/immune = list()
	var/duration
	var/size
	layer = LATTICE_LAYER
	var/list/frozen_things = list()
	var/list/frozen_mobs = list()
	var/list/frozen_turfs = list()
	var/list/old_colors = list()
	New(loc, immune, duration, size)
		..(loc)
		src.immune += immune // see below
		src.duration = duration // see below
		src.size = size //byond be like
		for (var/turf/simulated/S in range(size, src))
			freeze_turf(S)
		for (var/atom/X in range(size, src))
			freeze_atom(X)
		spawn(duration)
			unfreeze_all()
			src.immune -= immune


proc/timestop(setimmune, setduration, setsize)
	var/obj/effect/timefield/newtimefield = new(get_turf(usr), setimmune, setduration, setsize)
	spawn(setduration)
		qdel(newtimefield)


/obj/effect/timefield/proc/freeze_atom(atom/movable/A)
	if(A in immune)
		return
	var/frozen = TRUE
	if(istype(A, /mob/living))
		freeze_mob(A)
	else if(istype(A, /obj/projectile))
		freeze_projectile(A)
	else if(istype(A, /obj/critter))
		freeze_critter(A)
	else if(istype(A, /obj/machinery))
		frozen = TRUE
	else
		frozen = FALSE
	if(A.throwing == 1)
		freeze_throwing(A)
		frozen = TRUE
	if(!frozen)
		return
	old_colors[A] = A.color
	frozen_things["\ref[A]"]= A.anchored
	A.anchored = 1
	reversecolourin(A)
	frozen_things += A
	return


/obj/effect/timefield/proc/unfreeze_all()
	for(var/i in frozen_things)
		unfreeze_atom(i)
	for(var/T in frozen_turfs)
		unfreeze_turf(T)


/obj/effect/timefield/proc/unfreeze_atom(atom/movable/A)
	if(A.throwing == 1)
		unfreeze_throwing(A)
	if(isliving(A))
		unfreeze_mob(A)
	else if(istype(A, /obj/projectile))
		unfreeze_projectile(A)
	else if(istype(A, /obj/critter))
		unfreeze_critter(A)
	reversecolourout(A)
	A.anchored = frozen_things["\ref[A]"]
	frozen_things -= A

/obj/effect/timefield/proc/freeze_throwing(atom/movable/AM)
	AM.throwing_paused = TRUE

/obj/effect/timefield/proc/unfreeze_throwing(atom/movable/AM)
	if(AM)
		AM.throwing_paused = FALSE

/obj/effect/timefield/proc/freeze_turf(turf/T)
	reversecolourin(T)
	frozen_turfs += T

/obj/effect/timefield/proc/unfreeze_turf(turf/T)
	reversecolourout(T)


/obj/effect/timefield/proc/freeze_projectile(obj/projectile/P)
	P.projectile_paused = TRUE

/obj/effect/timefield/proc/unfreeze_projectile(obj/projectile/P)
	P.projectile_paused = FALSE

/obj/effect/timefield/proc/freeze_mob(mob/living/L)
	L.ai_prefrozen = L.ai_active
	L.ai_active = 0
	L.paused = 1

/obj/effect/timefield/proc/unfreeze_mob(mob/living/L)
	L.ai_active = L.ai_prefrozen
	L.paused = 0

/obj/effect/timefield/proc/freeze_critter(obj/critter/C)
	C.paused = 1

/obj/effect/timefield/proc/unfreeze_critter(obj/critter/C)
	C.paused = 0

/obj/effect/timefield/proc/reversecolourin(atom/A)
	A.color = list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0)

/obj/effect/timefield/proc/reversecolourout(atom/A)
	A.color = old_colors[A]



/*
todo:
add onprox thing
add various freezing and unfreezing effects for mobs/atoms/turfs/projectiles/thrown objects
add the field to freeze upon being created
*/

/obj/testthing1
	bound_width = 32
	bound_height = 32
	icon = 'icons/turf/shuttle_blu.dmi'
	icon_state = "wall3"
	anchored = 1
	density = 1
	opacity = 0
/obj/testthing2
	bound_width = 64
	bound_height = 64
	icon = 'icons/turf/shuttle_blu.dmi'
	icon_state = "wall3"
	anchored = 1
	density = 1
	opacity = 0
/obj/testthing3
	bound_width = 96
	bound_height = 96
	icon = 'icons/turf/shuttle_blu.dmi'
	icon_state = "wall3"
	anchored = 1
	density = 0
	opacity = 0
	Crossed(atom/moveable/O)
		message_admins("crossed it")
