if SERVER then

	function NPCOTHER(ply)
		cinemaCast()
	end

	util.AddNetworkString("Instructeur")
	util.AddNetworkString("NPCACT")
	resource.AddSingleFile("materials/icon.png")
	player_manager.AddValidModel( "Zeldris", 'adiris' );
	list.Set( "PlayerOptionsModel", "Zeldris", 'adiris' );

	hook.Add("PlayerSay", "MenuPrimaire", function(ply, text) 
		if text == "/menu" then
			cinemaCast()
		end
	end)

	function cinemaCast()
		net.Start("MenuTest") 
		net.Send(ply)
	end

	hook.Add("PlayerSay", "Instructeur", function(ply,text)
		if text == "/inst" then
			local players = {}
            for _, entity in pairs(ents.FindInSphere(ply:GetPos(), 250)) do
                if entity:IsPlayer() then
                    table.insert(players, entity)
                end
            end
			net.Start("Instructeur")
			net.WriteString(ply:Nick())
			net.Send(players)
		end
	end)
	
end

if CLIENT then

	net.Receive("MenuTest", function()
		local liyi = vgui.Create("DFrame")
			liyi:SetSize(ScrW()-200, ScrH()-200)
			liyi:SetPos(100, 100)
			liyi:MakePopup()
			liyi:SetDraggable(true)
			liyi:SetSizable(true)
			liyi:SetMinHeight(100)
			liyi:SetMinWidth(100)
			liyi:SetTitle("Test2")
		local nott = vgui.Create("DButton", liyi)
			nott:SetParent(liyi)
			nott:SetText("Fermer")
			nott:SetPos(200,200)
			nott.DoClick = function()
				liyi:Close()
			end
	end)

	hook.Add("Think", "CinemaOpen", function()
		if input.IsKeyDown(KEY_PAD_PLUS) then
			local rose = vgui.Create("DFrame")
				rose:SetSize(ScrW(), ScrH())
				rose:SetPos(0,0)
				rose:SetDraggable(false)
				rose:SetScreenLock(false)
				rose.Paint = function(s,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
				end

			local arac = vgui.Create("DPanel", rose)
				arac:SetSize(ScrW(), ScrH()/6)
				arac:SetPos(0,0)
				arac.Paint = function(s,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
				end

			local acra = vgui.Create("DPanel", rose)
				acra:SetSize(ScrW(), ScrH()/6)
				acra:SetPos(0,ScrH()-ScrH()/6)
				acra.Paint = function(s,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
				end

			local alme = Material("materials/icon.png")

			local cass = vgui.Create("DImageButton", rose)
				cass:SetImage("materials/icon.png")
				cass:SetSize(30,30)
				cass:SetPos(ScrW()-30,0)
				cass.DoClick = function()
					rose:Remove()
				end

			hook.Add("Think", "CinemaClose", function()
				if input.IsKeyDown(KEY_PAD_MINUS) then
					rose:Remove()
				end
			end)
		end
	end)

	net.Receive("Instructeur", function(len, ply)

		local ara = net.ReadString()
		chat.AddText(
		Color(0,77,124), "[Instructeur] ",
        Color(255, 255, 255), ara .. " cherche un instructeur.")
	end)
end