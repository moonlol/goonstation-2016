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
	icon = 'icons/misc/512x512.dmi'
	icon_state = "0,0"
	layer = LATTICE_LAYER
	var/list/frozen_things = list()
	var/list/frozen_mobs = list()
	var/list/frozen_turfs = list()
	New()
		message_admins("object has been spawned")
		world.log << "object spawned"

proc/timestop(setimmune, setduration, setsize)
	var/obj/effect/timefield/newtimefield = new(get_turf(usr))
	newtimefield.immune = setimmune
	newtimefield.duration = setduration
	newtimefield.size = setsize
	message_admins("it spawn")
	spawn(setduration)
		message_admins("delete")
		qdel(newtimefield)


/obj/effect/timefield/proc/freeze_atom(atom/movable/A)
	if(immune[A])
		return
	var/frozen = TRUE
	if(isliving(A))
		freeze_mob(A)
	else if(istype(A, /obj/projectile))
		freeze_projectile(A)
	else
		frozen = FALSE
	if(A.throwing)
		freeze_throwing(A)
		frozen = TRUE
	if(!frozen)
		return

	frozen_things[A] = A.anchored
	A.anchored = true
	reversecolourin(A)

	return


/obj/effect/timefield/proc/unfreeze_all()
	for(var/i in frozen_things)
		unfreeze_atom(i)
	for(var/T in frozen_turfs)
		unfreeze_turf(T)


/obj/effect/timefield/proc/unfreeze_atom(atom/movable/A)
	if(A.throwing)
		unfreeze_throwing(A)
	if(isliving(A))
		unfreeze_mob(A)
	else if(istype(A, /obj/projectile))
		unfreeze_projectile(A)
	reversecolourout(A)
	A.anchored = frozen_things[A]
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
//	dunno

/obj/effect/timefield/proc/unfreeze_mob(mob/living/L)
//	dunno



/obj/effect/timefield/proc/reversecolourin(atom/A)
	A.color = list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0)

/obj/effect/timefield/proc/reversecolourout(atom/A)
	A.color = list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0)



/*
todo:
add onprox thing
add colour shifting
add various freezing and unfreezing effects for mobs/atoms/turfs/projectiles/thrown objects
add the field to freeze upon being created
*/