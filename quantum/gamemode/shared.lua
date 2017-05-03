include( "animations.lua" )

GM.Name = "Quantum"
GM.Author = "Space Hulk"
GM.Email = "N/A"
GM.Website = "www.facepunch.com"

TEAM_PLAYER = 2
TEAM_MENU = 1
GM_VERSION = 0.1

team.SetUp( TEAM_MENU, "Main Menu", Color(255, 255, 255, 255))
team.SetUp( TEAM_PLAYER, "Player's", Color(125, 125, 125, 255 ))

function GM:Initialize()
	if game.GetMap() == "gm_atomic" then 
	print("Quantum RP : Initializing...")
	print("Version : "..GM_VERSION)
	print("Created by Space Hulk")
	print("Done!")
	else 
	print("Quantum RP : Initializing...")
	print("This map is not supported!")
	print("WARNING : Codes in the game may break!")
	end
end

