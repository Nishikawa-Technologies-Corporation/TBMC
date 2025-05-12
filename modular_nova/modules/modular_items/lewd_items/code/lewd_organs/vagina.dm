/obj/item/organ/genital/vagina
	internal_fluid_datum = /datum/reagent/consumable/femcum

/obj/item/organ/genital/vagina/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	// Bluemoon edit - Size-based fluids
	var/size = 1
	if(DNA.features["body_size"] > 0)
		size = DNA.features["body_size"]
	internal_fluid_maximum = size * 20

// Bluemoon edit - Always-active body fluid regen
/obj/item/organ/genital/vagina/on_mob_insert(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	organ_owner.apply_status_effect(/datum/status_effect/body_fluid_regen/vagina)
// Bluemoon edit - Always-active body fluid regen
/obj/item/organ/genital/vagina/on_mob_remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	organ_owner.remove_status_effect(/datum/status_effect/body_fluid_regen/vagina)
