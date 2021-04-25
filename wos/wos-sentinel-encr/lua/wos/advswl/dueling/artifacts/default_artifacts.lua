--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS.ALCS.Dueling.Artifact:RegisterArtifact({
	Name = "Max Strength!",
	Description = "A quick power up before combat",
	RarityName = "Legendary",
	RarityColor = Color( 255, 125, 0 ),
	Model = "models/Gibs/HGIBS.mdl",
	DropRequirement = 8,
	OnSpawn = function( ply )
		ply:AddArtifactSkill( "Character Stats", 1, 1 )
	end,
})

wOS.ALCS.Dueling.Artifact:RegisterArtifact({
	Name = "Ravager's Crux",
	Description = "Anger for combat leads to unfocus",
	RarityName = "Legendary",
	RarityColor = Color( 255, 125, 0 ),
	Model = "models/Gibs/HGIBS.mdl",
	DropRequirement = 8,
	OnSpawn = function( ply )
		ply:AddArtifactSkill( "Ravager", 3, 1 )
	end,
})