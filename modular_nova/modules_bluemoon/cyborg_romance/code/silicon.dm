#define AROUSED_ALERT "aroused"
#define AROUSED_SMALL "small"
#define AROUSED_MEDIUM "medium"
#define AROUSED_HIGH "high"
#define AROUSED_MAX "max"

// Shows genital when: arousal >= AROUSAL_LOW
#define CYBORG_ORGAN_AROUSAL 0
// Hides genital at all times
#define CYBORG_ORGAN_HIDDEN 1
// Always shows genital
#define CYBORG_ORGAN_VISIBLE 2

/mob/living/silicon/robot
	var/arousal = 0
	var/pleasure = 0
	var/pain = 0

	var/pain_limit = 0
	var/arousal_status = AROUSAL_NONE

	var/refractory_period

	var/organs_type = CYBORG_ORGAN_BOTH
	var/vagina_visibility = CYBORG_ORGAN_HIDDEN
	var/penis_visibility = CYBORG_ORGAN_HIDDEN

/mob/living/silicon/robot/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/interactable)
	if(CONFIG_GET(flag/disable_erp_preferences))
		verbs -= /mob/living/silicon/robot/verb/climax_verb
		verbs -= /mob/living/silicon/robot/verb/toggle_genitals

/mob/living/silicon/robot/Life(seconds_per_tick, times_fired)
	. = ..()
	if(client?.prefs?.read_preference(/datum/preference/toggle/erp))
		handle_arousal(seconds_per_tick, times_fired)

// Proof of concept for cyborg genitals
//TODO: Genital type, length, girth, and arousal state.
/mob/living/silicon/robot/proc/set_sex(client/player_client)
	if(!player_client.prefs?.read_preference(/datum/preference/toggle/erp) || CONFIG_GET(flag/disable_erp_preferences))
		return

	var/pref_sex = player_client.prefs.read_preference(/datum/preference/choiced/sex_cyborg)
	// Default option simply mirrors main genital prefs of the character
	if(pref_sex == "Default")
		var/has_penis_pref = player_client.prefs.read_preference(/datum/preference/choiced/genital/penis)
		var/has_vagina_pref = player_client.prefs.read_preference(/datum/preference/choiced/genital/vagina)
		if(has_penis_pref)
			if(has_vagina_pref)
				organs_type = CYBORG_ORGAN_BOTH
			else
				organs_type = CYBORG_ORGAN_PENIS
		else if(has_vagina_pref)
			organs_type = CYBORG_ORGAN_VAGINA
	else
		organs_type = pref_sex

/mob/living/silicon/robot/verb/toggle_genitals()
	set category = "IC"
	set name = "Expose/Hide genitals"
	set desc = "Allows you to toggle which genitals should show through plating or not."

	if(stat != CONSCIOUS)
		to_chat(usr, span_warning("You can't toggle genitals visibility right now..."))
		return

	if(organs_type == CYBORG_ORGAN_NONE) //There is nothing to expose
		return

	var/list/genital_list = list()
	if(has_penis())
		genital_list = CYBORG_ORGAN_PENIS
		if(has_vagina())
			genital_list =  CYBORG_ORGAN_BOTH
	else if(has_vagina())
		genital_list =  CYBORG_ORGAN_VAGINA

	var/obj/item/organ/external/genital/picked_organ = tgui_input_list(src, "Choose which genitalia to expose/hide", "Expose/Hide genitals", genital_list)

	if(!picked_organ)
		return

	var/static/list/cyborg_gen_vis_trans = list(
		"Hidden by plating" = CYBORG_ORGAN_HIDDEN,
		"Visible upon arousal" = CYBORG_ORGAN_AROUSAL,
		"Always visible" = CYBORG_ORGAN_VISIBLE,
	)

	var/picked_visibility = tgui_input_list(src, "Choose visibility setting", "Expose/Hide genitals", cyborg_gen_vis_trans)

	if(!picked_visibility)
		return

	if((picked_organ == CYBORG_ORGAN_BOTH) || (picked_organ == CYBORG_ORGAN_PENIS))
		penis_visibility = cyborg_gen_vis_trans[picked_visibility]
	if((picked_organ == CYBORG_ORGAN_BOTH) || (picked_organ == CYBORG_ORGAN_VAGINA))
		vagina_visibility = cyborg_gen_vis_trans[picked_visibility]

	balloon_alert(src, "set to [lowertext(picked_visibility)]")

/// Returns true if the cyborg has an accessible penis for the parameter. Accepts any of the `REQUIRE_GENITAL_` defines.
/mob/living/silicon/robot/proc/has_penis(required_state = REQUIRE_GENITAL_ANY)
	if((organs_type != CYBORG_ORGAN_PENIS) && (organs_type != CYBORG_ORGAN_BOTH))
		return FALSE

	switch(required_state)
		if(REQUIRE_GENITAL_ANY)
			return TRUE
		if(REQUIRE_GENITAL_EXPOSED)
			if(penis_visibility == CYBORG_ORGAN_VISIBLE)
				return TRUE
			if((penis_visibility == CYBORG_ORGAN_AROUSAL) && (arousal >= AROUSAL_LOW))
				return TRUE
		if(REQUIRE_GENITAL_UNEXPOSED)
			if(penis_visibility == CYBORG_ORGAN_HIDDEN)
				return TRUE
			if((penis_visibility == CYBORG_ORGAN_AROUSAL) && (arousal < AROUSAL_LOW))
				return TRUE
		else
			return TRUE

/// Returns true if the cyborg has an accessible vagina for the parameter. Accepts any of the `REQUIRE_GENITAL_` defines.
/mob/living/silicon/robot/proc/has_vagina(required_state = REQUIRE_GENITAL_ANY)
	if((organs_type != CYBORG_ORGAN_VAGINA) && (organs_type != CYBORG_ORGAN_BOTH))
		return FALSE

	switch(required_state)
		if(REQUIRE_GENITAL_ANY)
			return TRUE
		if(REQUIRE_GENITAL_EXPOSED)
			if(vagina_visibility == CYBORG_ORGAN_VISIBLE)
				return TRUE
			if((vagina_visibility == CYBORG_ORGAN_AROUSAL) && (arousal >= AROUSAL_LOW))
				return TRUE
		if(REQUIRE_GENITAL_UNEXPOSED)
			if(vagina_visibility != CYBORG_ORGAN_VISIBLE)
				return TRUE
			if((vagina_visibility == CYBORG_ORGAN_AROUSAL) && (arousal < AROUSAL_LOW))
				return TRUE
		else
			return TRUE

/// Sends an icon to the screen that gives an approximate indication of the mob's arousal.
/mob/living/silicon/robot/proc/throw_arousal_alert(level, atom/movable/screen/alert/aroused/arousal_alert)
	throw_alert(AROUSED_ALERT, /atom/movable/screen/alert/aroused)
	arousal_alert?.icon_state = "arousal_[level]"
	arousal_alert?.update_icon()

/// Sends an icon to the screen that gives an approximate indication of the mob's pain. Looks like spikes/barbed wire.
/mob/living/silicon/robot/proc/overlay_pain(level, atom/movable/screen/alert/aroused/arousal_alert)
	arousal_alert?.cut_overlay(arousal_alert.pain_overlay)
	arousal_alert?.pain_level = level
	arousal_alert?.pain_overlay = arousal_alert.update_pain()
	arousal_alert?.add_overlay(arousal_alert.pain_overlay)
	arousal_alert?.update_overlays()

/// Sends an icon to the screen that gives an approximate indication of the mob's pleasure. Looks like a pink-white border on the arousal alert heart.
/mob/living/silicon/robot/proc/overlay_pleasure(level, atom/movable/screen/alert/aroused/arousal_alert)
	arousal_alert?.cut_overlay(arousal_alert.pleasure_overlay)
	arousal_alert?.pleasure_level = level
	arousal_alert?.pleasure_overlay = arousal_alert.update_pleasure()
	arousal_alert?.add_overlay(arousal_alert.pleasure_overlay)
	arousal_alert?.update_overlays()

/// Handles throwing the arousal alerts to screen.
/mob/living/silicon/robot/proc/handle_arousal(atom/movable/screen/alert/aroused)
	if(!client?.prefs?.read_preference(/datum/preference/toggle/erp))
		return

	var/atom/movable/screen/alert/aroused/arousal_alert = alerts[AROUSED_ALERT]

	var/alert_state
	switch(arousal)
		if(-INFINITY to AROUSAL_MINIMUM_DETECTABLE)
			clear_alert(AROUSED_ALERT, /atom/movable/screen/alert/aroused)
			if(arousal < AROUSAL_MINIMUM)
				arousal = AROUSAL_MINIMUM // To prevent massively negative values that break the lewd system for some.
		if(AROUSAL_MINIMUM_DETECTABLE to AROUSAL_LOW)
			alert_state = AROUSED_SMALL
		if(AROUSAL_LOW to AROUSAL_MEDIUM)
			alert_state = AROUSED_MEDIUM
		if(AROUSAL_HIGH to AROUSAL_AUTO_CLIMAX_THRESHOLD)
			alert_state = AROUSED_HIGH
		if(AROUSAL_AUTO_CLIMAX_THRESHOLD to INFINITY) //to prevent that 101 arousal that can make icon disappear or something.
			alert_state = AROUSED_MAX
	if(alert_state)
		throw_arousal_alert(alert_state, arousal_alert)
		alert_state = null

	switch(pain)
		if(-INFINITY to AROUSAL_MINIMUM_DETECTABLE) //to prevent same thing with pain
			arousal_alert?.cut_overlay(arousal_alert.pain_overlay)
			if(pain < AROUSAL_MINIMUM)
				pain = AROUSAL_MINIMUM // To prevent massively negative values that break the lewd system for some.
		if(AROUSAL_MINIMUM_DETECTABLE to AROUSAL_LOW)
			alert_state = AROUSED_SMALL
		if(AROUSAL_LOW to AROUSAL_MEDIUM)
			alert_state = AROUSED_MEDIUM
		if(AROUSAL_HIGH to AROUSAL_AUTO_CLIMAX_THRESHOLD)
			alert_state = AROUSED_HIGH
		if(AROUSAL_AUTO_CLIMAX_THRESHOLD to INFINITY)
			alert_state = AROUSED_MAX
	if(alert_state)
		overlay_pain(alert_state, arousal_alert)
		alert_state = null

	switch(pleasure)
		if(-INFINITY to AROUSAL_MINIMUM_DETECTABLE) //to prevent same thing with pleasure
			arousal_alert?.cut_overlay(arousal_alert.pleasure_overlay)
			if(pleasure < AROUSAL_MINIMUM)
				pleasure = AROUSAL_MINIMUM // To prevent massively negative values that break the lewd system for some.
		if(AROUSAL_MINIMUM_DETECTABLE to AROUSAL_LOW)
			alert_state = AROUSED_SMALL
		if(AROUSAL_LOW to AROUSAL_MEDIUM)
			alert_state = AROUSED_MEDIUM
		if(AROUSAL_HIGH to AROUSAL_AUTO_CLIMAX_THRESHOLD)
			alert_state = AROUSED_HIGH
		if(AROUSAL_AUTO_CLIMAX_THRESHOLD to INFINITY)
			alert_state = AROUSED_MAX
	if(alert_state)
		overlay_pleasure(alert_state, arousal_alert)

#undef AROUSED_ALERT
#undef AROUSED_SMALL
#undef AROUSED_MEDIUM
#undef AROUSED_HIGH
#undef AROUSED_MAX

#undef CYBORG_ORGAN_AROUSAL
#undef CYBORG_ORGAN_HIDDEN
#undef CYBORG_ORGAN_VISIBLE
