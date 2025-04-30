#define AUTO_EMOTE_CHANCE 3
#define TOO_MUCH_PAIN_MODIFIER 0.1
#define ITS_PRETTY_HOT_IN_HERE_MODIFIER 0.1
#define BASE_AROUSAL_ADJUSTMENT -0.1
#define BASE_PAIN_AND_PLEASURE_ADJUSTMENT -0.5

/mob/living/silicon/robot/adjust_arousal(arous = 0)
	if(stat >= DEAD || !client?.prefs?.read_preference(/datum/preference/toggle/erp))
		return FALSE

	var/arousal_flag = AROUSAL_NONE
	if(arousal >= AROUSAL_MEDIUM)
		arousal_flag = AROUSAL_FULL
	else if(arousal >= AROUSAL_LOW)
		arousal_flag = AROUSAL_PARTIAL

	if(arousal_status != arousal_flag) // Set organ arousal status
		arousal_status = arousal_flag

	arousal = clamp(arousal + arous, AROUSAL_MINIMUM, AROUSAL_LIMIT)

	if(!has_status_effect(/datum/status_effect/aroused_silicon) && arousal)
		apply_status_effect(/datum/status_effect/aroused_silicon)

	if(!arousal)
		remove_status_effect(/datum/status_effect/aroused_silicon)

/datum/status_effect/aroused_silicon
	id = "aroused_silicon"
	tick_interval = 1 SECONDS
	duration = -1
	alert_type = null

/datum/status_effect/aroused_silicon/tick(seconds_between_ticks)
	if(owner.stat >= DEAD || !owner.client?.prefs?.read_preference(/datum/preference/toggle/erp))
		return

	var/mob/living/silicon/robot/affected_mob = owner
	var/temp_arousal = BASE_AROUSAL_ADJUSTMENT
	var/temp_pleasure = BASE_PAIN_AND_PLEASURE_ADJUSTMENT
	var/temp_pain = BASE_PAIN_AND_PLEASURE_ADJUSTMENT

	if(affected_mob.pain > affected_mob.pain_limit)
		temp_arousal -= TOO_MUCH_PAIN_MODIFIER
	if(affected_mob.arousal >= AROUSAL_MEDIUM)
		if(prob(AUTO_EMOTE_CHANCE))
			affected_mob.emote("blush")
		temp_pleasure += ITS_PRETTY_HOT_IN_HERE_MODIFIER
		//moan
	if(affected_mob.pleasure >= AROUSAL_HIGH && prob(AUTO_EMOTE_CHANCE))
		affected_mob.emote("twitch_s")
		//moan x2

	affected_mob.adjust_arousal(temp_arousal)
	affected_mob.adjust_pleasure(temp_pleasure)
	affected_mob.adjust_pain(temp_pain)

#undef AUTO_EMOTE_CHANCE
#undef TOO_MUCH_PAIN_MODIFIER
#undef ITS_PRETTY_HOT_IN_HERE_MODIFIER
#undef BASE_AROUSAL_ADJUSTMENT
#undef BASE_PAIN_AND_PLEASURE_ADJUSTMENT
