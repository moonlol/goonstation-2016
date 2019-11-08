/obj/effect/timefield
	name = "timefield"
	desc = "/shrug"
	density = 0
	anchored = 1
	opacity = 1
	alpha = 125
	pixel_x = -256
	pixel_y = -256
	var/immune = list()
	var/duration
	var/size
	icon = 'icons/misc/512x512.dmi'
	icon_state = "0,0"
	layer = LATTICE_LAYER


proc/timestop(setimmune, setduration, setsize)
	var/obj/effect/timefield/newtimefield = new(get_turf(usr))
	newtimefield.immune = setimmune
	newtimefield.duration = setduration
	newtimefield.size = setsize
	newtimefield.opacity = 1
	message_admins("it spawn")
	spawn(setduration)
		message_admins("delete")
		qdel(newtimefield)