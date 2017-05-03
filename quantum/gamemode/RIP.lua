include("exp_settings.lua")

local function PrintAll(msg) for _,v in ipairs(player.GetAll()) do v:ChatPrint(msg) end end

local meta = FindMetaTable("Player")
function meta:GetTarget() return self._Target or false end

hook.Add("PlayerSpawn","EXP_PowerupsSpawn",function(ply) 
	
	// Get the player's current level
	local lvl = ply:GetNWInt("LevelNum")-1
	
	// Enhance their jump speed/health/armor
	if UP_JUMP == 1 then ply:SetJumpPower(200+lvl*15) end
	if UP_ARMOR == 1 then ply:SetArmor(0+lvl*10) end
	if UP_HP == 1 then ply:SetHealth(100+lvl*10) end
end) 

hook.Add("SetupMove","Exp_PowerupsMove",function(ply,move)
	// Get the player's current level
	local lvl = ply:GetNWInt("LevelNum")-1
	if UP_RUN == 1 then ply:SetRunSpeed(500+lvl*100) end
	if UP_WALK == 1 then ply:SetWalkSpeed(250+lvl*30) end
end)

hook.Add("PlayerLoadout","EXP_PowerupsLoad",function(ply)
	
	// Get the player's current level
	local lvl = ply:GetNWInt("LevelNum")-1

	// Give them weapons based on their level
	if UP_SWEPS == 1 then
		ply:StripWeapons()
		for _,v in ipairs(regweapons) do ply:Give(v) end
		for k,v in ipairs(upweapons) do 
			if lvl >= k then 
				ply:Give(v[1])
				if v[2] then ply:GiveAmmo(15*lvl,v[2],false) end
			end 
		end
		if lvl >= 7 then 
			ply:GiveAmmo(lvl-6,"SMG1_Grenade",false) 
			ply:GiveAmmo(lvl-6,"AR2AltFire",false)
		end
	end
	
	ply:Give("weapon_pointer")
	
	if OVERRIDE_SWEPS == 1 then return true end
end) 

// Increase damage based on a player's level
local function IncreaseDamage(ply,hitgroup,dmginfo) 
	local attacker = dmginfo:GetAttacker()
	if UP_DMG == 1 then dmginfo:ScaleDamage(1+0.1*(attacker:GetNWInt("LevelNum")-1)) end
end

// Increase it on NPCs, players, or both
if EXP_USENPC == 0 then hook.Add("ScalePlayerDamage","testply",IncreaseDamage)
elseif EXP_USENPC == 1 then hook.Add("ScaleNPCDamage","testnpc",IncreaseDamage)
else hook.Add("ScalePlayerDamage","testply",IncreaseDamage)
	hook.Add("ScaleNPCDamage","testnpc",IncreaseDamage) 
end

// SKILLZZZZZZZZZZZZZZ
skills = {}
local function CreateSkill(name,wait,func,level,tex,desc,id,cost) 
	local new = {}
	new.Name = name
	new.Wait = wait
	new.Func = func
	new.Level = level
	if tex == "" then tex = "vgui/swepicon" end
	new.Tex = tex
	new.Desc = desc
	new.ID = id
	if cost then new.PermCost = cost else new.PermCost = 100 end
	skills[id] = new
 end

// HOW TO MAKE A SKILL: <Name of Skill>, <How long to wait after usage>, <function of what happens on usage (ply input)>, <what level you have to be to use>, <texture to use for a vgui icon>, <description>

// Skill: Use the Force
// Description: Be a jedi and throw things!
	CreateSkill("use_the_force",5,function(ply)
		local ent = ply:GetTarget() or ply:GetEyeTrace().Entity
		if ent then if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_vehicle_airboat" or ent:GetClass() == "prop_vehicle_jeep" then
			local obj = ent:GetPhysicsObject()
			obj:ApplyForceCenter(ply:GetForward()*10000*obj:GetMass()+Vector(0,0,10000*obj:GetMass())-obj:GetPos()-obj:GetVelocity()/50)
		end end
	end,3,"","Be a jedi \nand throw things!",1)
	
// Skill: Health Pack
// Descipription: Your own medic! Heal you or your target.
	CreateSkill("health_pack",10,function(ply) 
		local heal = math.Clamp((ply:GetNWInt("LevelNum")-4)*10,0,100)
		local tr = ply:GetEyeTrace()
		if tr.Entity:IsPlayer() then tr.Entity:SetHealth(tr.Entity:Health()+heal)
			tr.Entity:ChatPrint(ply:Name().." healed you for "..heal.." hp!")
			ply:ChatPrint("You healed "..tr.Entity:Name().." for "..heal.." hp!")
		else ply:SetHealth(ply:Health()+heal) 
			ply:ChatPrint("You healed yourself for "..heal.." hp!") 
		end
	end,5,"","Your own medic!\n Heal you or target.",2)
	
// Skill: Hax
// Description: HAAAAAAX!
	// Created by Kwigg, updated by NECROSSIN, adapted by Entoros
	resource.AddFile( "sound/weapons/hacks01.wav" )
	 local ShootSound = Sound ("weapons/hacks01.wav");
	 local ShootSound2 = Sound ("weapons/iceaxe/iceaxe_swing1.wav");

	 local function UseHax(ply)
		ply:EmitSound (ShootSound2,300,100)
		ply:SetAnimation(PLAYER_ATTACK1)
		Monitor = ents.Create("monitor")
		Monitor:SetPos(ply:EyePos() + (ply:GetAimVector() * 16))
		Monitor:SetAngles( ply:EyeAngles() )
		Monitor:SetPhysicsAttacker(ply)
		Monitor:SetOwner(ply)
		Monitor:Spawn()
			
		local phys = Monitor:GetPhysicsObject(); 
		local tr = ply:GetEyeTrace();
		local PlayerPos = ply:GetShootPos()
		 
		local shot_length = tr.HitPos:Length(); 
		phys:ApplyForceCenter (ply:GetAimVector():GetNormalized() *  math.pow(shot_length, 3));
		phys:ApplyForceOffset(VectorRand()*math.Rand(10000,30000),PlayerPos + VectorRand()*math.Rand(0.5,1.5))
	end
	 
	CreateSkill("hax",20,function(ply)
		ply:DrawViewModel(false)
		ply:EmitSound(ShootSound,100,100)
		timer.Create("HAX",1.01,1,function() UseHax(ply) end)
		/* timer.Simple(1.02, game.ConsoleCommand, "host_timescale 0.03\n")
		timer.Simple(1.03, game.ConsoleCommand, "pp_motionblur 1\n")
		timer.Simple(1.3, game.ConsoleCommand, "pp_motionblur 0\n")
		timer.Simple(1.3, game.ConsoleCommand, "host_timescale 1\n")*/
		timer.Simple(1.02,function()  ply:ConCommand("host_timescale 0.03\n") end)
		timer.Simple(1.03,function()  ply:ConCommand("pp_motionblur 1\n") end)
		timer.Simple(1.3,function()  ply:ConCommand("pp_motionblur 0\n") end)
		timer.Simple(1.3,function()  ply:ConCommand("host_timescale 1\n") 
			ply:DrawViewModel(true) end)
	end,2,"","HAAAAAAX!",3)

// This needs work 
	local function MakeFriendly(ply,npc)
		npc:AddEntityRelationship(ply,3,99)
		for _,v in ipairs(ents.FindByClass("npc_*")) do if v:Disposition(ply) == 3 then 
			npc:AddEntityRelationship(v,3,99) 
			v:AddEntityRelationship(npc,3,99)
			else npc:AddEntityRelationship(v,1,99) end 
		end 
	end

	local function MakeNPC(class,ply,num,wep,pos)
		local tr = ply:GetEyeTrace()
		for i=0,num-1 do
			local npc = ents.Create(class)
			if not pos or pos == nil and class != "item_ammo_crate" then npc:SetPos(tr.HitPos+Vector(i*70,i*10,20)) else npc:SetPos(pos) end
			npc:SetHealth(npc:Health()+(ply:GetNWInt("LevelNum")-1)*20)
			npc:SetAngles((ply:GetForward():Normalize()*-1):Angle())
		
			if wep and wep != nil then npc:Give(wep) end
			
			if string.sub(class,1,3) == "npc" then MakeFriendly(ply,npc) end
			
			local function Delete(time) timer.Simple(time,function() if npc:IsValid() and npc then npc:Remove() end end) end
			local function DoAssault(time)
				timer.Simple(time,function()
					if npc:IsValid() and npc:GetEnemy() then
						npc:GetEnemy():SetName(ply:SteamID().."assault")
						npc:Fire("Assault",ply:SteamID().."assault",0)
					end
				end)
			end
			
			local lvl = ply:GetNWInt("LevelNum")
			if class == "npc_strider" then 
				npc:SetKeyValue("squadname",ply:SteamID())
				if math.random(1,2) == 1 then npc:Fire("crouch","",4) end
				timer.Simple(8,function() 
					if npc:GetEnemy() then 
						npc:GetEnemy():SetName(ply:SteamID().."cannontarg")
						npc:Fire("setcannontarget",ply:SteamID().."cannontarg",0)
					end
				end)
				//npc:Fire("break","",20)
				npc:SetKeyValue("spawnflags",65792)
				npc:Fire("StartPatrol","",0)
				//npc:Fire("SetTargetPath",tostring(ply:GetEyeTrace().HitPos),5)
				npc:Fire("FlickRagdoll","",13)
				DoAssault(3)
				Delete(20)
			elseif class == "npc_combine_s" or class == "npc_metropolice" then
				npc:SetKeyValue("spawnflags",512)
				
				if class == "npc_combine_s" then
					npc:SetKeyValue("NumGrenades",999999)
					if lvl == 8 then npc:SetKeyValue("model","models/combine_super_soldier.mdl")
					else npc:SetKeyValue("model","models/combine_soldier.mdl") end
				end
				
				npc:SetKeyValue("squadname",ply:SteamID())
				npc:SetKeyValue("waitingtorappel",1)
				npc:SetPos(npc:GetPos()+Vector(0,0,1000))
				npc:Fire("BeginRappel","",0)
				npc:SetKeyValue("tacticalvariant",2)
				
				npc:Fire("StartPatrolling","",0)
				npc:CapabilitiesAdd(CAP_OPEN_DOORS | CAP_TURN_HEAD | CAP_DUCK)
				
				DoAssault(3)
				Delete(30)
			elseif class == "npc_zombie" or class == "npc_fastzombie" or class == "npc_zombine" or class == "npc_poisonzombie" then
				npc:SetKeyValue("squadname",ply:SteamID())
				npc:SetKeyValue("spawnflags",512)
				npc:CapabilitiesAdd(CAP_OPEN_DOORS | CAP_TURN_HEAD | CAP_DUCK)
				DoAssault(3)
				Delete(30)
			elseif class == "npc_manhack" then 
				npc:SetKeyValue("squadname",ply:SteamID())
				Delete(20)
			elseif class == "item_ammo_crate" then
				local mul1 = 148
				local mul2 = 180
				npc:SetPos(tr.HitPos+Vector(math.sin(i*mul1)*mul2,math.cos(i*mul1)*mul2,npc:BoundingRadius()*2+16)+-1*ply:GetForward()*100)
				//npc:SetAngles(((ply:GetPos()+npc:GetPos()):Normalize()*-1):Angle())
				npc:SetAngles((ply:GetForward():Normalize()*-1):Angle())
				npc:SetKeyValue("AmmoType",i)
				Delete(20)
			elseif class == "npc_citizen" then
				npc:SetKeyValue("squadname",ply:SteamID())
				npc:Fire("StartPatrolling","",0)
				npc:CapabilitiesAdd(CAP_OPEN_DOORS | CAP_TURN_HEAD | CAP_DUCK)
				DoAssault(3)
				
				local rmodel = ""
				local rnum = 1
				if math.random(1,2) == 1 then rmodel = "male" else rmodel = "female" end
				if rmodel == "male" then rnum = math.random(1,9) else rnum = math.random(1,7) end
				if rnum == 5 and rmodel == "female" then rnum = math.random(1,4) end
				
				local function ModCitz(t,m,prof)
					npc:SetKeyValue("cititzentype",t)
					npc:SetKeyValue("model","models/humans/"..m.."/"..rmodel.."_0"..rnum..".mdl")
					if prof == 1 then npc:SetKeyValue("spawnflags","131080")
					elseif prof == 2 then npc:SetKeyValue("spawnflags","524288")
						npc:SetKeyValue("ammosupply","smg1")
						npc:SetKeyValue("ammoamount","90")
					end
				end
				if lvl == 9 then ModCitz(3,"group03m",1)
					npc:SetPos(npc:GetPos()+Vector(70,10,00))
				elseif lvl == 8 then if i == 0 then ModCitz(3,"group03m",1) else ModCitz(3,"group03",2) end
				elseif lvl == 7 then if i == 0 then ModCitz(3,"group03m",1) else ModCitz(3,"group03",0) end
				elseif lvl == 6 then if i == 0 then ModCitz(3,"group03",2) else ModCitz(2,"group01",0) end
				elseif lvl == 5 then if i == 0 then ModCitz(3,"group03",0) else ModCitz(2,"group01",0) end
				else ModCitz(2,"group01",0) end
				
				Delete(30)
			elseif class == "npc_vortigaunt" then
				npc:SetKeyValue("squadname",ply:SteamID())
				npc:CapabilitiesAdd(CAP_OPEN_DOORS | CAP_TURN_HEAD | CAP_DUCK)
				DoAssault(3)
				npc:SetKeyValue("HealthRegenerationEnabled",1)
				npc:SetKeyValue("ArmorRegenerationEnabled",1)
				Delete(30)
			elseif class == "npc_antlionguard" then
				npc:SetKeyValue("allowbark","true")
				if lvl >= 11 then npc:SetKeyValue("cavernbreed","true") end
				Delete(20)
			elseif class == "npc_antlion" then
				if ply:IsValid() then npc:SetKeyValue("spawnflags","327680") end
				npc:Fire("EnableJump","",0)
				Delete(30)
			elseif class == "prop_vehicle_apc" then
				npc:SetKeyValue("vehiclescript","scripts/vehicles/apc_npc.txt")
				npc:SetKeyValue("VehicleLocked","true")
				npc:SetKeyValue("model","models/combine_apc.mdl")
				npc:SetKeyValue("actionScale","1")
				npc:SetName( "Combine_apc" .. ply:SteamID() )
				
				local driver = ents.Create("npc_apcdriver")
				if not pos or pos == nil then driver:SetPos(tr.HitPos+Vector(i*70,i*10,20)) else driver:SetPos(pos) end
				driver:SetHealth(driver:Health()+(ply:GetNWInt("LevelNum")-1)*20)
				//MakeFriendly(driver)
				driver:SetKeyValue( "vehicle", "Combine_apc" .. ply:SteamID() )
				driver:SetName( "Combine_apc" .. ply:SteamID() .. "_driver" )
				timer.Simple(30,function() if driver and driver:IsValid() then driver:Remove() end end)
				driver:Activate()
				driver:Spawn()
				
				Delete(30)
			else Delete(15) end
			
			if class == "npc_combinegunship" or class == "npc_helicopter" or class == "npc_combinedropship" or class == "npc_spotlight" then
				npc:SetPos(tr.HitPos+Vector(i*70,i*10,500))
			end
			
			/* local allents = ents.FindByClass("player")
			table.Add(allents,ents.FindByClass("npc_*"))
			table.sort(allents,
			function(a, b)
				if a == nil || !a:IsValid() then return false end
				if b == nil || !b:IsValid() then return true end
				return (a:GetPos() - npc:GetPos()):Length() < (b:GetPos() - npc:GetPos()):Length()
			end
			)
			for _,v in pairs(allents) do if npc:Disposition(v) == 1 or npc:Disposition(v) == 2 then npc:SetEnemy(v) break end end */
			npc:Activate()
			npc:Spawn()
		end
	end

// Skill: Combine Help
// Description: Who's the overwatch now?
	CreateSkill("combine_help",2,function(ply)
		local leveln = ply:GetNWInt("LevelNum")
		if leveln >= 10 then MakeNPC("npc_strider",ply,1)
		elseif leveln == 9 then MakeNPC("npc_hunter",ply,2)
		elseif leveln == 8 then MakeNPC("npc_combine_s",ply,2,"ai_weapon_ar2")
		elseif leveln == 7 then MakeNPC("npc_hunter",ply,1)
		elseif leveln == 6 then MakeNPC("npc_combine_s",ply,2,"ai_weapon_smg1")
		elseif leveln == 5 then MakeNPC("npc_combine_s",ply,1,"ai_weapon_shotgun")
		elseif leveln == 4 then MakeNPC("npc_turret_floor",ply,1)
		elseif leveln == 3 then MakeNPC("npc_metropolice",ply,1,"ai_weapon_pistol")
		else MakeNPC("npc_manhack",ply,2)
		end
	end,2,"","Who's the \noverwatch now?",4)

// Skill: Zombie Help
// Description: Use zombie minions for your bidding.
	CreateSkill("zombie_help",2,function(ply) 
		local leveln = ply:GetNWInt("LevelNum")
		if leveln >= 10 then MakeNPC("npc_fastzombie",ply,3)
		elseif leveln == 9 then MakeNPC("npc_poisonzombie",ply,2)
		elseif leveln == 8 then MakeNPC("npc_zombine",ply,1)
		elseif leveln == 7 then MakeNPC("npc_fastzombie",ply,1)
		elseif leveln == 6 then MakeNPC("npc_zombie",ply,2)
		elseif leveln == 5 then MakeNPC("npc_zombie",ply,1)
		else MakeNPC("npc_zombie",ply,1) end
	end,5,"","Use zombie minions\nfor your bidding.",5)

// npc_launcher? npc_particlestorm? npc_spotlight?
// Skill: Rebel Help
// Description: Anarchy! Anarchy!
	CreateSkill("rebel_help",2,function(ply)
		local leveln = ply:GetNWInt("LevelNum")
		if leveln >= 10 then MakeNPC("npc_vortigaunt",ply,2)
		elseif leveln == 9 then MakeNPC("npc_vortigaunt",ply,1)
			MakeNPC("npc_citizen",ply,1,"ai_weapon_ar2")
		elseif leveln == 8 then MakeNPC("npc_citizen",ply,2,"ai_weapon_ar2")
		elseif leveln == 7 then MakeNPC("npc_citizen",ply,2,"ai_weapon_smg1")
		elseif leveln == 6 then MakeNPC("npc_citizen",ply,2,"ai_weapon_smg1")
		elseif leveln == 5 then MakeNPC("npc_citizen",ply,2,"ai_weapon_shotgun")
		elseif leveln == 4 then MakeNPC("npc_citizen",ply,2,"ai_weapon_pistol")
		elseif leveln == 3 then MakeNPC("npc_citizen",ply,1,"ai_weapon_pistol") end
	end,2,"","Anarchy! Anarchy!",6)

// Skill: Antlion Help
// Description: Don't step on me!
CreateSkill("antlion_help",2,function(ply)
	local leveln = ply:GetNWInt("LevelNum")
	if leveln >= 10 then MakeNPC("npc_antlionguard",ply,1)
	elseif leveln == 9 then MakeNPC("npc_antlion",ply,2)
	elseif leveln == 8 then MakeNPC("npc_antlion",ply,1)
	elseif leveln == 7 then MakeNPC("npc_antlion",ply,2)
	else MakeNPC("npc_antlion") end
end,5,"","Don't step on\n me!",7)

// Skill: Ice Beam
// Description: Ignore your problems by freezing them.
	function SetFreeze(bool,ply)
		umsg.Start( "exp_freeze",ply)
			umsg.Bool(bool)
		umsg.End()
	end

	CreateSkill("ice_beam",20,function(ply)
		local ent = ply:GetTarget() or ply:GetEyeTrace().Entity
		if ent:IsPlayer() then 
			ent:Freeze(true)
			ent:SetColor(0,0,255,255)
			SetFreeze(true,ply)
			timer.Simple(10,function() 
				ent:Freeze(false) 
				SetFreeze(false,ply) 
				ent:SetColor(255,255,255,255)
			end)
			ent:ChatPrint("You were frozen by "..ply:Name().."!")
		elseif ent:IsNPC() then
			ent:SetMoveType(MOVETYPE_NONE)
			timer.Simple(5+ply:GetNWInt("LevelNum")-7,function() if ent and ent:IsValid() then ent:SetMoveType(MOVETYPE_STEP) end end)
		elseif ent:GetClass() == "prop_physics" then
			ent:SetMoveType(MOVETYPE_NONE)
			ent:SetVelocity(ent:GetPos())
			timer.Simple(5+ply:GetNWInt("LevelNum")-7,function() if ent and ent:IsValid() then ent:SetMoveType(MOVETYPE_VPHYSICS) end end)
		else ply:ChatPrint("Your atttack missed!")
		end
	end,7,"","Ignore your problems\nby freezing them.",8)
	
// Skill: Resupply
// Description: Stock up on ammo.
	CreateSkill("resupply",90,function(ply) MakeNPC("item_ammo_crate",ply,9) end,5,"","Stock up on ammo.",9)

// Skill: Fire Blast
// Description: Burn baby burn, Gmod inferno!
	CreateSkill("fire_blast",20,function(ply)
		local tr = ply:GetEyeTrace()
		local ent = ply:GetTarget() or ply:GetEyeTrace().Entity
		if ply:GetTarget() then tr.HitPos = ply:GetTarget():GetPos() end
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetStart( ply:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( ent )
		effectdata:SetScale(2500)
		util.Effect( "GaussTracer", effectdata )
		if ent:IsPlayer() or ent:IsNPC() then ent:Fire("Ignite","",0) end
	end,3,"","Burn baby burn,\nGmod inferno!",10) 

// Skill: Break
// Description: Lolwut
	CreateSkill("break",20,function(ply)
		local tr = ply:GetEyeTrace()
		if ply:GetTarget() then
			tr.HitPos = ply:GetTarget():GetPos()
			tr.Entity = ply:GetTarget()
		end
		local ed = EffectData()
		ed:SetOrigin(tr.HitPos)
		ed:SetStart(ply:GetShootPos())
		ed:SetAttachment(1)
		ed:SetEntity( ply:GetTarget() or tr.Entity )
		util.Effect("AirboatGunHeavyTracer",ed)
		if tr.Entity:IsNPC() then tr.Entity:Fire("break","",0) end
	end, 8,"","Lolwut",11)

// Skill: Mortar
// Description: Fancy FX!
	CreateSkill("mortar",30,function(ply)
		local targetTrace = util.QuickTrace( ply:GetShootPos(),ply:GetAimVector() * 8192, ply )
		local mortar = ents.Create( "func_tankmortar" )	
			mortar:SetPos(util.TraceLine( { start = targetTrace.HitPos, endpos = targetTrace.HitPos + Vector( 0, 0, 16383), filter = ply, mask = MASK_NPCWORLDSTATIC } ).HitPos)
			mortar:SetAngles( Angle( 90, 0, 0 ) )
			mortar:SetKeyValue( "iMagnitude", 500) // Damage.
			mortar:SetKeyValue( "firedelay", "1" ) // Time before hitting.
			mortar:SetKeyValue( "warningtime", "1" ) // Time to play incoming sound before hitting.
			mortar:SetKeyValue( "incomingsound", "Weapon_Mortar.Incomming" ) // Incoming sound.
			mortar:SetName(tostring(mortar))
		mortar:Spawn()
		
		// Create the target.
		local target = ents.Create( "info_target" )
			target:SetPos( targetTrace.HitPos )
			target:SetName( tostring( target ) )
		target:Spawn()
		mortar:DeleteOnRemove( target )
		
		// Fire.
		mortar:Fire( "SetTargetEntity", target:GetName(), 0 )
		mortar:Fire( "Activate", "", 0 )
		mortar:Fire( "FireAtWill", "", 0 )
		mortar:Fire( "Deactivate", "", 2 )
		mortar:Fire( "kill", "", 2 )
		
		local beam = ents.Create("env_beam")
		
		local target2 = ents.Create("info_target")
		target2:SetPos(mortar:GetPos()+mortar:GetUp()*100)
		target2:SetName(tostring(target2))
		beam:DeleteOnRemove(target2)
		
		beam:SetAngles(Angle(90,0,0))
		beam:SetName(tostring(beam))
		beam:SetPos(target2:GetPos())
		beam:SetKeyValue("LightningStart",beam:GetName())
		beam:SetKeyValue("LightningEnd",mortar:GetName())
		beam:SetKeyValue("target",mortar:GetName())
		beam:SetKeyValue("renderfx",0)
		beam:SetKeyValue("rendercolor","255 0 0")
		beam:SetKeyValue("life",10)
		beam:SetKeyValue("BoltWidth",5)
		beam:SetKeyValue("TextureScroll",35)
		beam:SetKeyValue("StrikeTime",3)
		beam:SetKeyValue("texture","sprites/laserbeam.spr")
		beam:SetKeyValue("NoiseAmplitude",0)
		beam:SetKeyValue("renderamt",100)
		
		beam:Fire("kill","",5)
		beam:Fire("Alpha",255,0)
		beam:Fire("TurnOn","",0)
		
		for k,v in pairs(beam:GetKeyValues()) do 
			//PrintAll(k.." - "..v)
		end 
	end,8,"","Fancy FX!",12)

// Skill: Mine Layer
// Description: Suprise your pursuers; lay mines!
	CreateSkill("mine_layer",2,function(ply) 
		local vec = ply:GetForward()*-200+ply:GetPos()
		MakeNPC("combine_mine",ply,1,nil,vec)
	end,5,"","Surprise your \npursuers; lay mines!",13)

// Skill: Pigeon
// Description: Up, up, and away!
	if file.Exists("pigeon.lua") then include('pigeon.lua')
		AddCSLuaFile('pigeon.lua') end
	CreateSkill("pigeon",2,function(ply)
		PIGEON.HooksEnable()
		PIGEON.Enable(ply)
		ply:DrawViewModel(false) // this doesn't seem to work in deploy...
		timer.Create("viewmodel" .. ply:UniqueID(), 0.01, 1, ply.DrawViewModel, ply, false) // so i use a timer
		ply:DrawWorldModel(false)
		timer.Simple(30,function()
			PIGEON.Disable(ply)
			ply:DrawViewModel(true)
			ply:DrawWorldModel(true)
		end)
	end,3,"","Up, up, and away!",14)
	
// Skill: Destroy
// Description: Make your target just disappear!
	CreateSkill("destroy",25,function(ply)
		local tr = ply:GetTarget() or ply:GetEyeTrace().Entity
		if tr:IsPlayer() then tr:Kill()
		elseif tr:IsNPC() or tr:GetClass() == "prop_physics" then tr:Remove() 
		end
	end,10,"","Make your target\njust disappear!",15)

// Skill: Explode
// Description: Everything's more fun on fire!
	CreateSkill("explode",10, function(ply)
		local trace = ply:GetEyeTrace()
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetEntity( trace.Entity )
		effectdata:SetAttachment( trace.PhysicsBone )
		util.Effect( "super_explosion", effectdata )
		
		local explosion = ents.Create( "env_explosion" )
		explosion:SetPos(trace.HitPos)
		explosion:SetKeyValue( "iMagnitude" , "200" )
		explosion:SetPhysicsAttacker(ply)
		explosion:SetOwner(ply)
		explosion:Spawn()
		explosion:Fire("explode","",0)
		explosion:Fire("kill","",0 )
	end,9,"","Everything's more\n fun on fire!",16)

// Skill: Lightning
// Description: Zap!
	local function DispEffect( name, data )
		local data2, k, v

		data2 = EffectData( )
			for k, v in pairs( data ) do
				data2[ "Set" .. k ]( data2, v )
			end
		util.Effect( name, data2 )
	end

	// Thanks to weathermod for this...
	local Thunder = {
			"ambient/atmosphere/thunder4.wav",
			"ambient/weather/thunder3.wav"   ,
			"ambient/atmosphere/thunder1.wav",
			"ambient/weather/thunder4.wav"   ,
			"ambient/weather/thunder2.wav"   ,
			"ambient/weather/thunder6.wav"   ,
			"ambient/weather/thunder5.wav"   ,
			"ambient/atmosphere/thunder2.wav",
			"ambient/atmosphere/thunder3.wav",
			"ambient/weather/thunder1.wav"    
	}
	local Explosion = {
			"ambient/explosions/explode_6.wav",
			"ambient/explosions/explode_3.wav",
			"ambient/explosions/explode_1.wav",
			"ambient/explosions/explode_7.wav",
			"ambient/explosions/explode_5.wav",
			"ambient/explosions/explode_4.wav",
			"ambient/explosions/explode_2.wav",
			"ambient/explosions/explode_9.wav",
			"ambient/explosions/explode_8.wav" 
	}

	CreateSkill("lightning",20,function(ply)
		/* local tr = ply:GetEyeTrace()
		local ed = EffectData()
		ed:SetOrigin(tr.HitPos)
		ed:SetStart(tr.HitPos+Vector(0,0,100))
		ed:SetNormal(tr.HitNormal)
		ed:SetEntity(tr.Entity)
		ed:SetAttachment(tr.PhysicsBone)
		util.Effect("TeslaZap",ed) */
		local tr = ply:GetEyeTrace()
		if ply:GetTarget() then tr.HitPos = ply:GetTarget():GetPos() end
		local ent = ply:GetTarget() or  tr.Entity
		local res, start, ende
		start = tr.HitPos + Vector(0,0,1000)
		ende = tr.HitPos
		res = util.TraceLine{ start = start, endpos = ende, filter = ent, mask = MASK_SHOT }
		
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos + Vector(0,0,10000) )
		effectdata:SetStart( tr.HitPos )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( ent )
		util.Effect( "ToolTracer", effectdata )
		
		DispEffect( "ThumperDust", { Origin = res.HitPos, Start = res.HitPos, Normal = res.HitNormal, Scale = 500, Radius = 45, Angle = res.HitNormal:Angle( ) } )
		ply:SendLua("surface.PlaySound(\""..Thunder[math.random(1,table.Count(Thunder))].."\")")
		ply:SendLua("surface.PlaySound(\"".. Explosion[math.random(1,table.Count(Explosion))].."\")")
		
		if ent:IsPlayer() then timer.Simple(0.1,function() ent:Kill() end)
		elseif ent:IsNPC() or ent:GetClass() == "prop_physics" then timer.Simple(0.1,function() ent:Remove() end) end
	end,4,"","Zap!",17)

// Skill: Conversion
// Description: Annoy everyone: make NPCs yours!
	CreateSkill("conversion",30,function(ply) 
		local ent = ply:GetEyeTrace().Entity
		if ent:IsNPC() then MakeFriendly(ply,ent) end
	end,6,"","Annoy everyone:\nmake NPCs yours!",18)

// Skill: Blind
// Description: Carol never wore her safety goggles. Now she doesn't need them.
	function SetBlind(bool,ply)
		local rp = RecipientFilter()
		rp:AddPlayer(ply)
		umsg.Start( "exp_blind", rp)
			umsg.Bool( bool )
		umsg.End()
	end

	CreateSkill("blind",2,function(ply)
		local ent = ply:GetTarget() or ply:GetEyeTrace().Entity
		if ent:IsPlayer() then
			SetBlind(true,ent)
			timer.Simple(10,function() SetBlind(false,ent) end)
		else ply:ChatPrint("Your attack missed!") end
	end,3,"","Carol never wore her safety goggles.\n Now she doesn't need them.",19)

// Skill: Suicide
// Description: Kill yourself. Duh.
	CreateSkill("suicide",5,function(ply) ply:Kill() end,1,"","Kill yourself. Duh.",20)

// Skill: Force Choke
// Description: Kill people, Darth Vader style.
	CreateSkill("force_choke",3,function(pl)
		local ent = pl:GetTarget() or pl:GetEyeTrace().Entity
		ent = pl
		if ent:IsPlayer() then
			umsg.Start("exp_choke",ent)
				umsg.Bool(true)
			umsg.End()
			timer.Simple(0.1,function()
					umsg.Start("exp_choke",ent)
						umsg.Bool(false)
					umsg.End()
				end)
			pl:SetMoveType(MOVETYPE_NOCLIP)
			pl:Lock()
			/*pl:CreateRagdoll()
			pl:DrawShadow( false )  
			pl:SetMaterial( "models/effects/vol_light001" )  
			pl:SetRenderMode( RENDERMODE_TRANSALPHA )  
			pl:Fire( "alpha", visibility, 0 )  
			pl:GetTable().invis = { vis=visibility, wep=pl:GetActiveWeapon() }  
			pl:DrawWorldModel(false)		*/	
			timer.Create(pl:SteamID().."forcechoke",0.01,50,function()
				pl:SetPos(pl:GetPos() + Vector(0,0,1))
				//local rag = pl:GetRagdollEntity()
				//print(rag:GetPhysicsObjectCount())
			end)
			timer.Create(pl:SteamID().."forcechoke2",1,5,function()
				if pl:Health() <= 10 then
					pl:Kill()
					timer.Destroy(pl:SteamID().."forcechoke2")
				else
					pl:SetHealth(pl:Health()-10)
					pl:SendLua("surface.PlaySound(\"player/pl_drown1.wav\")")
					umsg.Start("exp_choke",ent)
						umsg.Bool(true)
					umsg.End()
					timer.Simple(0.1,function()
						umsg.Start("exp_choke",ent)
							umsg.Bool(false)
						umsg.End()
					end)
				end
			end)
			timer.Simple(5,function()
				pl:UnLock()
				pl:SetMoveType(MOVETYPE_WALK)
			/*	pl:DrawShadow( true )  
				pl:SetMaterial( "" )  
				pl:SetRenderMode( RENDERMODE_NORMAL )  
				pl:Fire( "alpha", 255, 0 )  
				pl:DrawWorldModel(true)
				pl:GetTable().invis = nil  */
			end)
		end
	end,5,"","Kill people,\nDarth Vader style.",21)
	
// Skill: Silence
// Description: SILENCE! I kill you!
	CreateSkill("silence",45,function(pl)
		local ent = pl:GetTarget() or pl:GetEyeTrace().Entity
		if ent:IsPlayer() then
			ent:SetNWBool("exp_silence",true)
			timer.Simple(10,function()
				ent:SetNWBool("exp_silence",false)
			end)
		end
	end,3,"","SILENCE!\nI kill you!",22)
	
// Skill: Invisibility
// Description: Sneak behind enemy lines.
	CreateSkill("invisibility",60,function(pl)
		pl:SetMaterial("models/effects/vol_light001")
		pl:DrawWorldModel(false)
		timer.Simple(15,function()
			pl:SetMaterial("")
			pl:DrawWorldModel(true)
		end)
	end,8,"","Sneak behind\nenemy lines.",23)
	
// NOT WORKING Skill: Slow
// Description: Nothing moves like a snail.
	CreateSkill("slow",3,function(pl)
		local ent = pl:GetTarget() or pl:GetEyeTrace().Entity
		if ent:IsPlayer() then
			GAMEMODE:SetPlayerSpeed(pl,100,100)
			timer.Simple(10,function()
				pl:SetRunSpeed(500)
				pl:SetRunSpeed(250)
			end)
		end
	end,3,"","Nothing moves\nlike a snail.",24)
	