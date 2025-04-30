/mob/living/silicon/robot
	maxHealth = 250
	health = 250

/mob/living/silicon/New()
	. = ..()
	// Bluemoon edit - Allow cyborgs to switch models
	GRANT_ACTION(/datum/action/cyborg_transform)
	// Bluemoon edit - Allow cyborgs to craft
	AddComponent(/datum/component/personal_crafting)
	// Bluemoon edit - Show cyborg inhand sprites
	AddComponent(/datum/component/basic_inhands)

// Bluemoon edit - Cyborg gender
/// Sets the cyborg's gender and pronouns from preferences. Expects a client.
/mob/living/silicon/proc/set_gender(client/player_client)
	var/pref_gender = player_client.prefs.read_preference(/datum/preference/choiced/gender_cyborg)
	if(pref_gender == "Default")
		gender = player_client.prefs.read_preference(/datum/preference/choiced/gender)
	else
		gender = pref_gender


// SOURCED FROM:
// 1. https://github.com/LethalStation/NovaSector/pull/53

// Lets cyborgs pick stuff up, and outlines stuff that isn't in their model's kit for easier identification.
// Anything they pick up can be used like normal. Retains all of its functionality. ALL of it. Balance nightmare? Yes
/mob/living/silicon/put_in_hand_check(obj/item/I)
	return TRUE // unbelievable, stupendous, excellent, a paragon of coding prowess

/mob/living/silicon/robot/select_module(module_num)
	..()

	var/mod_index = get_selected_module()
	active_hand_index = !mod_index ? 1 : mod_index

/mob/living/silicon/robot/unequip_module_from_slot(obj/item/item_module, module_num)
	// we're dropping an item that we picked up. normally this runtimes, but clearly we don't want that, we just want to drop the stupid item.
	// look this sucks and there's code duplication involved here but it'd be semi-modular otherwise
	if(!(item_module in model.modules))
		dropItemToGround(item_module)

		if(client)
			client.screen -= item_module

		if(module_active == item_module)
			module_active = null

		switch(module_num)
			if(BORG_CHOOSE_MODULE_ONE)
				if(!(disabled_modules & BORG_MODULE_ALL_DISABLED))
					inv1.icon_state = initial(inv1.icon_state)
			if(BORG_CHOOSE_MODULE_TWO)
				if(!(disabled_modules & BORG_MODULE_TWO_DISABLED))
					inv2.icon_state = initial(inv2.icon_state)
			if(BORG_CHOOSE_MODULE_THREE)
				if(!(disabled_modules & BORG_MODULE_THREE_DISABLED))
					inv3.icon_state = initial(inv3.icon_state)

		hud_used.persistent_inventory_update()
		observer_screen_update(item_module, FALSE)
		return

	return ..()

/mob/living/silicon/robot/can_hold_items(obj/item/I)
	return ..()
