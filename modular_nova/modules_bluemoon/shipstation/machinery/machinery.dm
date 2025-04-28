/obj/machinery/power/smes/super/full/shipstation
	input_level = 120 KILO WATTS
	output_level = 90 KILO WATTS

/obj/machinery/power/smes/super/full/marinastation
	input_level = 600 KILO WATTS
	output_level = 600 KILO WATTS
	input_level_max = 600 KILO WATTS
	output_level_max = 600 KILO WATTS


/obj/machinery/computer/shuttle/shipstation
	name = "NTSS 'Blue Moon' Shuttle Console"
	desc = "Used to control the NTSS 'Blue Moon'."
	circuit = /obj/item/circuitboard/computer/shipstation
	shuttleId = "station"
	possible_destinations = "whiteship_away;whiteship_home;whiteship_z4;whiteship_lavaland;station_custom"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/item/circuitboard/computer/shipstation
	name = "NTSS 'Blue Moon' Control Console (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/shipstation

/obj/machinery/computer/camera_advanced/shuttle_docker/shipstation
	name = "NTSS 'Blue Moon' Navigation Computer"
	desc = "Used to designate a precise transit location for the NTSS 'Blue Moon'."
	shuttleId = "station"
	lock_override = NONE
	shuttlePortId = "station_custom"
	jump_to_ports = list(
		"whiteship_away" = 1,
		"whiteship_home" = 1,
		"whiteship_lavaland" = 1,
		"whiteship_z4" = 1,
	)
	view_range = 15
	designate_time = 5 SECONDS
	x_offset = 9
	y_offset = 9
	dir = 8
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
