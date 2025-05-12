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
		genital_list += CYBORG_ORGAN_PENIS
		if(has_vagina())
			genital_list += CYBORG_ORGAN_BOTH
	else if(has_vagina())
		genital_list += CYBORG_ORGAN_VAGINA

	var/picked_organ = tgui_input_list(src, "Choose which genitalia to expose/hide", "Expose/Hide genitals", genital_list)

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

/mob/living/silicon/robot/verb/climax_verb()
	set name = "Climax"
	set category = "IC"

	if(!has_status_effect(/datum/status_effect/climax_cooldown))
		if(tgui_alert(usr, "Are you sure you want to cum?", "Climax", list("Yes", "No")) == "Yes")
			if(stat != CONSCIOUS)
				to_chat(usr, span_warning("You can't climax right now..."))
				return
			else
				climax(TRUE)
	else
		to_chat(src, span_warning("You can't cum right now!"))
