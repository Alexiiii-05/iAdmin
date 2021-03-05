iAdmin = {}

-- For RGB Color =
-- https://www.google.com/search?q=color+picker

-- Marker Color Vehicles
iAdmin.ColorMarkVeh = {
	R = 255, -- Red
	G = 150, -- Green
	B = 0, -- Blue
	A = 200 -- 	Alpha
}

-- Marker Color Player =
iAdmin.ColorMarkPlayer = {
	R = 0, 
	G = 0, 
	B = 255, 
	A = 255
}

-- Change weather access
iAdmin.TimeChangeAuttomattly = false -- false = le temps ne change pas toutes les 10 minutes
iAdmin.AccessChangeWeather = { -- pour qu'il ai accès au function du menu pour changer le temps
	"license:d3335a3aa03572bcb7c721629cb81a1e953989ad",
	--"license:"
}

-- Menu Settings
iAdmin.OpenMenuPressed = 170 -- Open Key menu
iAdmin.ToucheOpen = "F3"
iAdmin.MessagePlayerSpawn = "Pour avoir accès a votre menu administration veuillez appuyez sur la touche ~o~"
iAdmin.TitleMenu = "iAdmin" -- Title menu
iAdmin.TitleSubMenu = "Sub Menu" -- Title submenu
iAdmin.ServerName = "iName" -- Your server name 
iAdmin.SizeMenuWidth = 100 -- 0 - 100 (0 = NativeUI Style / 100 = RageUI Style)
-- Color menu
iAdmin.MenuColorRed = "255" -- Color R
iAdmin.MenuColorGreen = "0" -- Color G
iAdmin.MenuColorBlue = "0" -- Color B
iAdmin.MenuColorAlpha = "90" -- Color Opacity menu
-- Position Menu
iAdmin.PosMenuX = 0 -- 0 = left top / 
iAdmin.PosMenuY = 120 -- 0 = left top / 
-- fin Menu Settings

-- Logs
iAdmin.TitleWebhook = "DakoM"
iAdmin.WebhookAnnounce = "" -- Logs
iAdmin.RemovemoneyLogs = "" -- Logs
iAdmin.AddmoneyLogs = "" -- Logs

-- Others
iAdmin.TeleportPressed1 = 19
iAdmin.TeleportPressed2 = 38
iAdmin.Teleportationsmessage = "~o~Admin\n~s~Téléportation à ~b~ "

-- Message
iAdmin.KickAllMessage = "Tu as était kick pour que nous puissons effectué un reboot du serveur\nRejoins Nous sur discord\ndiscord.gg/alphav"
iAdmin.Givemessagemoney = "~o~Admin\n~s~Vous avez récuperer" 
iAdmin.Removemessagemoney ="~o~Admin\n~s~Vous avez balancer"
iAdmin.Nomarkeroffset = "~o~Admin\n~r~Aucun Marqueur"

-- Noclip 
iAdmin.UpNoclip = "Monter"
iAdmin.DownNoclip = "Descendre"
iAdmin.LeftRightNoclip = "Gauche/Droite"
iAdmin.ForwardsNoclip = "Avancer/Reculer"
iAdmin.SpeedTextNoclip = "Vitesse"

-- Color bottom right bar Noclip
iAdmin.bgR = 0
iAdmin.bgG = 0
iAdmin.bgB = 0
iAdmin.bgA = 40

-- Controls Noclip
iAdmin.goUp = 85
iAdmin.goDown = 48
iAdmin.turnLeft = 34
iAdmin.turnRight = 35
iAdmin.goForward = 32
iAdmin.goBackward = 33
iAdmin.changeSpeed = 21

iAdmin.speeds = {
	{label = "Super Lent", speed = 0},
	{label = "Lent", speed = 0.5},
	{label = "Normal", speed = 2},
	{label = "Rapide", speed = 4},
	{label = "Super Rapide", speed = 6},
	{label = "Extremement Rapide", speed = 8},
	{label = "Extremement Rapide v2.0", speed = 15},
	{label = "Vitesse Maximum", speed = 22}
}