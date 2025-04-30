// SOURCED FROM:
// 1. https://github.com/LethalStation/NovaSector/pull/53

// Lets cyborgs pick stuff up, and outlines stuff that isn't in their model's kit for easier identification.
// Anything they pick up can be used like normal. Retains all of its functionality. ALL of it. Balance nightmare? Yes
/obj/item/attack_ai(mob/user)
	if(Adjacent(user, src) && !istype(src.loc, /obj/item/robot_model) && iscyborg(user)) // it's not one of our modules, and we're 100% sure we're a cyborg
		var/mob/living/silicon/robot/robor = user

		// determine the appropriate hand index we can use for this, by checking held_items to see what modules are empty
		var/can_pickup = FALSE
		for (var/module_slot in 1 to length(robor.held_items))
			if(!robor.held_items[module_slot])
				robor.active_hand_index = module_slot
				can_pickup = TRUE
				break

		if (!can_pickup)
			balloon_alert(robor, "no modules free to pick up with!")
			return

		if(robor.low_power_mode)
			balloon_alert(robor, "no power: hand actuators disabled!")
			return

		if (robor.is_invalid_module_number(robor.active_hand_index))
			balloon_alert(robor, "module too damaged: seek repairs!")
			return

		if (!attempt_pickup(user))
			robor.select_module(robor.active_hand_index) // set it to active because you know, we probably want to use it
			SET_PLANE_EXPLICIT(src, ABOVE_HUD_PLANE, src) // so we can see the stupid thing on the HUD
			AddComponent(/datum/component/cyborg_hand_item, host = robor) // link up our component for outline + other handling
			robor.hud_used.persistent_inventory_update() // so it shows up on the HUD at all
			robor.observer_screen_update(src, TRUE) // so ghosts see it via observer overlay
		return

	return ..()
