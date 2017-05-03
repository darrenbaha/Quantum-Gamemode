include("weaponHandler.lua")

/*
These are tables for levels, drops, and EXP that monsters give you
Note : If you want an NPC to give EXP you need to define it here
*/

// format : NPCTable[NAME of class]] = {"exp reward"}
// Note : This is case sensitive 

NPCTableEXP = {}
NPCTableEXP["npc_zombie"] = {5}
NPCTableEXP["npc_fastzombie"] = {3}

//Basically what do certain NPC's drop, you can define MANY things here!

//Format : NPCDropTable["NPC CLASS NAME"] = {item chance, "item 2"}
NPCDropTable = {}
NPCDropTable["npc_zombie"] = {}

//This is where you can put how many levels you want
//Note that the first variable is HOW MUCH exp you need in order to achieve this level

Level = {}
Level[2] = {10}
Level[3] = {20}
Level[4] = {30}
Level[5] = {40}
Level[6] = {50}
Level[7] = {60}
Level[8] = {}
Level[9] = {}
Level[10] = {}
Level[11] = {}
Level[12] = {}
Level[13] = {}
Level[14] = {}
Level[15] = {}
Level[16] = {}
Level[17] = {}
Level[18] = {}
Level[19] = {}
Level[20] = {}
/*
Gives EXP based on killing NPC's
*/
function npcEXPreward(npc, attacker, inflictor )
local npc_name = npc:GetClass()

if npc:GetClass(NPCTableEXP[npc_name]) and attacker:IsPlayer() then  
   attacker:AddEXP(NPCTableEXP[npc_name][1])
   attacker:ChatPrint("+"..NPCTableEXP[npc_name][1].." EXP")
   end
end
hook.Add("OnNPCKilled", "Give EXP", npcEXPreward)

/*
Levels up players based on EXP by checking when the NPC is killed
*/
function LevelUpNPC(npc, attacker, inflictor)

if attacker:IsPlayer() and attacker:IsValid() then
local current_level = attacker:GetLevel()
local current_exp = attacker:GetEXP()
        if current_exp >= Level[current_level + 1][1] then 
		    attacker:AddLevel(1)
			attacker:SetEXP(0)
			--Add Skill points
			--Save function
            attacker:ChatPrint("Congratulations! You are now level "..attacker:GetLevel())
			attacker:EmitSound("quantum/levelup.wav")
        end
	end
end
hook.Add("OnNPCKilled", "Level Up", LevelUpNPC)