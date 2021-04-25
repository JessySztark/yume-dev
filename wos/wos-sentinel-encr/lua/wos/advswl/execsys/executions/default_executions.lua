--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS.ALCS.ExecSys:RegisterExecution({
	Name = "Force Crush",
	Description = "Shatter their very soul",
	Milestone = {
		Wins = 50,
		Losses = 0,
		Total = 50,
	},
	RarityName = "Legendary",
	RarityColor = Color( 255, 125, 0 ),
	TotalTime = 5,
	PreviewSequence = "wos_cast_choke",
	PreviewFrame = 0.5,
	CamTable = {
		[1] = {
			target = WOS_ALCS.EXECUTE.ATTACKER,
			time = 2,
			OffsetPos = Vector( -80, -30, 30 ),
			OffsetAng = Angle( -10, -30, 0 ),
		},
		[2] = {
			target = WOS_ALCS.EXECUTE.ATTACKER,
			time = 3,
			OffsetPos = Vector( -80, 160, 120 ),
			OffsetAng = Angle( 10, -135, 0 ),
		},
	},
	OnStart = function( attacker, victim )
		victim:SetExecuted( true )
		attacker:SetExecuted( true )
		local angles = attacker:GetAngles()
		angles.p = 0
		angles.r = 0
		victim:SetPos( attacker:GetPos() + angles:Forward()*100 + vector_up*40 )
		attacker:SetSequenceOverride( "wos_cast_choke", 0 )
		victim:SetSequenceOverride( "wos_force_crush" )
		attacker:SetEyeAngles( ( victim:GetPos() - attacker:GetPos() ):Angle() )
		victim:SetEyeAngles( ( attacker:GetPos() - victim:GetPos() ):Angle() )
	end,
	OnFinale = function( attacker, victim )
		if IsValid( victim ) then
			wOS.ALCS.ExecSys:GibPlayer( victim, attacker )
		end
	end,
	OnFinish = function( attacker, victim )

	end,
})

wOS.ALCS.ExecSys:RegisterExecution({
	Name = "Fighting Chance",
	Description = "Better luck next time!",
	Milestone = {
		Wins = 25,
		Losses = 0,
		Total = 50,
	},
	RarityName = "Rare",
	RarityColor = Color( 0, 0, 175 ),
	TotalTime = 2.7,
	PreviewSequence = "phalanx_h_s1_charge",
	PreviewFrame = 0.5,
	CamTable = {
		[1] = {
			target = WOS_ALCS.EXECUTE.ATTACKER,
			time = 1.5,
			OffsetPos = Vector( -80, 80, 40 ),
			OffsetAng = Angle( 0, -120, 0 ),
		},
		[2] = {
			target = WOS_ALCS.EXECUTE.ATTACKER,
			time = 1.5,
			OffsetPos = Vector( 0, 150, 30 ),
			OffsetAng = Angle( 0, -180, 0 ),
		},
	},
	OnStart = function( attacker, victim )
		victim:SetExecuted( true )
		attacker:SetExecuted( true )
		local angles = attacker:GetAngles()
		angles.p = 0
		angles.r = 0
		victim:SetPos( attacker:GetPos() + angles:Forward()*65 )
		attacker:SetSequenceOverride( "judge_h_s1_t2", 6, 0.7 )
		victim:SetSequenceOverride( "judge_h_s2_charge", 6 )
		attacker:SetEyeAngles( ( victim:GetPos() - attacker:GetPos() ):Angle() )
		victim:SetEyeAngles( ( attacker:GetPos() - victim:GetPos() ):Angle() )
	end,
	OnFinale = function( attacker, victim )
		if IsValid( victim ) then
			victim:SetSequenceOverride( "vanguard_b_s1_t3", 6 )
			timer.Simple( 0.3, function()
				if not IsValid( victim ) then return end
				wOS.ALCS.ExecSys:SlicePlayer( victim, attacker, 90 )
			end )
		end
		if IsValid( attacker ) then
			attacker:SetSequenceOverride( "flourish_bow_basic" )
		end
	end,
	OnFinish = function( attacker, victim )

	end,
})

wOS.ALCS.ExecSys:RegisterExecution({
	Name = "Head Splitter",
	Description = "Two is better than one",
	Milestone = {
		Wins = 75,
		Losses = 0,
		Total = 50,
	},
	RarityName = "Epic",
	RarityColor = Color( 175, 0, 175 ),
	PreviewSequence = "h_reaction_upper",
	PreviewFrame = 0.5,
	TotalTime = 2.1,
	CamTable = {
		[1] = {
			target = WOS_ALCS.EXECUTE.ATTACKER,
			time = 0.7,
			OffsetPos = Vector( 80, 80, 40 ),
			OffsetAng = Angle( 0, 135, 0 ),
		},
		[2] = {
			target = WOS_ALCS.EXECUTE.ATTACKER,
			time = 2.7,
			OffsetPos = Vector( 0, 150, 30 ),
			OffsetAng = Angle( 0, 180, 0 ),
		},
	},
	OnStart = function( attacker, victim )
		victim:SetExecuted( true )
		attacker:SetExecuted( true )
		local angles = attacker:GetAngles()
		angles.p = 0
		angles.r = 0
		victim:SetPos( attacker:GetPos() + angles:Forward()*65 )
		attacker:SetSequenceOverride( "judge_h_s3_t3", 6, 0.5 )
		victim:SetSequenceOverride( "r_reaction_upper", 6 )
		attacker:SetEyeAngles( ( victim:GetPos() - attacker:GetPos() ):Angle() )
		victim:SetEyeAngles( ( attacker:GetPos() - victim:GetPos() ):Angle() )
	end,
	OnFinale = function( attacker, victim )
		if IsValid( victim ) then
			wOS.ALCS.ExecSys:SlicePlayer( victim, attacker, 180 )
		end
	end,
	OnFinish = function( attacker, victim )
	
	end,
})

wOS.ALCS.ExecSys:RegisterExecution({
	Name = "Force Blast",
	Description = "The power of concentrated energy",
	Milestone = {
		Wins = 100,
		Losses = 0,
		Total = 50,
	},
	RarityName = "Epic",
	RarityColor = Color( 175, 0, 175 ),
	PreviewSequence = "wos_jedi_forceblast",
	PreviewFrame = 0.82,
	TotalTime = 2.25,
	CamTable = {
		[1] = {
			target = WOS_ALCS.EXECUTE.ATTACKER,
			time = 0.7,
			OffsetPos = Vector( 80, 80, 40 ),
			OffsetAng = Angle( 0, 135, 0 ),
		},
		[2] = {
			target = WOS_ALCS.EXECUTE.ATTACKER,
			time = 2.7,
			OffsetPos = Vector( 0, 150, 30 ),
			OffsetAng = Angle( 0, 180, 0 ),
		},
	},
	OnStart = function( attacker, victim )
		victim:SetExecuted( true )
		attacker:SetExecuted( true )
		local angles = attacker:GetAngles()
		angles.p = 0
		angles.r = 0
		victim:SetPos( attacker:GetPos() + angles:Forward()*65 )
		attacker:SetSequenceOverride( "wos_jedi_forceblast", 6 )
		victim:SetSequenceOverride( "h_reaction_lower_right", 6, 0.1 )
		attacker:SetEyeAngles( ( victim:GetPos() - attacker:GetPos() ):Angle() )
		victim:SetEyeAngles( ( attacker:GetPos() - victim:GetPos() ):Angle() )
	end,
	OnFinale = function( attacker, victim )
		if IsValid( victim ) then
			local ed = EffectData()
			ed:SetOrigin( victim:GetPos() + Vector( 0, 0, 45 ) )
			ed:SetRadius( 100 )
			util.Effect( "rb655_force_repulse_out", ed, true, true )
			victim:EmitSound( "lightsaber/force_repulse.wav" )
			wOS.ALCS.ExecSys:GibPlayer( victim, attacker )
		end
	end,
	OnFinish = function( attacker, victim )

	end,
})