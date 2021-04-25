--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--


wOS = wOS or {}
wOS.ALCS.Config.Crafting.CraftingDatabase = wOS.ALCS.Config.Crafting.CraftingDatabase or {}

wOS.ALCS.Config.Crafting.CraftingDatabase.ItemToID = {}
wOS.ALCS.Config.Crafting.CraftingDatabase.IDToItem = {}

function wOS.ALCS.Config.Crafting.CraftingDatabase:UpdateTables()

end

function wOS.ALCS.Config.Crafting.CraftingDatabase:Initialize()

	if not file.Exists( "wos", "DATA" ) then file.CreateDir( "wos" ) end
	if not file.Exists( "wos/advswl", "DATA" ) then file.CreateDir( "wos/advswl" ) end
	if not file.Exists( "wos/advswl/crafting", "DATA" ) then file.CreateDir( "wos/advswl/crafting" ) end
	if not file.Exists( "wos/advswl/crafting/leveling", "DATA" ) then file.CreateDir( "wos/advswl/crafting/leveling" ) end
	if not file.Exists( "wos/advswl/crafting/personal", "DATA" ) then file.CreateDir( "wos/advswl/crafting/personal" ) end
	if not file.Exists( "wos/advswl/crafting/inventory", "DATA" ) then file.CreateDir( "wos/advswl/crafting/inventory" ) end
	if not file.Exists( "wos/advswl/crafting/rawmaterials", "DATA" ) then file.CreateDir( "wos/advswl/crafting/rawmaterials" ) end

end

function wOS.ALCS.Config.Crafting.CraftingDatabase:LoadData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()

	ply.PersonalSaberItems = {}
	ply.PersonalSaber = {}
	ply.SecPersonalSaberItems = {}
	ply.SecPersonalSaber = {}
	ply.SaberInventory = {}	
	ply.RawMaterials = {}
	ply.SaberMiscItems = {}
	ply.SaberMiscFunctions = {}

	ply:SetSaberLevel( 0 )
	ply:SetSaberXP( 0 )
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	for i=1, 5 do
		ply.PersonalSaberItems[ i ] = "Standard"
		ply.SecPersonalSaberItems[ i ] = "Standard"
	end
	
	local read = file.Read( "wos/advswl/crafting/leveling/" .. steam64 .. "_" .. charid .. ".txt", "DATA" )
	if not read then
		read = file.Read( "wos/advswl/crafting/leveling/" .. steam64 .. ".txt", "DATA" )
		if read then
			file.Rename( "wos/advswl/crafting/leveling/" .. steam64 .. ".txt", "wos/advswl/crafting/leveling/" .. steam64 .. "_" .. charid .. ".txt" )
		end
	end
	
	if not read then			
		local data = { Level = 0, Experience = 0 }
		data = util.TableToJSON( data )
		file.Write( "wos/advswl/crafting/leveling/" .. steam64 .. "_" .. charid .. ".txt", data )	
	else
		local readdata = util.JSONToTable( read )
		ply:SetSaberLevel( readdata.Level )
		ply:SetSaberXP( readdata.Experience )
	end
	
	read = file.Read( "wos/advswl/crafting/personal/" .. steam64 .. "_" .. charid .. ".txt", "DATA" )	
	if not read then
		read = file.Read( "wos/advswl/crafting/personal/" .. steam64 .. ".txt", "DATA" )
		if read then
			file.Rename( "wos/advswl/crafting/personal/" .. steam64 .. ".txt", "wos/advswl/crafting/personal/" .. steam64 .. "_" .. charid .. ".txt" )
		end
	end
	
	if not read then 
		local data = { Primary = {}, Secondary = {}, MiscItems = {} }
		for i=1, 5 do
			data.Primary[ i ] = "Standard"
			data.Secondary[ i ] = "Standard"
		end
		data = util.TableToJSON( data )
		file.Write( "wos/advswl/crafting/personal/" .. steam64 .. "_" .. charid .. ".txt", data )
	else
		local items = util.JSONToTable( read )
		for typ, item in pairs( items.Primary ) do
			local idata = wOS:GetItemData( item )
			if not idata then item = "Standard" end
			ply.PersonalSaberItems[ typ ] = item
			ply.PersonalSaber[ item ] = idata
		end
		for typ, item in pairs( items.Secondary ) do
			local idata = wOS:GetItemData( item )
			if not idata then item = "Standard" end
			ply.SecPersonalSaberItems[ typ ] = item
			ply.SecPersonalSaber[ item ] = idata
		end
		for typ, item in pairs( items.MiscItems ) do
			local idata = wOS:GetItemData( item )
			if not idata then continue end
			ply.SaberMiscItems[ typ ] = item
			ply.SaberMiscFunctions[ item ] = idata			
		end
	end
	
	read = file.Read( "wos/advswl/crafting/inventory/" .. steam64 .. "_" .. charid .. ".txt", "DATA" )	
	if not read then
		read = file.Read( "wos/advswl/crafting/inventory/" .. steam64 .. ".txt", "DATA" )
		if read then
			file.Rename( "wos/advswl/crafting/inventory/" .. steam64 .. ".txt", "wos/advswl/crafting/inventory/" .. steam64 .. "_" .. charid .. ".txt" )
		end
	end
	if not read then 
		local data = {}
		for i=1, wOS.ALCS.Config.Crafting.MaxInventorySlots do
			data[ i ] = { Name = "Empty", Amount = 0 }
		end			
		ply.SaberInventory = table.Copy( data )
		data = util.TableToJSON( data )
		file.Write( "wos/advswl/crafting/inventory/" .. steam64 .. "_" .. charid .. ".txt", data )
	else
		local items = util.JSONToTable( read )
		for slot, item in pairs( items ) do
			local name = item
			local amt = 1
			if istable( item ) then
				name = item.Name
				amt = item.Amount or 1
			end
			ply.SaberInventory[ slot ] = { Name = name, Amount = amt }
		end
		if #ply.SaberInventory < wOS.ALCS.Config.Crafting.MaxInventorySlots then
			for i=#ply.SaberInventory, wOS.ALCS.Config.Crafting.MaxInventorySlots do
				ply.SaberInventory[ i ] = { Name = "Empty", Amount = 0 }
			end			
		end
	end
	
	read = file.Read( "wos/advswl/crafting/rawmaterials/" .. steam64 .. "_" .. charid .. ".txt", "DATA" )	
	if not read then
		read = file.Read( "wos/advswl/crafting/rawmaterials/" .. steam64 .. ".txt", "DATA" )
		if read then
			file.Rename( "wos/advswl/crafting/rawmaterials/" .. steam64 .. ".txt", "wos/advswl/crafting/rawmaterials/" .. steam64 .. "_" .. charid .. ".txt" )
		end
	end
	for material, _ in pairs( wOS.RawMaterialList ) do
		ply.RawMaterials[ material ] = 0
	end
	if read then
		local raw = util.JSONToTable( read )
		for item, number in pairs( raw ) do
			if not wOS.RawMaterialList[ item ] then continue end
			ply.RawMaterials[ item ] = number
		end
	end

	wOS:TransmitPersonalSaber( ply )
	
end

function wOS.ALCS.Config.Crafting.CraftingDatabase:SaveData( ply )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()

	if not ply.PersonalSaber then return end
	if not ply.PersonalSaberItems then return end
	if not ply.SaberInventory then return end
	if not ply.RawMaterials then return end
	if not ply.SaberMiscItems then return end
	
	local charid = wOS.ALCS:GetCharacterID( ply ) or 1
	if charid < 1 then return end

	local data = {}
	data.Level = ply:GetSaberLevel()
	data.Experience = ply:GetSaberXP()
	
	data = util.TableToJSON( data )
	file.Write( "wos/advswl/crafting/leveling/" .. steam64 .. "_" .. charid .. ".txt", data )	
	
	local savedata = {}
	savedata.Primary = table.Copy( ply.PersonalSaberItems )
	savedata.Secondary = table.Copy( ply.SecPersonalSaberItems )
	savedata.MiscItems = table.Copy( ply.SaberMiscItems )
	savedata = util.TableToJSON( savedata )
	file.Write( "wos/advswl/crafting/personal/" .. steam64 .. "_" .. charid .. ".txt", savedata )		
	
	local invdata = table.Copy( ply.SaberInventory )
	invdata = util.TableToJSON( invdata )
	file.Write( "wos/advswl/crafting/inventory/" .. steam64 .. "_" .. charid .. ".txt", invdata )		
	
	local rawmats = table.Copy( ply.RawMaterials )
	rawmats = util.TableToJSON( rawmats )
	file.Write( "wos/advswl/crafting/rawmaterials/" .. steam64 .. "_" .. charid .. ".txt", rawmats )			

end

function wOS.ALCS.Config.Crafting.CraftingDatabase:DeleteData( ply, charid )

	if ply:IsBot() then return end
	local steam64 = ply:SteamID64()
	if charid < 1 then return end

	file.Delete( "wos/advswl/crafting/personal/" .. steam64 .. "_" .. charid .. ".txt" )
	file.Delete( "wos/advswl/crafting/inventory/" .. steam64 .. "_" .. charid .. ".txt" )
	file.Delete( "wos/advswl/crafting/leveling/" .. steam64 .. "_" .. charid .. ".txt" )
	file.Delete( "wos/advswl/crafting/rawmaterials/" .. steam64 .. "_" .. charid .. ".txt" )

end


timer.Create( "wOS.Crafting.AutoSave", wOS.ALCS.Config.Crafting.CraftingDatabase.SaveFrequency, 0, function() 
	for _, ply in pairs ( player.GetAll() ) do
		wOS.ALCS.Config.Crafting.CraftingDatabase:SaveData( ply )
	end
end )

hook.Add( "PlayerDisconnected", "wOS.Crafting.ItemSaving", function( ply )
	wOS.ALCS.Config.Crafting.CraftingDatabase:SaveData( ply )
end )

hook.Add("wOS.ALCS.PlayerSaveData", "wOS.ALCS.Crafting.SaveDataForChar", function( ply )
	wOS.ALCS.Config.Crafting.CraftingDatabase:SaveData( ply )
end )  

hook.Add("wOS.ALCS.PlayerLoadData", "wOS.ALCS.Crafting.LoadDataForChar", function( ply )
	wOS.ALCS.Config.Crafting.CraftingDatabase:LoadData( ply )
end )  

hook.Add("wOS.ALCS.PlayerDeleteData", "wOS.ALCS.Crafting.DeleteDataForChar", function( ply, charid )
	wOS.ALCS.Config.Crafting.CraftingDatabase:DeleteData( ply, charid )
end ) 