/mob/living
	///Indicates to [/mob/living/verb/toggle_musk()] which status effect to use
	var/musk_intensity = FALSE

/mob/living/Initialize(mapload)
	. = ..()
	if(CONFIG_GET(flag/disable_erp_preferences))
		verbs -= /mob/living/verb/toggle_musk
		verbs -= /mob/living/verb/toggle_musk_intensity
