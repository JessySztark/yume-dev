--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}

hook.Add( "PostGamemodeLoaded", "wOS.AddZhromHilts", function()

	if wOS.ALCS.Config.EnableZhromExtension then 
		
		list.Set( "LightsaberModels", "models/dani/dani.mdl", {} )
		list.Set( "LightsaberModels", "models/donation gauntlet/donation gauntlet.mdl", {} )
		list.Set( "LightsaberModels", "models/donation1/donation1.mdl", {} )	
		list.Set( "LightsaberModels", "models/donation2/donation2.mdl", {} )	
		list.Set( "LightsaberModels", "models/donation3/donation3.mdl", {} )
		list.Set( "LightsaberModels", "models/donation4/donation4.mdl", {} )
		list.Set( "LightsaberModels", "models/donation7/donation7.mdl", {} )	
		list.Set( "LightsaberModels", "models/lightsaber/lightsaber.mdl", {} )	
		list.Set( "LightsaberModels", "models/lightsaber2/lightsaber2.mdl", {} )
		list.Set( "LightsaberModels", "models/lightsaber3/lightsaber3.mdl", {} )
		list.Set( "LightsaberModels", "models/lightsaber4/lightsaber4.mdl", {} )	
		list.Set( "LightsaberModels", "models/pike/pike.mdl", {} )		
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_reborn_saber_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_1_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_2_hilt.mdl", {} )	
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_3_hilt.mdl", {} )	
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_4_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_5_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_6_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_7_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_8_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_9_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_dual_1_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_dual_2_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_dual_3_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_dual_4_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/sgg/starwars/weapons/w_saber_dual_5_hilt.mdl", {} )
		list.Set( "LightsaberModels", "models/snake/snake.mdl", {} )
		list.Set( "LightsaberModels", "models/snake2/snake2.mdl", {} )	
		list.Set( "LightsaberModels", "models/training/training.mdl", {} )	
		list.Set( "LightsaberModels", "models/trident/trident.mdl", {} )
		list.Set( "LightsaberModels", "models/donation gauntlet/donation gauntlet.mdl", {} )
		list.Set( "LightsaberModels", "models/donation1/donation1.mdl", {} )	
		list.Set( "LightsaberModels", "models/donation1/donation1.mdl", {} )	
	end
	
	if wOS.ALCS.Config.EnableCloneAdventures then
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/aaylasecura.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/adigalia.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/ahsoka.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/byph.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/compressedcrystal.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/darkforcephase1.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/darkforcephase2.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/darkknight1.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/darkknight2.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/darksaber.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/darksaberancient.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/darthmaul.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/exile.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/felucia1.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/felucia2.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/forked.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/ganodi.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/gungan.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/gungi.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/jocastanu.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/kashyyyk.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/katooni.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/kitfisto.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/lightsideaffiliation.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/luminara.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/petro.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/pulsating.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/pulsatingblue.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/reverseahsoka.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/saeseetiin.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/samurai.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/shaakti.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/sparklingcrystal.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/spiralling.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/talz.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/training.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/trainingbuggy.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/unstable.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/ventress.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/zatt.mdl", {} )
		list.Set( "LightsaberModels", "models/starwars/cwa/lightsabers/zebra.mdl", {} )
		
	end
	
end )