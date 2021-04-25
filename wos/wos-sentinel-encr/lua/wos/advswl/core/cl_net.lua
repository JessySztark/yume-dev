--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--







































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}

net.Receive( "wOS.ALCS.SyncForm", function( len, ply )

	local wep = net.ReadEntity()
	if not wep.IsLightsaber then return end
	
	wep.CurForm = net.ReadString( 32 )

end )

net.Receive( "wOS.ALCS.SyncRegistration", function( len, ply )

	wOS = wOS or {}
	wOS.Lightsabers = net.ReadTable()

end )

net.Receive( "wOS.ALCS.OpenFormMenu", function( len, ply )
	local dual = net.ReadBool()
	wOS.ALCS:OpenFormMenu( dual )
end )

net.Receive( "wOS.Lightsaber.SlamTime", function( len, ply )

	local wep = net.ReadEntity()
	if not wep.IsLightsaber then return end
	
	local time = net.ReadInt( 32 )
	
	wep.DevestatorTime = CurTime() + time

end )

net.Receive( "wOS.ALCS.RecievePlayerSeq", function()

	local ply = net.ReadEntity()
	local seq = net.ReadString()


	if not IsValid( ply ) and seq == "-1" then 
		wOS.ALCS.PortalCache[ ply ] = true
		return 
	end

	wOS.ALCS.PortalCache[ ply ] = nil
	
	seq = ply:LookupSequence( seq )
	
	local rate = net.ReadFloat()
	local start = net.ReadFloat()
	if start < 0 || start > 1 then 
		start = 0
	end
	ply:SetCycle( start ) 

	ply.SeqOverride = seq or -1
	if ply.SeqOverride < 0 then
		ply.SeqOverrideRate = nil
	else
		ply.SeqOverrideRate = rate or 1.0
	end
			
end )

net.Receive( "wOS.ALCS.HybridForceSelect", function()

	local wep = LocalPlayer():GetActiveWeapon() 
	if not IsValid( wep ) then return end
	if not wep then return end
	if not wep.IsLightsaber then return end
	
	local tbl = net.ReadTable()
	
	wep.ForcePowers = {}
	for _, power in pairs( tbl ) do
		local data = wep.AvailablePowers[ power ]
		if not data then continue end
		wep.ForcePowers[ #wep.ForcePowers + 1 ] = data
	end

end )

net.Receive( "wOS.ALCS.SendGrips", function()

	local tbl = net.ReadTable()
	wOS.ALCS.LightsaberBase.Grips = wOS.ALCS.LightsaberBase.Grips or {}
	table.Add( wOS.ALCS.LightsaberBase.Grips, tbl )
	
end )

net.Receive( "wOS.ALCS.SendBlades", function()

	local tbl = net.ReadTable()
	wOS.ALCS.LightsaberBase.Blades = wOS.ALCS.LightsaberBase.Blades or {}
	for name, data in pairs( tbl ) do
		wOS.ALCS.LightsaberBase.Blades[ name ] = table.Copy( data )
		if data.EnvelopeMaterial and #data.EnvelopeMaterial > 0 then
			wOS.ALCS.LightsaberBase.Blades[ name ].Laser = Material( data.EnvelopeMaterial )
		end
		if data.InnerMaterial and #data.InnerMaterial > 0 then
			wOS.ALCS.LightsaberBase.Blades[ name ].LaserInner = Material( data.InnerMaterial )
		end
		if data.QuillonEnvelopeMaterial and #data.QuillonEnvelopeMaterial > 0 then
			wOS.ALCS.LightsaberBase.Blades[ name ].QuillonLaser = Material( data.QuillonEnvelopeMaterial )
		end
		if data.QuillonInnerMaterial and #data.QuillonInnerMaterial > 0 then
			wOS.ALCS.LightsaberBase.Blades[ name ].QuillonLaserInner = Material( data.QuillonInnerMaterial )
		end
	end
	
end )