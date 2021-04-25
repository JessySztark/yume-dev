--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Dueling = wOS.ALCS.Dueling or {}
wOS.ALCS.Dueling.Artifact = wOS.ALCS.Dueling.Artifact or {}
wOS.ALCS.Dueling.Artifact.List = wOS.ALCS.Dueling.Artifact.List or {}
wOS.ALCS.Dueling.Artifact.Backpack = wOS.ALCS.Dueling.Artifact.Backpack or {}

net.Receive( "wOS.ALCS.Dueling.SendPlayerArtifacts", function( len )

	local newtbl = net.ReadTable()
	wOS.ALCS.Dueling.Artifact.Backpack = wOS.ALCS.Dueling.Artifact.Backpack or {}
	table.Merge( wOS.ALCS.Dueling.Artifact.Backpack, newtbl )
	
end )

net.Receive( "wOS.ALCS.Dueling.SendArtifacts", function( len )

	local newtbl = net.ReadTable()

	wOS.ALCS.Dueling.Artifact.List = wOS.ALCS.Dueling.Artifact.List or {}
	table.Merge( wOS.ALCS.Dueling.Artifact.List, newtbl )
	
end )