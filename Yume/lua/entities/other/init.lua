AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local adiris = "models/jajoff/sw/zeldris.mdl"
function ENT:Initialize()

	self:SetModel(adiris)
	self:SetHullType(1)
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetMaxYawSpeed(90)
end

function ENT:OnTakeDamage()
	return false
end

function ENT:AcceptInput(Name,Activator,Caller)
	if Name == "Use" and Caller:IsPlayer() then
		net.Start("NPCACT",Caller)
	end
end