/datum/status_effect/musk
	id = "musk"
	status_type = STATUS_EFFECT_UNIQUE
	duration = STATUS_EFFECT_PERMANENT
	alert_type = /atom/movable/screen/alert/status_effect/musk
	var/particles/add_particles = /particles/musk

/datum/status_effect/musk/on_apply()
	. = ..()
	owner.add_shared_particles(add_particles)

/datum/status_effect/musk/on_remove()
	owner.remove_shared_particles(add_particles)

// More intense visuale effect
/datum/status_effect/musk/moderate
	add_particles = /particles/musk/moderate

/atom/movable/screen/alert/status_effect/musk
	name = "Musky"
	desc = "You are emanating a rather.. unique.. scent."
	icon_state = "stoned"
