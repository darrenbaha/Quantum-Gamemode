AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_meta.lua" )
AddCSLuaFile( "handlers/EXPLevelHandler.lua" )
AddCSLuaFile( "handlers/playersoundHandler.lua")
AddCSLuaFile( "handlers/weaponHandler.lua" )
AddCSLuaFile( "animations.lua" )
AddCSLuaFile( "handlers/playerMechanicsHandler.lua")
AddCSLuaFile( "handlers/itemsHandler.lua")
AddCSLuaFile("inventory.lua")

include("inventory.lua")
include( "handlers/EXPLevelHandler.lua" )
include( "animations.lua" )
include( "handlers/weaponHandler.lua" )
include( "player_meta.lua" )
include( "handlers/playersoundHandler.lua")
include( "shared.lua" )
include( "handlers/playerMechanicsHandler.lua" )

function GM:PlayerInitialSpawn(ply)
   FirstTimeSpawn(ply)   
end

function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

function FirstTimeSpawn(ply)
	umsg.Start("Menu", ply)
	umsg.End()
end

function ReturnToMenu(ply)
    timer.Destroy("StaminaRegen") --Fixed the stamina infinite regen exploit lol 
    ply:KillSilent()
	ply:SetNWInt("Stamina", 100)
	ply:Spawn()
    umsg.Start("Menu", ply)
	umsg.End()
end
concommand.Add("ReturnToMenu", ReturnToMenu)

function GM:PlayerSpawn(ply)
if ply:GetPData("Bits") == nil then
   ply:SetPos(Vector(791.056030, 67.494843, -79.968750))
   ply:SetTeam(TEAM_MENU)
   ply:SetEyeAngles(Angle(7.491884, -176.214981, 0.000000))
   ply:Freeze(true)
   ply:GodEnable(true)
   ply:DrawShadow( false )
   ply:SetMaterial( "models/effects/vol_light001" )
   ply:SetRenderMode( RENDERMODE_TRANSALPHA )
   else
   ply:SetTeam(TEAM_PLAYER)
   ply:SetPos(Vector(-8920.709961, -1831.147705, -12189.717773))
   ply:SetEyeAngles(Angle(3.740004, -62.204124, 0.000000))
           if victim:GetModel() == "models/player/group01/female_01.mdl" then
			    victim.VoiceSet = "female"
		elseif victim:GetModel() == "models/player/group01/female_02.mdl" then
				    victim.VoiceSet = "female"
		elseif victim:GetModel() == "models/player/group01/female_03.mdl" then 
				    victim.VoiceSet = "female"
		elseif victim:GetModel() == "models/player/group01/female_04.mdl" then 
				    victim.VoiceSet = "female"
		elseif victim:GetModel() == "models/player/Group01/Female_06.mdl" then
		            victim.VoiceSet = "female"
		elseif victim:GetModel() == "models/player/group03/female_01.mdl" then 
				    victim.VoiceSet = "female"
		elseif victim:GetModel() == "models/player/group03/female_02.mdl" then
				    victim.VoiceSet = "female"
        elseif victim:GetModel() == "models/player/group03/female_03.mdl" then 
				    victim.VoiceSet = "female"
		elseif victim:GetModel() == "models/player/group03/female_04.mdl" then
		    victim.VoiceSet = "female"	
		elseif victim:GetModel() == "models/player/group03/female_06.mdl" then
		    victim.VoiceSet = "female"
			else
			victim.VoiceSet = "male"
		end
   end
end

concommand.Add("setplayermodel", function(sender, command, args)
        if (not IsValid(sender)) or (not sender:IsConnected()) then return end
 
        local model = tostring(args[1])
        sender:SetModel(model)
		sender:SetColor(Color(0, 0, 0, 0))
end)

concommand.Add("newPlayer", function(sender, command, args)
        if (not IsValid(sender)) or (not sender:IsConnected()) then return end
		
		local PlayerName = tostring(args[1])
		local model = tostring(sender:GetModel())
		
		sender:SetPData("PlayerModel", model)
    	sender:SetupHands()
		//sender:SetPData("Bits", 10)
		//sender:SetPData("Level", 1)
		//sender:SetPData("Exp", 0)
		sender:GodDisable(true)
		sender:Freeze(false)
		sender:ChatPrint("Welcome to Quantum RP ALPHA")
		sender:Give("weapon_fists")
		sender:SetColor(Color(255, 255, 255, 255))
		sender:SetMana(100)
		sender:SetNWInt("Stamina", 100)
        sender:SetCor(1000)
		sender:SetLevel(1)
		sender:DrawShadow( true )
		sender:SetMaterial( "" )
		sender:SetRenderMode( RENDERMODE_NORMAL )
		sender:SetTeam(TEAM_PLAYER)
		//sender:SetPos(Vector(-9003.592773, -1881.524170, -12188.30078))
        if sender:GetModel() == "models/player/group01/female_01.mdl" then
			    sender.VoiceSet = "female"
		elseif sender:GetModel() == "models/player/group01/female_02.mdl" then
				    sender.VoiceSet = "female"
		elseif sender:GetModel() == "models/player/group01/female_03.mdl" then 
				    sender.VoiceSet = "female"
		elseif sender:GetModel() == "models/player/group01/female_04.mdl" then 
				    sender.VoiceSet = "female"
		elseif sender:GetModel() == "models/player/group01/female_06.mdl" then
		            sender.VoiceSet = "female"
		elseif sender:GetModel() == "models/player/group03/female_01.mdl" then 
				    sender.VoiceSet = "female"
		elseif sender:GetModel() == "models/player/group03/female_02.mdl" then
				    sender.VoiceSet = "female"
        elseif sender:GetModel() == "models/player/group03/female_03.mdl" then 
				    sender.VoiceSet = "female"
		elseif sender:GetModel() == "models/player/group03/female_04.mdl" then
		    sender.VoiceSet = "female"	
		elseif sender:GetModel() == "models/player/group03/female_06.mdl" then
		    sender.VoiceSet = "female"
			else
			sender.VoiceSet = "male"
		end
		
end)

function PrintModel(ply)

ply:ChatPrint("[Test] 20 mana taken away")
ply:RemoveMana(10)

end
concommand.Add("quantum_test_mana", PrintModel)
 
function PrintPlayerData(ply)
print("Name : "..ply:GetPData("Name"))
//print("Model : "..ply:GetPData("PlayerModel"))
print("Level : "..ply:GetPData("Level"))
print("Bits : "..ply:GetPData("Bits"))
print("Exp : "..ply:GetPData("Exp"))

end
concommand.Add("quantum_print_Playerdata", PrintPlayerData)

function CreateCharacter(ply)
if ply:HasWeapon("weapon_fists") then 
   
   else
   umsg.Start("PlayerCreation")
   umsg.End()
   
   end

end
concommand.Add("quantum_create_character", CreateCharacter)

function BackToMenu(ply)
if ply:HasWeapon("weapon_fists") then 
   
   else
	umsg.Start("Menu", ply)
	umsg.End()
	
	end

end
concommand.Add("quantum_back_menu", BackToMenu)

function EraseData(ply)
ply:SetPData("Name", nil)
ply:SetPData("Bits", nil)
ply:SetPData("Level", nil)
ply:SetPData("Exp", nil)
ply:SetPData("PlayerModel", nil)
print("Done")
ply:ChatPrint("Your Character Data has been erased!")

end
concommand.Add("quantum_erase_Playerdata", EraseData)

function GM:ShowHelp(ply)
if ply:Team() == 2 and ply:Alive() then

   end
end

function GM:EntityTakeDamage(ent, dmginfo)
        local attacker, inflictor = dmginfo:GetAttacker(), dmginfo:GetInflictor()
		if attacker:IsPlayer() and attacker:Team() == 2 then
		self:DamageCalc(attacker, ent, dmginfo)		
		end

end

function GM:DamageCalc(attacker, victim, dmginfo)
	local dmgpos = dmginfo:GetDamagePosition()
	if dmgpos == vector_origin then dmgpos = victim:NearestPoint(attacker:EyePos()) end
		net.Start("damage")
		if INFDAMAGEFLOATER then
			INFDAMAGEFLOATER = nil
			net.WriteUInt(9999, 16)
		else
			net.WriteUInt(math.ceil(dmginfo:GetDamage()), 16)
		end
		net.WriteVector(dmgpos)
	net.Send(attacker)

end

function Stamina(ply)
print(ply:GetNWInt("Stamina") - 20)

end