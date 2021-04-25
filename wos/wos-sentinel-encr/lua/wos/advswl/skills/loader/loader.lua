--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}

--This order may look completely stupid, and you'd ask why I wouldn't just cluster them all together
--Well, load orders are very important, and this is the best way to control it

if SERVER then
	
	AddCSLuaFile( "wos/advswl/skills/core/sh_core.lua" )
	AddCSLuaFile( "wos/advswl/skills/core/cl_menu_library.lua" )	
	AddCSLuaFile( "wos/advswl/skills/core/cl_classic_ui.lua" )	
	AddCSLuaFile( "wos/advswl/skills/core/cl_new_core.lua" )	
	AddCSLuaFile( "wos/advswl/skills/core/cl_net.lua" )
	
end

if SERVER then

	if wOS.ALCS.Config.Skills.ShouldSkillUseMySQL then
		include( "wos/advswl/skills/wrappers/sv_mysql.lua" )
	else
		include( "wos/advswl/skills/wrappers/sv_data.lua" )
	end
	

	include( "wos/advswl/skills/core/sh_core.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/skills/core/sv_core.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/skills/core/sv_skill_register.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/skills/core/sv_net.lua" )
	wOS.ALCS:ServerInclude( "wos/advswl/skills/core/sv_concommands.lua" )
	

else
	
	include( "wos/advswl/skills/core/sh_core.lua" )	
	include( "wos/advswl/skills/core/cl_menu_library.lua" )	
	include( "wos/advswl/skills/core/cl_new_core.lua" )
	include( "wos/advswl/skills/core/cl_classic_ui.lua" )	
	include( "wos/advswl/skills/core/cl_net.lua" )
	
end