
/*

This file contains a bunch of functions used for player mechanics 

*/

//Start Sprint 

function Sprint(ply, key)
if ply:GetNWInt("Stamina") <= 0 then ply:SetRunSpeed(ply:GetWalkSpeed()) return false end
if ply:Team() == 2 and ply:Alive() and (key == IN_SPEED || ply:KeyDown(IN_SPEED)) and ply:GetNWInt("Stamina") <= 100 then
        timer.Destroy("StaminaRegen")
        ply:SetRunSpeed(320)
        timer.Create( "StaminaDrain", 0.2, 0, function ()
		if ply:GetNWInt("Stamina") <= 2 then --B/c the bottom will set it to 0
		   timer.Destroy("StaminaDrain")
		   ply:SetRunSpeed(ply:GetWalkSpeed())
		   end
		   ply:SetNWInt("Stamina", ply:GetNWInt("Stamina") - 2)
	    end)
	end
end
hook.Add("KeyPress", "Start", Sprint)

function SprintRegen(ply, key)
if ply:Team() == 2 and ply:Alive() and key == IN_SPEED then
        timer.Destroy("StaminaDrain")
        timer.Create("StaminaRegen", 0.5, 0, function()
		if ply:GetNWInt("Stamina") == 99 then --If its 100 it still runs the function and puts it @ 101 
		    timer.Destroy("StaminaRegen")
			end
            ply:SetNWInt("Stamina", ply:GetNWInt("Stamina") + 1)
		end)		
  end
end
hook.Add("KeyRelease", "Start", SprintRegen)

//This is used for testing
function DestroyTimer(ply)
timer.Destroy("StaminaRegen")
timer.Destroy("StaminaDrain")
ply:ChatPrint("Wew")
end
concommand.Add("Destroy_Timer", DestroyTimer)

//end sprint

//Roll 



