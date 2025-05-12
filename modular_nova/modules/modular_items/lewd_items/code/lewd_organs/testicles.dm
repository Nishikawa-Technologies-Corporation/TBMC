/obj/item/organ/genital/testicles
	internal_fluid_datum = /datum/reagent/consumable/cum

/obj/item/organ/genital/testicles/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	var/size = 0.5
	if(DNA.features["balls_size"] > 0)
		size = DNA.features["balls_size"]

	internal_fluid_maximum = size * 20

// Bluemoon edit - Always-active body fluid regen
/obj/item/organ/genital/testicles/on_mob_insert(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	organ_owner.apply_status_effect(/datum/status_effect/body_fluid_regen/testes)
// Bluemoon edit - Always-active body fluid regen
/obj/item/organ/genital/testicles/on_mob_remove(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	organ_owner.remove_status_effect(/datum/status_effect/body_fluid_regen/testes)
