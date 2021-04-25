--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.ExecSys = wOS.ALCS.ExecSys or {}
wOS.ALCS.ExecSys.Executions = wOS.ALCS.ExecSys.Executions or {}
wOS.ALCS.ExecSys.Whitelists = wOS.ALCS.ExecSys.Whitelists or {}

net.Receive( "wOS.ALCS.ExecSys.SendExecutions", function( len )

	local newtbl = net.ReadTable()

	wOS.ALCS.ExecSys.Executions = wOS.ALCS.ExecSys.Executions or {}
	table.Merge( wOS.ALCS.ExecSys.Executions, newtbl )
	
end )

net.Receive( "wOS.ALCS.ExecSys.Initiate", function( len )

	local execution = net.ReadString()

	local dat = wOS.ALCS.ExecSys.Executions[ execution ]
	if not dat then return end
	
	local attacker = net.ReadEntity()
	if not attacker:IsValid() then return end

	local victim = net.ReadEntity()
	if not victim:IsValid() then return end

	if not dat.CamTable then return end
	if not dat.CamTable[1] then return end

	wOS.ALCS.ExecSys.LastPos = nil
	wOS.ALCS.ExecSys.LastAng = nil

	wOS.ALCS.ExecSys.ExecutionData = {
		endtime = CurTime() + dat.TotalTime,
		attacker = attacker,
		victim = victim,
		stage = 1,
		camdata = dat.CamTable,
		stagetime = CurTime() + dat.CamTable[1].time,
	}
	print( angles )

end )

net.Receive( "wOS.ALCS.ExecSys.SendWhitelists", function( len )

	wOS.ALCS.ExecSys.Whitelists  = net.ReadTable()

end )

