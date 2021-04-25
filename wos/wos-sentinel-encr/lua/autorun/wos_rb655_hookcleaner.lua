
--Thank you based robotboy

hook.Add( "InitPostEntity", "wOS.ALCS.UnfuckRubat", function()
	hook.Remove( "PlayerBindPress", "rb655_sabers_force" )
	hook.Remove("EntityTakeDamage", "rb655_lightsaber_kill_snd" )
	hook.Remove( "PlayerDeath", "rb655_lightsaber_kill_snd_ply" )
	hook.Remove( "OnNPCKilled", "rb655_lightsaber_kill_snd_npc" )
	hook.Remove("PostPlayerDraw", "rb655_lightsaber")
	hook.Remove( "Think", "rb655_lightsaber_ugly_fixes")
	hook.Remove( "GetFallDamage", "rb655_lightsaber_no_fall_damage")
	hook.Remove( "CreateMove", "rb655_lightsaber_no_fall_damage" )
	hook.Remove( "EntityTakeDamage", "rb655_sabers_armor" )
	hook.Remove( "PlayerSpawnedNPC", "rb655_lightsaber_npc_sync" )
	hook.Remove( "PlayerSpawnedSWEP", "rb655_lightsaber_swep_sync")
	hook.Remove( "CalcView", "111!!!_rb655_lightsaber_3rdperson" )
	hook.Remove( "PlayerBindPress", "rb655_sabers_force" )
	function rb655_IsLightsaber() return false end
end )

function rb655_IsLightsaber() return false end