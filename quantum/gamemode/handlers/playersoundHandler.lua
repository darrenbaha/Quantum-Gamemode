
//Yeah I stole this from Jetboom, credits to him
VoiceSets = {}

VoiceSets["male"] = {}
VoiceSets["male"]["PainSoundsLight"] = {
Sound("vo/npc/male01/ow01.wav"),
Sound("vo/npc/male01/ow02.wav"),
Sound("vo/npc/male01/pain01.wav"),
Sound("vo/npc/male01/pain02.wav"),
Sound("vo/npc/male01/pain03.wav")
}

VoiceSets["male"]["PainSoundsMed"] = {
Sound("vo/npc/male01/pain04.wav"),
Sound("vo/npc/male01/pain05.wav"),
Sound("vo/npc/male01/pain06.wav")
}

VoiceSets["male"]["PainSoundsHeavy"] = {
Sound("vo/npc/male01/pain07.wav"),
Sound("vo/npc/male01/pain08.wav"),
Sound("vo/npc/male01/pain09.wav")
}

VoiceSets["male"]["DeathSounds"] = {
Sound("vo/npc/male01/no02.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_no01.wav"),
Sound("vo/npc/Barney/ba_no02.wav")
}

-- Female pain / death sounds
VoiceSets["female"] = {}
VoiceSets["female"]["PainSoundsLight"] = {
Sound("vo/npc/female01/pain01.wav"),
Sound("vo/npc/female01/pain02.wav"),
Sound("vo/npc/female01/pain03.wav")
}

VoiceSets["female"]["PainSoundsMed"] = {
Sound("vo/npc/female01/pain04.wav"),
Sound("vo/npc/female01/pain05.wav"),
Sound("vo/npc/female01/pain06.wav")
}

VoiceSets["female"]["PainSoundsHeavy"] = {
Sound("vo/npc/female01/pain07.wav"),
Sound("vo/npc/female01/pain08.wav"),
Sound("vo/npc/female01/pain09.wav")
}

VoiceSets["female"]["DeathSounds"] = {
Sound("vo/npc/female01/no01.wav"),
Sound("vo/npc/female01/ow01.wav"),
Sound("vo/npc/female01/ow02.wav")
}

function GM:PlayerHurt(victim, attacker, healthremaining, damage)
		//yeah...Im a noob.. for some reason the table method didn't work...	
		
		set = VoiceSets[victim.VoiceSet]
		if healthremaining > 68 then
			local snds = set.PainSoundsLight
			victim:EmitSound(snds[math.random(1, #snds)])
		elseif healthremaining > 36 then
			local snds = set.PainSoundsMed
			victim:EmitSound(snds[math.random(1, #snds)])
		else
			local snds = set.PainSoundsHeavy
			victim:EmitSound(snds[math.random(1, #snds)])
		end
     end
	 
function GM:PlayerDeath( victim, inflictor, attacker )

	local snds = VoiceSets[victim.VoiceSet].DeathSounds
	victim:EmitSound(snds[math.random(1, #snds)])
	
end