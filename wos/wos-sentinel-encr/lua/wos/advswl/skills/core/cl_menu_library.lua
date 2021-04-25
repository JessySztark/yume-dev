--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2020
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.Skills = wOS.ALCS.Skills or {}
wOS.ALCS.Skills.Camera = wOS.ALCS.Skills.Camera or {}

surface.CreateFont( "wOS.SkillTreeMain", {
	font = "Roboto Cn",
	extended = false,
	size = 32,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "wOS.SkillHelpFont", {
	font = "Roboto Cn",
	extended = false,
	size = 21,
	weight = 600,
	blursize = 0,
	scanlines = 1,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

--[[
	This CharWrap and TextWrap is straight from Falco in DarkRP. 
	There are similar ones on the Lua Users recipe, but you gotta give it to the man for making it good as fuck
	THANKS FALCO!
--]]
local function charWrap(text, pxWidth)
    local total = 0

    text = text:gsub(".", function(char)
        total = total + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if total >= pxWidth then
            total = 0
            return "\n" .. char
        end

        return char
    end)

    return text, total
end

function wOS.ALCS.Skills.TextWrap(text, font, pxWidth)
    local total = 0

    surface.SetFont(font)

    local spaceSize = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                total = 0
            end

            local wordlen = surface.GetTextSize(word)
            total = total + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= pxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
                total = splitPoint
                return splitWord
            elseif total < pxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                total = wordlen - spaceSize
                return '\n' .. string.sub(word, 2)
            end

            total = wordlen
            return '\n' .. word
        end)

    return text
end

wOS.ALCS.Runes = wOS.ALCS.Runes or {}
local letters = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" }
for i=1, #letters do
	wOS.ALCS.Runes[ letters[i] ] = Material( "wos/runes/" .. letters[i] .. ".png", "unlitgeneric" )
end 

local w,h = ScrW(), ScrH()
local pi = math.pi

local wallMat = Material( "wos/debug/debugblack", "unlitgeneric" )
local upButton = Material( "wos/crafting/gui/up.png", "unlitgeneric" )
local downButton = Material( "wos/crafting/gui/down.png", "unlitgeneric" )
local leftButton = Material( "wos/crafting/gui/left.png", "unlitgeneric" )
local rightButton = Material( "wos/crafting/gui/right.png", "unlitgeneric" )
local bufferBar = Material( "wos/crafting/gui/buffer.png", "unlitgeneric" )
local boxTop = Material( "phoenix_storms/metalset_1-2", "unlitgeneric" )

local wireFrame = Material( "trails/plasma" )

local SkillBlock = Material( "wos/advswl/skill_holocron.png", "unlitgeneric" )
local DuelBlock = Material( "wos/advswl/duel_holocron.png", "unlitgeneric" )
local CombatBlock = Material( "wos/advswl/combat_holocron.png", "unlitgeneric" )

local centerpoint = wOS.ALCS.Config.Crafting.CraftingCamLocation
local color_unselected = Color( 0, 0, 0, 100 )
local grad = Material( "gui/gradient_up" )

wOS.ALCS.Skills.CubeModels = wOS.ALCS.Skills.CubeModels or {}

wOS.ALCS.Skills.Camera[ "Overview" ] = { origin = centerpoint - Vector( 45, 0, -30 ), angles = Angle( -15.840, 40.501, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary = wOS.ALCS.Skills.MenuLibrary or {}
wOS.ALCS.Skills.MenuLibrary[ "Overview" ] = function()
	local infopane = tduiw.Create()
	infopane.SizeX = 50
	infopane.SizeY = 25
	infopane.ShouldAcceptInputs = true
	infopane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = -10
		local y = -50
		
		local level = LocalPlayer():GetNW2Int( "wOS.SkillLevel", 0 )
		local xp = LocalPlayer():GetNW2Int( "wOS.SkillExperience", 0 )
		local reqxp = wOS.ALCS.Config.Skills.XPScaleFormula( level )
		local lastxp = 0
		if level > 0 then
			lastxp = wOS.ALCS.Config.Skills.XPScaleFormula( level - 1 )
		end
		local should_vestige = false
		local rat = ( xp - lastxp )/( reqxp - lastxp )
		if level == wOS.ALCS.Config.Skills.SkillMaxLevel or ( wOS.ALCS.Config.Prestige.PrestigeLevel and level >= wOS.ALCS.Config.Prestige.PrestigeLevel ) then
			rat = 1
			should_vestige = true
		end
	
		pan:Text( "COMBAT LEVEL", "wOS.CraftTitles", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

		local points = LocalPlayer():GetNW2Int( "wOS.SkillPoints", 0 )
		
		y = y + hh*0.23
		if points > 0 then
			local rate = math.abs( math.cos( CurTime()*5 ) )
			pan:Text( "SKILL POINTS AVAILABLE!", "wOS.TitleFont", x + ww, y, Color( 255*rate, 255 - 255*rate, 255 - 255*rate, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		end
		
		pan:Mat( grad, x, y, ww*rat, hh*0.12, Color( 0, 88, 173, 175 ) )
		pan:Rect( x, y, ww, hh*0.12, Color( 0,0,0,0 ), color_white )
		
		y = y + hh*0.06
		local text = lastxp
		if level == wOS.ALCS.Config.Skills.SkillMaxLevel then text = "MAX" end
		pan:Text( " " .. text, "wOS.CraftDescriptions", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		text = reqxp
		if level == wOS.ALCS.Config.Skills.SkillMaxLevel then text = "LEVEL" end
		pan:Text( text .. " ", "wOS.CraftDescriptions", x + ww, y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		pan:Text( "|", "wOS.CraftDescriptions", x + ww/2, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		y = y + hh*0.06
		pan:Text( "LEVEL " .. level, "wOS.CraftDescriptions", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		if should_vestige then
			pan:Text( "PRESTIGE AVAILABLE", "wOS.CraftDescriptions", x + ww, y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )		
		end
		
		pan:BlockUseBind()
	end
	infopane:SetUIScale( 20 )
	infopane.Scaling = 0.05
	
	local spos = wOS.ALCS.Skills.Menu.Player:GetPos()
	infopane.CamPos = spos + wOS.ALCS.Skills.Menu.Player:GetRight()*20 + wOS.ALCS.Skills.Menu.Player:GetUp()*30
	infopane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, infopane )			
	
	local sidepane = tduiw.Create()
	sidepane.SizeX = 10
	sidepane.SizeY = 40
	sidepane.LastHover = 0
	sidepane.ShouldAcceptInputs = true
	sidepane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = -65 + ww
		local y = -40
		local bh = hh/7
		pan:Rect( x, y, ww, hh, Color( 25, 25, 25, 25 ), color_white )
		
		local lst = 0
		local image = wOS.ALCS.Runes[ "s" ]
		pan:Mat( image, x, y, ww, bh )		
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Skill-Overview" )
	    elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "SKILL HOLOCRON", "wOS.CraftDescriptions", x + ww*2*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end		
		y = y + bh	
		lst = lst + 1
		
		image = wOS.ALCS.Runes[ "d" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			if not wOS.ALCS.Skills.MenuLibrary[ "Duel-Overview" ] then return end
			wOS.ALCS.Skills:ChangeCamFocus( "Duel-Overview"  )	   
		elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "DUELING HOLOCRON", "wOS.CraftDescriptions", x + ww*1.7*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
		end		
		y = y + bh	
		lst = lst + 1
		
		image = wOS.ALCS.Runes[ "c" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			if not wOS.ALCS.Skills.MenuLibrary[ "Combat-Overview" ] then return end
			wOS.ALCS.Skills:ChangeCamFocus( "Combat-Overview"  )	   
		elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "COMBAT HOLOCRON", "wOS.CraftDescriptions", x + ww*1.4*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end		
		
		y = y + bh	
		lst = lst + 1
		
		image = wOS.ALCS.Runes[ "v" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			if not wOS.ALCS.Skills.MenuLibrary[ "Prestige-Overview" ] then return end
			wOS.ALCS.Skills:ChangeCamFocus( "Prestige-Overview" )	   
		elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			//"VESTIGE HOLOCRON"
			pan:Text( "PRESTIGE HOLOCRON", "wOS.CraftDescriptions", x + ww*1.1*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end		
		
		y = y + bh	
		lst = lst + 1
		
		image = wOS.ALCS.Runes[ "b" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			if not wOS.ALCS.Skills.MenuLibrary[ "Storage-Overview" ] then return end
			wOS.ALCS.Skills:ChangeCamFocus( "Storage-Overview" )	   
		elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "STORAGE HOLOCRON", "wOS.CraftDescriptions", x + ww*1.4*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end				
		y = y + bh	
		lst = lst + 1

		image = wOS.ALCS.Runes[ "t" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			if not wOS.ALCS.Skills.MenuLibrary[ "Trade-Overview" ] then return end
			wOS.ALCS.Skills:ChangeCamFocus( "Trade-Overview" )	   
		elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			//Trade Network
			pan:Text( "TRADE HOLOCRON", "wOS.CraftDescriptions", x + ww*1.7*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end		

		y = y + bh	
		lst = lst + 1
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
	    if _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "CLOSE STATION", "wOS.CraftDescriptions", x + ww*2.1*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end							
		if _jp then
			wOS.ALCS.Skills:CloseSkillsMenu()
		end
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
		
		pan:BlockUseBind()
	end
	sidepane:SetUIScale( 20 )
	sidepane.Scaling = 0.05
	
	sidepane.CamPos = infopane.CamPos
	sidepane.CamAng = infopane.CamAng
	table.insert( wOS.ALCS.Skills.Menu.VGUI, sidepane )	
	
	local backbutt = tduiw.Create()
	backbutt.SizeX = 50
	backbutt.SizeY = 25
	backbutt.ShouldAcceptInputs = true
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 10
		local y = -50
		
		local level = LocalPlayer():GetNW2Int( "wOS.ProficiencyLevel", 0 )
		local xp = LocalPlayer():GetNW2Int( "wOS.ProficiencyExperience", 0 )
		local reqxp = wOS.ALCS.Config.Crafting.SaberXPScaleFormula( level )
		local lastxp = 0
		if level > 0 then
			lastxp = wOS.ALCS.Config.Crafting.SaberXPScaleFormula( level - 1 )
		end

		local rat = ( xp - lastxp )/( reqxp - lastxp )
		if level == wOS.ALCS.Config.Crafting.SaberMaxLevel then
			rat = 1
		end
	
		pan:Text( "PROFICIENCY LEVEL", "wOS.CraftTitles", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		
		y = y + hh*0.23
		
		pan:Mat( grad, x, y, ww*rat, hh*0.12, Color( 173, 12, 0, 175 ) )
		pan:Rect( x, y, ww, hh*0.12, Color( 0,0,0,0 ), color_white )
		
		y = y + hh*0.06
		local text = lastxp
		if level == wOS.ALCS.Config.Skills.SkillMaxLevel then text = "MAX" end
		pan:Text( " " .. text, "wOS.CraftDescriptions", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		text = reqxp
		if level == wOS.ALCS.Config.Skills.SkillMaxLevel then text = "LEVEL" end
		pan:Text( text .. " ", "wOS.CraftDescriptions", x + ww, y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		pan:Text( "|", "wOS.CraftDescriptions", x + ww/2, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		y = y + hh*0.06
		pan:Text( "LEVEL " .. level, "wOS.CraftDescriptions", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 20 )
	backbutt.Scaling = 0.05
	
	backbutt.CamPos = spos - wOS.ALCS.Skills.Menu.Player:GetRight()*65 + wOS.ALCS.Skills.Menu.Player:GetUp()*5 + wOS.ALCS.Skills.Menu.Player:GetForward()*20 
	backbutt.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, -90 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, backbutt )		

	backbutt = tduiw.Create()
	backbutt.SizeX = 50
	backbutt.SizeY = 25
	backbutt.ShouldAcceptInputs = true
	backbutt.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 80
		local y = -20
		local item = wOS.ALCS.Dueling.Spirits[ wOS.ALCS.Dueling.DuelData.DuelSpirit ]
		if not item then return end
		pan:Text( item.DuelTitle, "wOS.CraftTitles", x, y, item.RarityColor or color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
		y = y + hh*0.215
		pan:Text( "    " .. item.TagLine, "wOS.CraftDescriptions", x, y, item.RarityColor or color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
		
		pan:BlockUseBind()
	end
	backbutt:SetUIScale( 20 )
	backbutt.Scaling = 0.05
	
	backbutt.CamPos = spos + wOS.ALCS.Skills.Menu.Player:GetRight()*80 - wOS.ALCS.Skills.Menu.Player:GetForward()*60 + wOS.ALCS.Skills.Menu.Player:GetUp()*8
	backbutt.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 60, -20, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, backbutt )			
	
end

wOS.ALCS.Skills.Camera[ "Skill-Overview" ] = { origin = centerpoint - Vector( 45, -35, -30 ), angles = Angle( 0, 90.501, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Skill-Overview" ] = function()
	wOS.ALCS.Skills.Menu.MinH = nil
	local leftpane = tduiw.Create()
	leftpane.SizeX = 8
	leftpane.SizeY = 35
	leftpane.ShouldAcceptInputs = true
	leftpane.Renders = function( pan )
	
		local ww, hh = pan.SizeX, pan.SizeY	
		local x = -30
		local y = -hh*0.4
		local bh = hh/7
		
		pan:Line( 0, -hh/2, x + ww, y + bh/2 )
		
		local lst = 0
		image = wOS.ALCS.Runes[ "s" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
	    if _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x, y, ww*-3*( 1 - rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "VIEW SKILL TREES", "wOS.TitleFont", x + ww*-2.7*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			pan.LastHover = CurTime() + 0.01
	    end							
		if _jp then
			if wOS.ALCS.Config.Skills.MenuSchema == WOS_ALCS.SKILLMENU.NEWAGE then
				wOS.ALCS.Skills:ChangeCamFocus( "Skill-SelectTree" )
			else
				wOS.ALCS.Skills:OpenClassicTreeMenu()
				wOS.ALCS.Skills.Menu:SetVisible( false )	
			end
		end
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	leftpane:SetUIScale( 10 )
	leftpane.Scaling = 0.025
	
	leftpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( 0, 20, -2 )
	leftpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 30, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, leftpane )
	
	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.ShouldAcceptInputs = true
	frontpane.Renders = function( pan )
		if wOS.ALCS.Skills.ClassicMenu then return end
		local ww, hh = pan.SizeX, pan.SizeY
		
		local x = 0 - ww/2
		local y = 10
		local bh = hh/7
		
		local level = LocalPlayer():GetNW2Int( "wOS.SkillLevel", 0 )
		local xp = LocalPlayer():GetNW2Int( "wOS.SkillExperience", 0 )
		local points = LocalPlayer():GetNW2Int( "wOS.SkillPoints", 0 )
		
		pan:Text( "COMBAT LEVEL " .. level, "wOS.CraftDescriptions", 0, -hh*1.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		pan:Text( xp .. " EXPERIENCE POINTS", "wOS.TitleFont", 0, -hh, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		if points > 0 then
			local rate = math.abs( math.cos( CurTime()*5 ) )
			pan:Text( points .. " UNSPENT SKILL POINTS", "wOS.DescriptionFont", 0, -hh*0.95, Color( 255*rate, 255 - 255*rate, 255 - 255*rate, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		end
		
		pan:Line( 0, -3, 3, 3 )
		pan:Line( 3, 3, 0, 10 )

		local lst = 0
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Overview" )
	    elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end

			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "GO BACK", "wOS.TitleFont", x + ww*2.1*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", -hh*0.7/2, -hh*0.7, hh*0.7, hh*0.7, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 0 ) )
	    if _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Text( "USE THE RUNES TO MANIPULATE YOUR COMBAT SKILLS", "wOS.CraftDescriptions", 0, y + bh*2*( 1.5 + rat ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end		
		lst = lst + 1
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	frontpane.PostRenders = function( pan )
		wOS.ALCS.Skills:CreateCubeMat( pan.CamPos, SkillBlock, nil, 6 )
	end
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.025
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( 0, 20, -2 )
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	
	
	local rightpane = tduiw.Create()
	rightpane.SizeX = 8
	rightpane.SizeY = 35
	rightpane.ShouldAcceptInputs = true
	rightpane.Renders = function( pan )
	
		local ww, hh = pan.SizeX, pan.SizeY	
		local x = 20
		local y = -hh*0.6
		local bh = hh/7
		
		pan:Line( x/2, y + hh*0.15, x, y + bh/2 )
		
		local lst = 0
		image = wOS.ALCS.Runes[ "b" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Skill-ShowArtifacts" )
	    elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "MANAGE ARTIFACTS", "wOS.TitleFont", x + ww*1.4*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		y = y + hh*0.4
		pan:Line( x/2, y - hh*0.05, x, y + bh/2 )
		image = wOS.ALCS.Runes[ "c" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			net.Start( "wOS.SkillTree.ResetAllSkills" ) 
			net.SendToServer() 
	    elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "RESET SKILL POINTS", "wOS.TitleFont", x + ww*1.7*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan:Text( "YOU WILL BE KILLED WHEN YOU PERFORM THIS", "wOS.DescriptionFont", x, y + bh*( 1 + rat ), Color( 255, 0, 0 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	rightpane:SetUIScale( 10 )
	rightpane.Scaling = 0.025
	
	rightpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( 0, 20, -2 )
	rightpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, -30, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, rightpane )
	
end

wOS.ALCS.Skills.Camera[ "Skill-SelectTree" ] = { origin = centerpoint - Vector( 65, -45, -30 ), angles = Angle( 0, 180, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Skill-SelectTree" ] = function()
	wOS.ALCS.Skills.Menu.ModEnabled = false
	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.LeftCount = 1
	frontpane.RightCount = 5	
	frontpane.ShouldAcceptInputs = true
	frontpane.LastScrollSlot = 0
	frontpane.ScrollSlot = 0
	frontpane.Selected = 1
	frontpane.TestSkills = {}
	
	for name, data in pairs( wOS.SkillTrees ) do
		if not wOS.SkillTreeWhitelists[ name ] then
			if data.UserGroups then
				if not table.HasValue( data.UserGroups, LocalPlayer():GetUserGroup() ) then continue end
			end
			if data.JobRestricted then
				local found = false
				for _, job in pairs( data.JobRestricted ) do
					if _G[ job ] == LocalPlayer():Team() then 
						found = true
						break 
					end
				end
				if not found then continue end
			end
		end
		local model = wOS.ALCS.Skills:CreateCubeModel( vector_origin, "wos-alcs-treename-" .. name )
		table.insert( wOS.ALCS.Skills.CubeModels, model )
		table.insert( frontpane.TestSkills, name )
	end
	
	frontpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		
		local x = 0 - ww/2
		local y = 10
		local bh = hh/7

		local tree = pan.TestSkills[ pan.Selected ] or ""
		if wOS.SkillTrees[ tree ] then
			local data = wOS.SkillTrees[ tree ]
			pan:Text( tree, "wOS.CraftTitles", 0, -hh*1.1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan:Text( data.Description, "wOS.CraftDescriptions", 0, -hh*0.9, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )			
		end
		
		local lst = 0
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y + bh*1.2, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y + bh*1.2, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Skill-Overview" )
	    elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y + bh*1.2, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "GO BACK", "wOS.TitleFont", x + ww*2.1*( 1 - rat  ), y + bh*1.2 + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", -hh*0.55/2, -hh*0.2, hh*0.55, hh*0.55, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 0 ) )
	    if _jp then
			wOS.ALCS.Skills.SelectedTree = pan.TestSkills[ pan.Selected ]
			if not wOS.ALCS.Skills.SelectedTree then return end
			wOS.ALCS.Skills:ChangeCamFocus( "Skill-ViewTree" )
		elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Text( "CLICK THE HOLOCRON TO ENTER THE SKILL TREE", "wOS.CraftDescriptions", 0, y + bh*2*( 1.5 + rat ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end		
		lst = lst + 1
		
		pan:Mat( leftButton, x - ww*2, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x - ww*2, y, ww, bh, color_white, color_white )
		if _jp then
			//Keep incrementing it who am I to stop you
			//Your PC will regret it, not me
			pan.ScrollSlot = pan.ScrollSlot - 1
			pan.Selected = math.Round( pan.ScrollSlot % #pan.TestSkills ) + 1
	    elseif _hov then
			local speed = 0.1
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		pan:Mat( rightButton, x + ww*2, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x + ww*2, y, ww, bh, color_white, color_white )
		if _jp then
			//Keep incrementing it who am I to stop you
			//Your PC will regret it, not me
			pan.ScrollSlot = pan.ScrollSlot + 1
			pan.Selected = math.Round( pan.ScrollSlot % #pan.TestSkills ) + 1
	    elseif _hov then
			local speed = 0.1
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	frontpane.PostRenders = function( pan )
		local radius = 7.7
		pan.LastScrollSlot = math.Approach( pan.LastScrollSlot, pan.ScrollSlot, 0.01 )
		local offset = pi*5/10 + pi*2/#pan.TestSkills*pan.LastScrollSlot
		local basesize = 1.3 * ( 1 - 0.04*(#pan.TestSkills/15) )
		for i = 1, #pan.TestSkills do
			local j = i - 1
			local x, y = math.sin( offset - pi*j*2/#pan.TestSkills ), math.cos( offset - pi*j*2/#pan.TestSkills )
			local setpos = pan.CamPos + Vector( radius*x, radius*y, 0 )
			local size = 70/setpos:DistToSqr( wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin )	//Clinically proven to be the number
			if not wOS.ALCS.Skills.CubeModels[i] then continue end
			wOS.ALCS.Skills.CubeModels[i]:SetPos( setpos )
			wOS.ALCS.Skills.CubeModels[i]:SetModelScale( basesize*size )
			if i != pan.Selected then
				wOS.ALCS.Skills.CubeModels[i]:SetAngles( Angle( 0, -45, -180 ) )
			else
				wOS.ALCS.Skills.CubeModels[i]:SetAngles( Angle( 0, ( CurTime() * 50 ) % 360, -180 ) )
			end
			wOS.ALCS.Skills.CubeModels[i]:SetColor( Color( 255, 255, 255 ) )
		end
	end
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.025
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( -20, 0, 0 )
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	
end

wOS.ALCS.Skills.Camera[ "Skill-ViewTree" ] = { origin = centerpoint - Vector( 45, -35, -30 ), angles = Angle( 0, 90.501, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Skill-ViewTree" ] = function()
	wOS.ALCS.Skills.Menu.ModEnabled = true
	local selectpane = tduiw.Create()
	selectpane.Positions = {}
	
	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.ShouldAcceptInputs = true
	frontpane.TreeInfo = {}
	
	local data = wOS.SkillTrees[ wOS.ALCS.Skills.SelectedTree ]
	local forward = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Forward()
	local up = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Up()
	local right = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Right()
	local modelscale = 0.5
	local offsety = 3
	local bpos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*30 - up*7
	local padscale = 8
	
	frontpane.Renders = function( pan )
	
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 0 - ww/2
		local y = 19
		local bh = hh/7
		
		local points = LocalPlayer():GetNW2Int( "wOS.SkillPoints", 0 )
		local offsett = wOS.ALCS.Skills.Menu.AngleMod.y*4

		pan:Text( wOS.ALCS.Skills.SelectedTree, "wOS.CraftDescriptions", 0, -hh*1.3 - offsett, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		pan:Text( data.Description, "wOS.TitleFont", 0, -hh*1.2 - offsett, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )			

		pan:Text( "Available Points: " .. points, "wOS.TitleFont", 0, -hh*1.1 - offsett, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		
		local lst = 0
		local image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y - offsett, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y - offsett, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Skill-SelectTree" )
	    elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y - offsett, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "GO BACK", "wOS.TitleFont", x + ww*2.1*( 1 - rat  ), y + bh/2 - offsett, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end
		lst = lst + 1
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end

	end
	frontpane.PostRenders = function( pan )

		if not pan.FUCKYOU then
			local bottompos = bpos + Vector( 0, 0, 0 )
			local max = 0
			if data.MaxTiers > 6 then
				max = data.MaxTiers
			end
			wOS.ALCS.Skills.Menu.MaxH = offsety * max
			
			// Reset for width
			max = 0
			for tier = 1, data.MaxTiers do
				pan.TreeInfo[ tier ] = {}
				local skilltable = data.Tier[ tier ]
				local offsetx = padscale
				local rescale = false
				local startx = -1*offsetx*( #skilltable - 1 )*0.5
				if #skilltable > max then
					max = #skilltable
				end
				for skill, skilldata in ipairs( skilltable ) do
					local model = wOS.ALCS.Skills:CreateCubeModel( bottompos + right*startx, "wos-alcs-skillname-" .. wOS.ALCS.Skills.SelectedTree .. tier .. skill )
					model:SetModelScale( modelscale )
					model.Skill = skill
					model.Tier = tier
					model.Requirements = skilldata.Requirements
					model.LockOuts = skilldata.LockOuts
					model.DummySkill = skilldata.DummySkill
					model.Data = skilldata
					model.Data.Tree = wOS.ALCS.Skills.SelectedTree
					model.Data.Tier = tier
					model.Data.Skill = skill
					table.insert( wOS.ALCS.Skills.CubeModels, model )
					local vec = bottompos + right*startx
					vec = WorldToLocal( vec, Angle( 0,0,0 ), pan.CamPos, pan.CamAng + Angle( 0, 0, 180 ) )
					table.insert( selectpane.Positions, vec )
					pan.TreeInfo[ tier ][ skill ] = #wOS.ALCS.Skills.CubeModels
					startx = startx + offsetx
				end
				bottompos = bottompos + Vector( 0, 0, offsety )
			end	
			if max < 7 then
				max = 0
			end
			wOS.ALCS.Skills.Menu.MaxW = padscale * 0.5 * max
			pan.FUCKYOU = true
		end

		--Redefining the post render function IN the post render function?
		--You bet your sweet ass I fucking did
		pan.PostRenders = function( pan )
			for i=1, #wOS.ALCS.Skills.CubeModels do
				local model = wOS.ALCS.Skills.CubeModels[i]
				//local nmodel = wOS.ALCS.Skills.CubeModels[i + 1]
				if not model then continue end
				if model.DummySkill then continue end
				if wOS:HasSkillEquipped( wOS.ALCS.Skills.SelectedTree, model.Tier, model.Skill ) then
					model:SetAngles( Angle( 0, ( CurTime() * 50 ) % 360, -180 ) )
				elseif not wOS:CanEquipSkill( wOS.ALCS.Skills.SelectedTree, model.Tier, model.Skill ) then
					model:SetColor( Color( 25, 25, 25 ) )
				else
					model:SetColor( Color( 255, 255, 255 ) )
				end
				
				if model.LockOuts then
					render.SetMaterial( wireFrame )
					for treq, rdata in pairs( model.LockOuts ) do
						for _, sreq in ipairs( rdata ) do
							local pos = pan.TreeInfo[ treq ]
							if not pos then continue end
							pos = pos[ sreq ]
							if not pos then continue end
							local nmodel = wOS.ALCS.Skills.CubeModels[ pos ]
							if not nmodel then continue end
							render.DrawBeam( model:GetPos(), nmodel:GetPos(), 0.3, 0, 0, Color( 255, 0, 0 ) )
						end
					end				
				end
				if not model.Requirements then continue end
				if table.Count( model.Requirements ) < 1 then continue end
				render.SetMaterial( wireFrame )
				for treq, rdata in pairs( model.Requirements ) do
					for _, sreq in ipairs( rdata ) do
						local pos = pan.TreeInfo[ treq ]
						if not pos then continue end
						pos = pos[ sreq ]
						if not pos then continue end
						local nmodel = wOS.ALCS.Skills.CubeModels[ pos ]
						if not nmodel then continue end
						local color = Color( 0, 125, 255 )
						if not wOS:CanEquipSkill( wOS.ALCS.Skills.SelectedTree, treq, sreq ) then
							color = Color( 45, 45, 45 )
						elseif not wOS:HasSkillEquipped( wOS.ALCS.Skills.SelectedTree, treq, sreq ) then
							color = color_white
						end
						render.DrawBeam( model:GetPos(), nmodel:GetPos(), 0.2, 0, 0, color )
					end
				end
			end
		end
		
	end
	
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.025
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + Vector( 0, 20, -2 )
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	

	selectpane.SizeX = 4.5
	selectpane.SizeY = 4.5
	selectpane.ShouldAcceptInputs = true
	selectpane.MaxH = 0
	selectpane.MaxW = 0
	selectpane.Selected = nil
	selectpane.OffsetY = offsety*2.2
	selectpane.Renders = function( pan ) 
		local ww, hh = pan.SizeX, pan.SizeY
		local scale = modelscale*1.8

		ww, hh = ww*scale*1.2, hh*scale*1.2
		
		local x = 0.5*scale
		local y = -hh - pan.OffsetY
		
		for i = 1, #pan.Positions do
			local origin = Vector( 0, 0, 0 )
			if not pan.Positions[i] then continue end
			origin:Set( pan.Positions[i] )
			origin.y = origin.y*(1/pan:GetUIScale())/pan.Scaling
			origin.z = origin.z*(1/pan:GetUIScale())/pan.Scaling

			//pan:Rect( x + origin.y - ww/2, y + origin.z + offset, ww*1.1, hh*1.1, Color( 10, 10, 10, 255 ), color_white )
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x + origin.y - ww/2, y + origin.z, ww, hh, color_white, Color( 0, 0, 0, 0 ) )
			if _jp then
				local model = wOS.ALCS.Skills.CubeModels[i]
				if not model then return end
				if model.DummySkill then return end
				if pan.Selected then return end
				if !wOS:HasSkillEquipped( wOS.ALCS.Skills.SelectedTree, model.Tier, model.Skill ) and wOS:CanEquipSkill( wOS.ALCS.Skills.SelectedTree, model.Tier, model.Skill ) then 
					net.Start( "wOS.SkillTree.ChooseSkill" )
						net.WriteString( wOS.ALCS.Skills.SelectedTree )
						net.WriteInt( model.Tier, 32 )
						net.WriteInt( model.Skill, 32 )
					net.SendToServer()	
				end			
			elseif _hov then
				local speed = 0.1
				if not pan.SlideTimes then 
					pan.SlideTimes = CurTime() + speed
				end
				if pan.LastButt != i then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = i
				end
				local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
				pan.LastHover = CurTime() + 0.01
				local model = wOS.ALCS.Skills.CubeModels[ i ]
				if model then
					wOS.ALCS.Skills.SkillInfoPanel:SetVisible( true )
					wOS.ALCS.Skills.SkillInfoPanel.TimeShow = CurTime() + 0.075
					wOS.ALCS.Skills.SkillInfoPanel.Data = model.Data
				end
			end
		end
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
			frontpane.CurrentHover = ""
			frontpane.CurrentTitle = ""
		end

	end
	
	selectpane:SetUIScale( 10 )
	selectpane.Scaling = 0.05
	
	selectpane.CamPos = bpos - forward*1.5
	selectpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, selectpane )
	
end

wOS.ALCS.Skills.Camera[ "Skill-ShowArtifacts" ] = { origin = centerpoint - Vector( 45, 10, -30 ), angles = Angle( 0, 270, 0.000 ) }
wOS.ALCS.Skills.MenuLibrary[ "Skill-ShowArtifacts" ] = function()
	
	local forward = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Forward()
	local right = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Right()
	local up = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles:Up()
	
	local frontpane = tduiw.Create()
	frontpane.SizeX = 8
	frontpane.SizeY = 35
	frontpane.LeftCount = 1
	frontpane.RightCount = 5	
	frontpane.ShouldAcceptInputs = true
	frontpane.LastScrollSlot = 0
	frontpane.ScrollSlot = 0
	frontpane.Selected = 1
	frontpane.Offset = 0
	
	frontpane.Artifacts = {}
	
	for name, amount in pairs( wOS.ALCS.Dueling.Artifact.Backpack ) do
		if amount < 1 then continue end
		if not wOS.ALCS.Dueling.Artifact.List[ name ] then continue end
		
		table.insert( frontpane.Artifacts, { name = name, amount = amount } )	
	end

	frontpane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local bh = hh/7
		local pady = bh*0.05
		local x = 40 - ww*4
		local y = -18
		local lst = 0
		
		if #pan.Artifacts > 6 then
			pan:Mat( upButton, x - ww*1.1, y, ww, hh*0.25 )
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x - ww*1.1, y, ww, hh*0.25, color_white, color_white )
			if _jp then
				if pan.Offset <= 0 then return end
				pan.Offset = pan.Offset - 1
				surface.PlaySound( "buttons/lightswitch2.wav" )
			elseif _hov then
				local speed = 0.1
				if pan.LastButt != lst then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = lst
				end
				pan.LastHover = CurTime() + 0.01
			end					
			pan:Mat( bufferBar, x - ww*1.1, y + hh*0.3, ww, hh*0.3 )	
			pan:Rect( x - ww*1.1, y + hh*0.3, ww, hh*0.3, Color( 0, 0, 0, 0 ), color_white )			
			pan:Mat( downButton, x - ww*1.1, y + hh*0.65, ww, hh*0.25 )
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x - ww*1.1, y + hh*0.65, ww, hh*0.25, color_white, color_white )			
			if _jp then
				if pan.Offset + 6 >= #pan.Artifacts then return end
				pan.Offset = pan.Offset + 1
				surface.PlaySound( "buttons/lightswitch2.wav" )
			elseif _hov then
				local speed = 0.1
				if pan.LastButt != lst then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = lst
				end
				pan.LastHover = CurTime() + 0.01
			end							
		end
		
		for i = 1, 6 do
			local slot = i + pan.Offset
			if slot > #pan.Artifacts then break end
			local dat = pan.Artifacts[slot]
			local col = color_white
			if wOS.ALCS.Dueling.DuelData.Artifact == dat.name then
				col = Color( 0, 125, 175 )
			end
			pan:Text( dat.name, "wOS.TitleFont", x + ww*0.1, y + bh/2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			if dat.amount > 1 then
				pan:Text( "[ x" .. dat.amount .. " ]", "wOS.TitleFont", x + ww*4 - ww*0.1, y + bh/2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
			
			local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww*4, bh, col, color_white )
			if _jp then
				pan.Selected = slot
			elseif _hov then
				local speed = 0.1
				if pan.LastButt != lst then
					surface.PlaySound( "wos/alcs/ui_rollover.wav" )
					pan.LastButt = lst
				end
				pan.LastHover = CurTime() + 0.01
			end	
			lst = lst + 1
			y = y + bh + pady			
		end
		
		if #pan.Artifacts < 1 then
			pan:Rect( x, y, ww*4, bh*6 + pady*5, Color( 0, 0, 0, 0 ), color_white )
			pan:Text( "NO ARTIFACTS AVAILABLE", "wOS.TitleFont", x + ww*2, y + bh*3 + pady*2.5, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		end
		
		y = -18 + bh*6 + pady*6	
		
		image = wOS.ALCS.Runes[ "x" ]
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			wOS.ALCS.Skills:ChangeCamFocus( "Skill-Overview" )
	    elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, ww*( 3 - 3*rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "GO BACK", "wOS.TitleFont", x + ww*2.1*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end							
		lst = lst + 1
		
		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
	
	end
	frontpane:SetUIScale( 10 )
	frontpane.Scaling = 0.025
	
	frontpane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*15
	frontpane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, -27, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, frontpane )
	
	local infopane = tduiw.Create()
	infopane.SizeX = 90
	infopane.SizeY = 35
	infopane.LeftCount = 1
	infopane.RightCount = 5	
	infopane.ShouldAcceptInputs = true
	infopane.Renders = function( pan )
		local ww, hh = pan.SizeX, pan.SizeY
		local x = 0
		local y = -hh*8
		local bh = hh*1.5
		local artifact = frontpane.Artifacts[ frontpane.Selected ]
		if not artifact then return end
		local dat = wOS.ALCS.Dueling.Artifact.List[ artifact.name ]
		if not dat then return end
		pan:Text( dat.Name, "wOS.CraftDescriptions", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		pan:Text( dat.Description or "An unknown artifact", "wOS.TitleFont", x, y + hh*0.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )								
		pan:Text( dat.RarityName or "Common", "wOS.TitleFont", x, y + hh*1.8, dat.RarityColor or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )				
		
		y = hh*4
		local size = ww*4
		x = -size/2
		local lst = 0
		local image = wOS.ALCS.Runes[ "e" ]
		pan:Rect( x, y, ww, bh, Color( 10, 10, 10, 255 ), Color( 0, 0, 0, 0 ) )
		pan:Mat( image, x, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x, y, ww, bh, color_white, color_white )
		if _jp then
			net.Start( "wOS.ALCS.Dueling.SelectArtifact" )
				net.WriteString( dat.Name )
			net.SendToServer()
		elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + ww, y, size*0.5*( 1 - rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "Equip", "wOS.TitleFont", x + size*0.5*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan.LastHover = CurTime() + 0.01
	    end
		lst = lst + 1

		image = wOS.ALCS.Runes[ "c" ]
		pan:Rect( x + size - ww, y, ww, bh, Color( 10, 10, 10, 255 ), Color( 0, 0, 0, 0 ) )
		pan:Mat( image, x + size - ww, y, ww, bh )	
		local _jp, _pr, _hov = pan:Button( "", "wOS.TitleFont", x + size - ww, y, ww, bh, color_white, color_white )
		if _jp then
			net.Start( "wOS.ALCS.Dueling.ConsolidateArtifact" )
				net.WriteString( dat.Name )
			net.SendToServer()
		elseif _hov then
			local speed = 0.1
			if not pan.SlideTimes then 
				pan.SlideTimes = CurTime() + speed
				surface.PlaySound( "wos/alcs/ui_slideout.wav" )
			end
			if pan.LastButt != lst then
				surface.PlaySound( "wos/alcs/ui_rollover.wav" )
				pan.LastButt = lst
			end
			local rat = math.Clamp( pan.SlideTimes - CurTime(), 0, speed )/speed
			pan:Rect( x + size - ww, y, -1*size*0.5*( 1 - rat  ), bh, Color( 10, 10, 10, 255 ), color_white )
			pan:Text( "Consolidate", "wOS.TitleFont", x + size - size*0.5*( 1 - rat  ), y + bh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			pan:Text( "REMOVES " .. dat.DropRequirement .. " ARTIFACT SHARDS", "wOS.DescriptionFont", x + size - size*0.5, y + bh*1.1*( 1 + rat ), Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			pan.LastHover = CurTime() + 0.01
	    end
		lst = lst + 1	

		if pan.SlideTimes and pan.LastHover < CurTime() then
			pan.SlideTimes	= nil
			pan.LastButt = nil
		end
		
	end
	infopane.CamPos = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].origin + forward*70 - right*30
	infopane.CamAng = wOS.ALCS.Skills.Camera[ wOS.ALCS.Skills.CamFocus ].angles + Angle( 0, 0, 0 )
	table.insert( wOS.ALCS.Skills.Menu.VGUI, infopane )
	
	wOS.ALCS.Skills.CubeModels[1] = ClientsideModel( "models/props_lab/huladoll.mdl" )
	wOS.ALCS.Skills.CubeModels[1]:SetPos( frontpane.CamPos + forward*80 - up*5 - right*40 )
	frontpane.PostRenders = function( pan )
		local model = "models/props_lab/huladoll.mdl"
		if pan.Artifacts[ pan.Selected ] then
			local name = pan.Artifacts[ pan.Selected ].name
			if name then
				local item = wOS.ALCS.Dueling.Artifact.List[ name ]
				if item then
					if item.Model then
						model = item.Model
					end
				end
			end
		end
		local display = wOS.ALCS.Skills.CubeModels[1]
		if not IsValid( display ) then return end
		if display:GetModel() != model then
			display:SetModel( model )
		end
		local ang = display:GetAngles()
		ang:RotateAroundAxis( ang:Up(), CurTime()/10000 )
		display:SetAngles( ang )
	end
	
end