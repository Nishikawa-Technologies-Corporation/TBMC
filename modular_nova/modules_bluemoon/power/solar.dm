// Bluemoon edit - Add pre-connected variant of solar control computer
/obj/machinery/power/solar_control/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(auto_connect)), 1 MINUTES)

/obj/machinery/power/solar_control/proc/auto_connect()
	search_for_connected()
	if(connected_tracker)
		track = SOLAR_TRACK_AUTO
		connected_tracker.sun_update(SSsun, SSsun.azimuth)
