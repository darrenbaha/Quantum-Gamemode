 include("itemsHandler.lua")

 
 /*
function HoldType(ply, key)
//Hold type : Fist

local weapon = ply:GetActiveWeapon():GetClass()
if WeaponTable[weapon][1] == "fists" and key == IN_USE then 
   ply:SetLuaAnimation("cp_melee_hold")   
   end
end
hook.Add("KeyPress", "Hold type", HoldType)

function SkillRelease( ply, key )
local weapon = ply:GetActiveWeapon():GetClass()
    if key == IN_USE and WeaponTable[weapon][1] == "fists" then
	ply:StopAllLuaAnimations( 0.1 )
	ply:SetLuaAnimation("cp_melee_release")
	end
end
hook.Add("KeyRelease", "Release", SkillRelease)*/
