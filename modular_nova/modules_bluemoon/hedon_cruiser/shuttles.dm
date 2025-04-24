/datum/map_template/shuttle/hedon
	port_id = "hedon"
	who_can_purchase = null
	suffix = "cruiser"
	name = "NTDS 'Hedon'"

/obj/docking_port/stationary/hedon
	name = "Refueling Station: Port X"
	shuttle_id = "hedon_home"
	roundstart_template = /datum/map_template/shuttle/hedon
	height = 39
	width = 80
	dwidth = 1
	dheight = 25

/obj/docking_port/mobile/hedon
	callTime = 5 MINUTES
	can_move_docking_ports = TRUE
	shuttle_id = "hedon"
	launch_status = 0
	movement_force = list("KNOCKDOWN"=0,"THROW"=0)
	name = "NTDS 'Hedon'"
	port_direction = EAST
	preferred_direction = EAST
	shuttle_areas = list(
		/area/shuttle/hedon/bar,
		/area/shuttle/hedon/hydro,
		/area/shuttle/hedon/bridge,
		/area/shuttle/hedon/engine,
		/area/shuttle/hedon/fore,
		/area/shuttle/hedon/freezer,
		/area/shuttle/hedon/kitchen,
		/area/shuttle/hedon/midship,
		/area/shuttle/hedon/pool,
		/area/shuttle/hedon/port_bath,
		/area/shuttle/hedon/port_bunks,
		/area/shuttle/hedon/sauna,
		/area/shuttle/hedon/service,
		/area/shuttle/hedon/starboard_bunks,
		/area/shuttle/hedon/starboard_bath,
	)

/area/shuttle/hedon
	name = "NTDS 'Hedon'"
	requires_power = TRUE
	fire_detect = FALSE

/area/shuttle/hedon/bar
	name = "NTDS 'Hedon' Ratskeller"

/area/shuttle/hedon/hydro
	name = "NTDS 'Hedon' Hydroponics Lab"

/area/shuttle/hedon/bridge
	name = "NTDS 'Hedon' Command Bridge"

/area/shuttle/hedon/engine
	name = "NTDS 'Hedon' Engine Compartment"

/area/shuttle/hedon/fore
	name = "NTDS 'Hedon' Forward Compartment"

/area/shuttle/hedon/freezer
	name = "NTDS 'Hedon' Walk-In Freezer"

/area/shuttle/hedon/kitchen
	name = "NTDS 'Hedon' Kitchen"

/area/shuttle/hedon/midship
	name = "NTDS 'Hedon' Midship Corridor"

/area/shuttle/hedon/pool
	name = "NTDS 'Hedon' Swimming Pool"

/area/shuttle/hedon/port_bath
	name = "NTDS 'Hedon' Port Bathroom"

/area/shuttle/hedon/port_bunks
	name = "NTDS 'Hedon' Port Crew Bunks"

/area/shuttle/hedon/sauna
	name = "NTDS 'Hedon' Sauna"

/area/shuttle/hedon/service
	name = "NTDS 'Hedon' Service Hall"

/area/shuttle/hedon/starboard_bunks
	name = "NTDS 'Hedon' Starboard Crew Bunks"

/area/shuttle/hedon/starboard_bath
	name = "NTDS 'Hedon' Starboard Bathroom"
