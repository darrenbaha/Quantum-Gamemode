include( "shared.lua" )
include( "player_meta.lua" )
include( "handlers/EXPLevelHandler.lua")

-- Thanks JetBoom
color_white = Color(255, 255, 255, 220)
color_black = Color(50, 50, 50, 255)
color_black_alpha180 = Color(0, 0, 0, 180)
color_black_alpha90 = Color(0, 0, 0, 90)
color_white_alpha200 = Color(255, 255, 255, 200)
color_white_alpha180 = Color(255, 255, 255, 180)
color_white_alpha90 = Color(255, 255, 255, 90)
COLOR_INFLICTION = Color(235, 185, 0, 165)
COLOR_DARKBLUE = Color(5, 75, 150, 255)
COLOR_DARKGREEN = Color(0, 150, 0, 255)
COLOR_DARKRED = Color(185, 0, 0, 255)
COLOR_DARKRED_HUD = Color(185, 0, 0, 180)
COLOR_DARKCYAN = Color(0, 155, 155, 255)
COLOR_DARKCYAN_HUD = Color(0, 155, 155, 180)
COLOR_GRAY = Color(190, 190, 190, 255)
COLOR_GRAY_HUD = Color(190, 190, 190, 180)
COLOR_RED = Color(255, 0, 0, 180)
COLOR_BLUE = Color(0, 0, 255, 180)
COLOR_GREEN = Color(0, 255, 0, 200)
COLOR_LIMEGREEN = Color(50, 255, 50, 200) --alpha green?
COLOR_YELLOW = Color(255, 255, 0, 200)
COLOR_PURPLE = Color(255, 0, 255)
COLOR_CYAN = Color(0, 255, 255)
COLOR_WHITE = Color(255, 255, 255, 180)
COLOR_BLACK = Color(0, 0, 0)

surface.CreateFont( "Font1", {
	font = "akbar", 
	size = 60, 
	weight = 500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = true, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false, 
} )

hook.Add( "ShouldDrawLocalPlayer", "ThirdPersonDrawPlayer", function()
	if LocalPlayer():Alive() then
		return true
	end
end )

hook.Add( "CalcView", "ThirdPersonView", function( ply, origin, ang, fov )

	if ply:Alive() then

		local eyepos = ply:EyePos()

		local plyang = ply:GetAimVector()
		local tracedata = {}
		tracedata.start = eyepos
		tracedata.endpos = eyepos + ply:GetForward() * -65
		tracedata.filter = ply
		tracedata.mask = MASK_SOLID_BRUSHONLY
		local trace = util.TraceLine(tracedata)

		local view = {}
		view.origin = trace.HitPos + ply:GetForward() * -10
		view.angles = ply:EyeAngles()
		view.fov = fov
		
		return GAMEMODE:CalcView( ply, view.origin, view.angles, view.fov )
		
	end
	
end )

surface.CreateFont( "Font2", {
	font = "akbar", 
	size = 20, 
	weight = 500, 
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


function GM:PostDrawViewModel( vm, ply, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

end

//Initial player model menu

function PlayerCreation()
ply = LocalPlayer()
local models = {
"models/player/Group01/Male_01.mdl",
"models/player/Group01/Male_02.mdl",
"models/player/Group01/Male_03.mdl",
"models/player/Group01/Male_04.mdl",
"models/player/Group01/Male_05.mdl",
"models/player/Group01/Male_06.mdl",
"models/player/Group01/Male_07.mdl",
"models/player/Group01/Male_08.mdl",
"models/player/Group01/Male_09.mdl",
"models/player/Group01/Female_01.mdl",
"models/player/Group01/Female_02.mdl",
"models/player/Group01/Female_03.mdl",
"models/player/Group01/Female_04.mdl",
"models/player/Group01/Female_06.mdl",
"models/player/Group03/Male_01.mdl",
"models/player/Group03/Male_02.mdl",
"models/player/Group03/Male_03.mdl",
"models/player/Group03/Male_04.mdl",
"models/player/Group03/Male_05.mdl",
"models/player/Group03/Male_06.mdl",
"models/player/Group03/Male_07.mdl",
"models/player/Group03/Male_08.mdl",
"models/player/Group03/Male_09.mdl",
"models/player/Group03/Female_01.mdl",
"models/player/Group03/Female_02.mdl",
"models/player/Group03/Female_03.mdl",
"models/player/Group03/Female_04.mdl",
"models/player/Group03/Female_06.mdl",
"models/player/charple.mdl",
"models/player/corpse1.mdl",
"models/player/barney.mdl",
"models/player/eli.mdl",
"models/player/kleiner.mdl",
}
    local Menu = vgui.Create("DFrame")
	local ModelList = vgui.Create( "DPanelList", Menu ) 
    Menu:SetPos(ScrW() / 2 - 400, ScrH() / 2 - 400)
    Menu:SetSize(800, 700)
    Menu:SetTitle("Player Creation")
    Menu:SetDraggable(true)
    Menu:ShowCloseButton(false)
    Menu:MakePopup()
	Menu.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, COLOR_GRAY_HUD ) 
end
	
	ModelList:EnableVerticalScrollbar( true ) 
 	ModelList:EnableHorizontal( true ) 
 	ModelList:SetPadding( 4 ) 
	ModelList:SetPos(10,30)
	ModelList:SetSize(200, 160)
 
   local PlayerName = nil

   local NameEntry = vgui.Create( "DTextEntry", Menu )
   NameEntry:SetPos( 350, 315 )
   NameEntry:SetSize( 100, 20 )
   NameEntry:SetText( "Your Name" )
   NameEntry.OnEnter = function( self )
	PlayerName = self:GetValue()
end   
 
local icon2 = vgui.Create( "DModelPanel", Menu )
icon2:SetPos(40, 280)
icon2:SetSize( 350, 350 )

   local BackButton = vgui.Create( "DButton" )	
   BackButton:SetParent( Menu ) 
   BackButton:SetText( "Back" )
   BackButton:SetPos( 600, 20 )
   BackButton:SetSize( 200, 70 )
   BackButton.Paint = function( self, w, h)
    draw.RoundedBox( 0, 0, 0, w, h, color_black_alpha90)   
   end
   BackButton.DoClick = function()
    local PlayerName = nil
	RunConsoleCommand("quantum_back_menu")
	Menu.Close(Menu)
	surface.PlaySound("ui/buttonclickrelease.wav")
	end
	
	
   local DermaButton = vgui.Create( "DButton" )	
   DermaButton:SetParent( Menu ) 
   DermaButton:SetText( "Create Character" )
   DermaButton:SetPos( 315, 600 )
   DermaButton:SetSize( 200, 70 )
   DermaButton.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, color_black_alpha90 ) 
	end
   DermaButton.DoClick = function ()
   if PlayerName == nil then 
   ply:ChatPrint("Please enter a name.")
   else  
    RunConsoleCommand("newPlayer", PlayerName)
    Menu.Close(Menu) 
	surface.PlaySound("ui/buttonclickrelease.wav")
	
	end
end
        for _, model in pairs(models) do
                local icon = vgui.Create("SpawnIcon", ModelList)
                icon:SetModel(model)
                icon.DoClick = function(icon)
                        surface.PlaySound("ui/buttonclickrelease.wav")
                        RunConsoleCommand("setplayermodel", model)
						icon2:SetModel( model )	
                end
 
                ModelList:AddItem(icon)
        end
	
end
usermessage.Hook("PlayerCreation", PlayerCreation)

function GM:HUDPaint()
local ply = LocalPlayer()
local alpha = 0
local start = 0
local finish = false
local curtime = CurTime() * 7

ply = LocalPlayer()
if ply:Team() == TEAM_MENU then
      if alpha == 0 and finish == false then 
draw.SimpleText("Quantum RP", "Font1", ScrW() * 0.5, ScrH() * 0.05, Color(255,255,255,alpha + curtime), TEXT_ALIGN_CENTER )
     elseif alpha >= 255 then
	 local finish = true
draw.SimpleText("Quantum RP", "Font1", ScrW() * 0.5, ScrH() * 0.05, Color(255,255,255,255), TEXT_ALIGN_CENTER )
     end
else 
return true end 
end

local function Menu()
ply = LocalPlayer()

local Frame = vgui.Create( "DFrame" )
Frame:SetPos( 5, 5 ) 
Frame:SetSize( 600, 750 ) 
Frame:SetTitle("Quantum RP : Main Menu v01")
Frame:SetVisible( true ) 
Frame:SetDraggable( false ) 
Frame:ShowCloseButton( false ) 
Frame:MakePopup() 
Frame.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) 
end

local Button2 = vgui.Create( "DButton", Frame )
Button2:SetText( "Create New Character" )
Button2:SetFont("Font2")
Button2:SetTextColor( Color( 255, 255, 255 ) )
Button2:SetPos( 100, 200 )
Button2:SetSize( 200, 80 )
   Button2.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) ) 
	end

Button2.DoClick = function()
    RunConsoleCommand("quantum_create_character")
	RunConsoleCommand("quantum_setup_voice")
	Frame.Close(Frame)
	surface.PlaySound("ui/buttonclickrelease.wav")
end

local Button3 = vgui.Create( "DButton", Frame )
Button3:SetText( "Disconnect" )
Button3:SetFont("Font2")
Button3:SetTextColor( Color( 255, 255, 255 ) )
Button3:SetPos( 66, 300 )
Button3:SetSize( 200, 80 )
   Button3.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 0) ) 
	end
Button3.DoClick = function()
    RunConsoleCommand("disconnect")
	Frame.Close(Frame)
	surface.PlaySound("ui/buttonclickrelease.wav")
end

end
usermessage.Hook("Menu", Menu)

/*

Health bar stuff

*/

local w = 0
local w2 = 0
local w3 = 0
local speed = 20

local healthbar = surface.GetTextureID("quantum/hud/Healthbar_v3")
local staminabar = surface.GetTextureID("quantum/hud/staminabar")

function PlayerHUD()
local ply = LocalPlayer()
		local entityhealth = math.max(ply:Health(), 0)
		local maxhealth = ply:GetMaxHealth()
		local percenthealth = entityhealth / maxhealth	
		
    draw.RoundedBox( 0, 155, 50, 380, 15, color_black_alpha180 ) 
    draw.RoundedBox( 0, 155, 65, 380, 15, color_black_alpha180)	
	local target = math.Clamp( LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth() ) / LocalPlayer():GetMaxHealth() 
	local targetMana = math.Clamp( ply:GetMana(), 0, 100 ) / 100
    local targetStamina = math.Clamp( ply:GetStamina(), 0, 100 ) / 100      	
	w = Lerp( speed * FrameTime(), w, target )
	w2 = Lerp(speed * FrameTime(), w2, targetMana)
	w3 = Lerp(speed * FrameTime(), w3, targetStamina)
	draw.RoundedBox(0, 155, 65, w2 * 380, 12, COLOR_BLUE)
	draw.RoundedBox(0, 50, 750, w3 * 380, 12, COLOR_GREEN)
	draw.RoundedBox( 0, 155, 50, w * 380, 12, COLOR_DARKRED_HUD )
	
   surface.SetTexture(healthbar)   
   surface.SetDrawColor(255, 255, 255, 255)
   surface.DrawTexturedRect(0, -100, 800, 300)
   draw.DrawText( "Lv : "..ply:GetLevel(), "TargetID", 520, 95, COLOR_GRAY, TEXT_ALIGN_CENTER ) --Lv
   
   local currentEXP = ply:GetEXP()
   local nextLevelEXP = Level[ply:GetLevel() + 1][1]
   surface.SetTexture(staminabar)
   surface.SetDrawColor(255, 255, 255, 255)
   surface.DrawTexturedRect(-100, 600, 800, 300)
   draw.DrawText( currentEXP.."/"..nextLevelEXP, "TargetID", 410, 95, COLOR_GRAY. TEXT_ALIGN_CENTER) --Actual amount of Cor
end 

function GM:HUDPaint()
ply = LocalPlayer()
if ply:Team() == TEAM_PLAYER then 
   PlayerHUD()
   else
   end

end 

local tohide = { 
	["CHudHealth"] = true,
	["CHudBattery"] = true,
}
local function HUDShouldDraw(name) 
	if (tohide[name]) then     
		return false;      
	end
end
hook.Add("HUDShouldDraw", "How to: HUD Example HUD hider", HUDShouldDraw)
