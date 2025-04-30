/mob/living/proc/toggle_musk_effect()
	if(!client?.prefs?.read_preference(/datum/preference/toggle/erp) || !client?.prefs?.read_preference(/datum/preference/toggle/erp/musk))
		return

	var/datum/status_effect/musk/musk_status = has_status_effect(/datum/status_effect/musk)
	if(isnull(musk_status))
		if(musk_intensity)
			apply_status_effect(/datum/status_effect/musk/moderate)
		else
			apply_status_effect(/datum/status_effect/musk)
		to_chat(src, span_notice("You feel a [musk_intensity ? "strongly" : ""] musky scent coming from yourself..."))
		return

	to_chat(src, span_notice("Your musky scent subsides..."))
	if(musk_intensity)
		remove_status_effect(/datum/status_effect/musk/moderate)
	else
		remove_status_effect(/datum/status_effect/musk)

/mob/living/verb/toggle_musk()
	set name = "Toggle Musk"
	set category = "IC"

	toggle_musk_effect()

/mob/living/verb/toggle_musk_intensity()
	set name = "Toggle Musk Intensity"
	set category = "IC"

	if(!client?.prefs?.read_preference(/datum/preference/toggle/erp) || !client?.prefs?.read_preference(/datum/preference/toggle/erp/musk))
		return

	var/datum/status_effect/musk/musk_status = has_status_effect(/datum/status_effect/musk)
	var/has_musk = !isnull(musk_status)
	if(has_musk)
		toggle_musk_effect()
	musk_intensity = !musk_intensity
	if(musk_intensity)
		balloon_alert(src, "musk increased")
	else
		balloon_alert(src, "musk reduced")
	if(has_musk)
		toggle_musk_effect()
