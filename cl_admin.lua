ESX = nil 

local TriggerEventServ = TriggerServerEvent
local CommandExec = ExecuteCommand

Admin = {
    vehicles = {
        "Spawn",
        "Retourner",
        "Réparer",
        "Supprimer"
    },
    argentmec = {
        "Donner",
        "Jeter",
    },
    diverses = {
        "Noclip",
        "Invicibilité",
        "Fantôme"
    },
    meteos = {
        "-",
        "Blackout",
        "Superbe Soleil", 
        "Clair", 
        "Neutre", 
        "Brouillard", 
        "Nuageux", -- CLOUDS
        "Pluie", -- CLEARING
        "Orageux", -- THUNDER
        "Neige", -- SNOW
        "Tempête Glacial", -- BLIZZARD
        "Nöel", -- XMAS
        "Halloween" -- HALLOWEEN
    },
    heures = {
        "-",
        "07h00",
        "11h00",
        "15h00",
        "18h00",
        "21h00",
        "23h00",
        "02h00",
        "05h00",
    },
    list = 1,
    list2 = 1,
    list3 = 1,
    list4 = 1,
    list5 = 1,
    showName = false
}

CreateThread(function() 
    while ESX == nil do 
        TriggerEvent(iAdmin.GetSharedObject, function(obj)
            ESX = obj 
        end) 
        Wait(10) 
    end 
end)

local PlayerLoaded   = false
RegisterNetEvent("esx:playerLoaded") 
AddEventHandler("esx:playerLoaded", function(xPlayer) 
    PlayerLoaded = true 
end)

local function TeleportPlayer(typee)
    if typee == "teleporttoplayer" then
        DoScreenFadeOut(550) 
        Wait(550) 
        SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected)))) 
        DoScreenFadeIn(550) 
        Notif(iAdmin.Teleportationsmessage.."" ..GetPlayerName(GetPlayerFromServerId(IdSelected))) 
    elseif typee == "playerteleporttome" then
        DoScreenFadeOut(550) 
        Wait(550) 
        SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected)))) 
        DoScreenFadeIn(550) 
        Notif(iAdmin.Teleportationsmessage.."" ..GetPlayerName(GetPlayerFromServerId(IdSelected))) 
    end
end

function getInformations(player)
        ESX.TriggerServerCallback("Admin:getAllInfos", function(data)
            Citizen.SetTimeout(2200, function()
            dakomm = data
        end)
    end, player)
end

local adminmenuopen = false
RMenu.Add("Admin", "principal", RageUI.CreateMenu(iAdmin.TitleMenu, iAdmin.TitleSubMenu, 10, 100))
RMenu:Get("Admin", "principal"):SetRectangleBanner(iAdmin.MenuColorRed, iAdmin.MenuColorGreen, iAdmin.MenuColorBlue, iAdmin.MenuColorAlpha)
RMenu:Get("Admin", "principal"):SetPosition(iAdmin.PosMenuX, iAdmin.PosMenuY)
RMenu:Get("Admin", "principal").Closed = function()
    adminmenuopen = false
end;

RMenu.Add("Admin", "personnels", RageUI.CreateSubMenu(RMenu:Get("Admin", "principal"), "Personnels", "Intéraction Personnels"))
RMenu:Get("Admin", "personnels").Closed = function() end;

RMenu.Add("Admin", "serveuralpha", RageUI.CreateSubMenu(RMenu:Get("Admin", "principal"), "Serveur", "Intéraction Serveur"))
RMenu:Get("Admin", "serveuralpha").Closed = function() end;

RMenu.Add("Admin", "listejoueurs", RageUI.CreateSubMenu(RMenu:Get("Admin", "principal"), "Joueurs", "Intéraction Joueurs"))
RMenu:Get("Admin", "listejoueurs").Closed = function() end;

RMenu.Add("Admin", "actionslistejouerus", RageUI.CreateSubMenu(RMenu:Get("Admin", "principal"), "Actions", "Intéraction Listes"))
RMenu:Get("Admin", "actionslistejouerus").Closed = function() end;

RMenu.Add("Admin", "infoslistjoueurs", RageUI.CreateSubMenu(RMenu:Get("Admin", "principal"), "Infos", "Tout savoir"))
RMenu:Get("Admin", "infoslistjoueurs").Closed = function() end;

local ServersIdSession = {}
CreateThread(function()
    while true do
        Wait(500)
        for _,v in pairs(GetActivePlayers()) do
            local found = false
            for _,j in pairs(ServersIdSession) do
                if GetPlayerServerId(v) == j then
                    found = true
                end
            end
            if not found then
                table.insert(ServersIdSession, GetPlayerServerId(v))
            end
        end
    end
end)


local function openAdminMenu()
	if adminmenuopen then
		adminmenuopen = false
    else
        adminmenuopen = true
		RageUI.Visible(RMenu:Get("Admin", "principal"), true)
	    CreateThread(function()
		while adminmenuopen do
            Wait(1)
                RageUI.IsVisible(RMenu:Get("Admin", "principal"), true, true, true, function()

                    RageUI.ButtonWithStyle("Personnel", nil, {RightLabel = "→→"}, true, function()
                    end, RMenu:Get("Admin", "personnels"))

                    RageUI.ButtonWithStyle("Liste de Joueurs", nil, {RightLabel = "→→"}, true, function()
                    end, RMenu:Get("Admin", "listejoueurs"))

                    RageUI.ButtonWithStyle("Serveur", nil, {RightLabel = "→→"}, true, function()
                    end, RMenu:Get("Admin", "serveuralpha"))
                end)

                RageUI.IsVisible(RMenu:Get("Admin", "listejoueurs"), true, true, true, function()

                    for k,v in ipairs(ServersIdSession) do
                        if GetPlayerName(GetPlayerFromServerId(v)) == "**Invalid**" then table.remove(ServersIdSession, k) end
                        RageUI.ButtonWithStyle(GetPlayerName(GetPlayerFromServerId(v)) .." - [~b~" ..v.. "~s~]", nil, {RightLabel = "→→"}, true, function(_, a, s)
                        if a then
                            PlayerMarqueur(IdSelected)
                        end
                        if s then
                            IdSelected = v
                        end
                        end, RMenu:Get("Admin", "actionslistejouerus"))
                    end
                end)

                RageUI.IsVisible(RMenu:Get("Admin", "serveuralpha"), true, true, true, function()

                        RageUI.ButtonWithStyle("Annonce Serveur", nil, {RightBadge = RageUI.BadgeStyle.Star}, true, function(h, a, s)
                            if s then 
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 1500)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0);
                                Wait(1)
                                end
                                local annonceresult = GetOnscreenKeyboardResult()
                                if annonceresult == "" then
                                    Notif("~r~Veuillez entrer des caractères afin d'envoyer le message")
                                else
                                    if annonceresult then
                                        local annonceserv = GetOnscreenKeyboardResult()
                                        TriggerEventServ("logs:announce", annonceserv)
                                        TriggerEventServ("anounce:admintoall", "Serveur", "Annonce", annonceserv, "CHAR_BLANK_ENTRY", 1)
                                    end
                                end 
                            end
                        end)

                        RageUI.ButtonWithStyle("Noms des Joueurs", nil, {}, true, function(_, _, s)
                            if s then
                            end
                        end)

                        RageUI.List("Météo", Admin.meteos, Admin.list4, nil, {}, not meteoafficher, function(_, _, s, i)
                            if i == 1 then
                                elseif i == 2 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("outblack")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 3 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather EXTRASUNNY")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 4 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather CLEAR")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 5 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather NEUTRAL")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 6 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather SMOG")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 7 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather CLOUDS")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 8 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather CLEARING")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 9 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather THUNDER")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 10 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather SNOW")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 11 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather BLIZZARD")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 12 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather XMAS")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                elseif i == 13 then
                                    if s then
                                        meteoafficher = true
                                        CommandExec("weather HALLOWEEN")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 25000)
                                        SetTimeout(25000, function() meteoafficher = false end)
                                    end
                                end 
                            Admin.list4 = i;
                        end)   

                        RageUI.List("Heures", Admin.heures, Admin.list5, nil, {}, not heuremecc, function(_, _, s, i)
                                    if i == 1 then
                                    elseif i == 2 then
                                        if s then
                                            heuremecc = true
                                            CommandExec("time 07 00")
                                            SetTimeout(5000, function() heuremecc = false end)
                                        end
                                    elseif i == 3 then
                                        if s then
                                            heuremecc = true
                                            CommandExec("time 11 00")
                                            SetTimeout(5000, function() heuremecc = false end)
                                        end
                                    elseif i == 4 then
                                        if s then
                                            heuremecc = true
                                            CommandExec("time 15 00")
                                            SetTimeout(5000, function() heuremecc = false end)
                                        end
                                    elseif i == 5 then
                                        if s then
                                            heuremecc = true
                                            CommandExec("time 18 00")
                                            SetTimeout(5000, function() heuremecc = false end)
                                        end
                                    elseif i == 6 then
                                        if s then
                                            heuremecc = true
                                            CommandExec("time 21 00")
                                            SetTimeout(5000, function() heuremecc = false end)
                                        end
                                    elseif i == 7 then
                                        if s then
                                            heuremecc = true
                                            CommandExec("time 23 00")
                                            SetTimeout(5000, function() heuremecc = false end)
                                        end
                                    elseif i == 8 then
                                        if s then
                                            heuremecc = true
                                            CommandExec("time 02 00")
                                            SetTimeout(5000, function() heuremecc = false end)
                                        end
                                    elseif i == 9 then
                                        if s then
                                            heuremecc = true
                                            CommandExec("time 05 00")
                                            SetTimeout(5000, function() heuremecc = false end)
                                        end
                                    end 
                            Admin.list5 = i;
                        end)   

                        RageUI.ButtonWithStyle("Réanimer Alls", nil, {RightBadge = RageUI.BadgeStyle.Alert}, not revivealleffectued, function(h, a, s)
                            if s then 
                                revivealleffectued = true
                                TriggerEventServ("dakom:adminoptionsall", "reviveall")
                                TriggerEventServ("anounce:admintoall", iAdmin.ServerName, "Administration", "l'ensemble du serveur a était réanimer par un administrateur !", "CHAR_ARTHUR", 1)
                                SetTimeout(7000, function() revivealleffectued = false end)
                            end
                        end)

                        RageUI.ButtonWithStyle("Expulser Alls", nil, {RightBadge = RageUI.BadgeStyle.Alert}, not kickalleffectued, function(h, a, s)
                            if s then 
                                kickalleffectued = true
                                TriggerEventServ("dakom:adminoptionsall", "kickall")
                                SetTimeout(7000, function() kickalleffectued = false end)
                            end
                        end)
                    end)

                RageUI.IsVisible(RMenu:Get("Admin", "personnels"), true, true, true, function()

                        RageUI.ButtonWithStyle("TP Marqueur", nil, {RightLabel = "→←"}, true, function(_, _, s)
                            if s then 
                                TeleportBlips()
                            end
                        end)
                        
                        RageUI.List("Diverse", Admin.diverses, Admin.list3, nil, {}, true, function(_, _, s, i)
                            if s then
                                if i == 1 then
                                    noclipActive = not noclipActive
                                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                                        noclipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
                                        SetEntityInvincible(noclipEntity, true)
                                    else
                                        SetEntityInvincible(noclipEntity, false)
                                        noclipEntity = PlayerPedId()
                                    end
                                    SetEntityCollision(noclipEntity, not noclipActive, not noclipActive)
                                    FreezeEntityPosition(noclipEntity, noclipActive)
                                    SetEntityInvincible(noclipEntity, noclipActive)
                                    SetVehicleRadioEnabled(noclipEntity, not noclipActive)
                                elseif i == 2 then
                                godmode = not godmode
                                if godmode then
                                    SetEntityInvincible(PlayerPedId(), true)
                                    godmode = 999999999
                                    CenterText("~g~Invicibilité", godmode)
                                else
                                    CenterText("~r~Invicibilité", 4500)
                                    SetEntityInvincible(PlayerPedId(), false)
                                end
                                elseif i == 3 then
                                    fantome = not fantome
                                    if fantome then
                                        SetEntityVisible(PlayerPedId(), false, false)
                                        fantome = 999999999
                                        CenterText("~g~Fantôme", fantome)
                                    else
                                        CenterText("~r~Fantôme", 4500)
                                        SetEntityVisible(PlayerPedId(), true, false)
                                    end
                                end
                            end
                            Admin.list3 = i;
                        end)   

                        RageUI.List("Véhicules", Admin.vehicles, Admin.list, nil, {}, true, function(_, a, s, i)
                                if i == 1 then
                                    if s then
                                    -- Spawn vehicles
                                        SpawnVeh()
                                    end
                                elseif i == 2 then
                                    if a then
                                        if not IsPedInAnyVehicle(PlayerPedId(), -1) then
                                            MarkerVehicle()
                                        end
                                    end
                                    -- Retourner vehicles
                                    if s then
                                        local plyCoords = GetEntityCoords(PlayerPedId())
                                        local newCoords = plyCoords + vector3(0.0, 2.0, 0.0)
                                        local closestVeh = GetClosestVehicle(plyCoords, 5.0, 0, 70)
                                        if IsPedInAnyVehicle(PlayerPedId(), -1) then
                                            Notif("~r~Veuillez sortir du véhicule pour effectuer cette action !")
                                        else
                                            SetEntityCoords(closestVeh, newCoords)
                                        end
                                    end
                                elseif i == 3 then
                                    if a then
                                        if not IsPedInAnyVehicle(PlayerPedId(), -1) then
                                            MarkerVehicle()
                                        end
                                    end
                                    if s then
                                        -- Fix vehicles
                                        if IsPedInAnyVehicle(PlayerPedId(), -1) then
                                            local pVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            SetVehicleFixed(pVeh)
                                            SetEntityHealth(pVeh, 200)
                                        else
                                            local plyCoords = GetEntityCoords(PlayerPedId())
                                            local closestVeh = GetClosestVehicle(plyCoords, 5.0, 0, 70)
                                            SetVehicleFixed(closestVeh)
                                            SetEntityHealth(closestVeh, 200)
                                        end
                                    end
                                elseif i == 4 then
                                    if a then
                                        if not IsPedInAnyVehicle(PlayerPedId(), -1) then
                                            MarkerVehicle()
                                        end
                                    end
                                    if s then
                                        if IsPedInAnyVehicle(PlayerPedId(), -1) then
                                            local pVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                                            DeleteEntity(pVeh)
                                        else
                                            local closestVeh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0, 0, 70)
                                            DeleteEntity(closestVeh)
                                            end
                                        end
                                    end
                            Admin.list = i;
                        end)   

                        RageUI.List("Argents", Admin.argentmec, Admin.list2, nil, {}, true, function(_, _, s, i)
                            if i == 1 then
                                if s then
                                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", nil, nil, nil, 10)
                                    while (UpdateOnscreenKeyboard() == 0) do
                                        DisableAllControlActions(0);
                                        Wait(1)
                                    end
                                    local addmoney = GetOnscreenKeyboardResult()
                                    if tonumber(addmoney) then
                                        TriggerEventServ("dakomm:giveoremovecash", "addmoney", addmoney)
                                    else
                                        Notif("~r~Les types de caractère ne sont pas les bons")
                                    end
                                end
                            elseif i == 2 then
                                if s then
                                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", nil, nil, nil, 10)
                                    while (UpdateOnscreenKeyboard() == 0) do
                                        DisableAllControlActions(0);
                                    Wait(1)
                                    end
                                    local removemoney = GetOnscreenKeyboardResult()
                                    if tonumber(removemoney) then
                                        TriggerEventServ("dakomm:giveoremovecash", "rmvmoney", removemoney)
                                    else
                                        Notif("~r~Les types de caractère ne sont pas les bons")
                                    end 
                                end
                            end
                            Admin.list2 = i;
                        end)
                    end)

                    RageUI.IsVisible(RMenu:Get("Admin", "actionslistejouerus"), true, true, true, function()

                    RageUI.Separator("↓ ~b~Informations sur le Joueur~s~ ↓")

                    RageUI.ButtonWithStyle("En savoir plus...", nil, {RightLabel = "→→"}, true, function(_, _, s)
                        if s then
                            dakomm = nil
                            getInformations(GetPlayerPed(GetPlayerFromServerId(IdSelected)))
                            Citizen.SetTimeout(2600, function()
                                if dakomm == nil then
                                    Notif("~r~Aucune donnée disponible sur ce joueur")
                                end
                            end)
                        end
                    end, RMenu:Get("Admin", "infoslistjoueurs"))

                    RageUI.Separator("↓ ~o~ Actions sur " ..GetPlayerName(GetPlayerFromServerId(IdSelected)).. "~s~ ↓")

                    RageUI.Checkbox("Regarder le Joueur", nil, regarderjoueur, { Style = RageUI.CheckboxStyle.Tick }, function(_, _, _, c)
                        regarderjoueur = c;
                    end, function()
                        local playerId = GetPlayerFromServerId(IdSelected)
                        SpectatePlayer(GetPlayerPed(playerId), playerId)
                    end, function()
                        local targetPed = PlayerPedId()
                        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
                        RequestCollisionAtCoord(targetx,targety,targetz)
                        NetworkSetInSpectatorMode(false, targetPed)
                    end)

                    RageUI.ButtonWithStyle("TP au Joueur", nil, {}, true, function(_, _, s)
                        if s then
                            TeleportPlayer("teleporttoplayer")
                        end
                    end)

                    RageUI.ButtonWithStyle("TP Joueur sur moi", nil, {}, true, function(_, _, s)
                        if s then
                            TeleportPlayer("playerteleporttome")
                        end
                    end)

                    RageUI.ButtonWithStyle("Envoyez un message", nil, {}, true, function(_, _, s)
                        if s then 
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 20)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0);
                                Wait(1)
                                end
                                local staffenvoimsg = GetOnscreenKeyboardResult()
                                if staffenvoimsg == "" then
                                Notif("~o~Admin\n~r~Vous n'avez pas fourni de message")
                            else   
                                if staffenvoimsg then
                                    --TriggerEventServ("dakom:messageonlyplayer", IdSelected, "Titre" ,"Coucou" , staffenvoimsg, IdSelected)
                                    Notif("le message ~b~" ..staffenvoimsg.. "~s~ a bien été envoyer a ~o~" ..GetPlayerName(GetPlayerFromServerId(IdSelected))) 
                                    TriggerEventServ("dakom:messageonlyplayer", IdSelected, "~o~Staff\n~s~" ..staffenvoimsg)
                                end
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Freeze le Joueur", nil, {}, true, function(_, _, s)
                        if s then
                        freezeplayer = not freezeplayer
                            if freezeplayer then
                                FreezeEntityPosition(GetPlayerPed(IdSelected), true)
                            else
                                FreezeEntityPosition(GetPlayerPed(IdSelected), false)
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre de la vie", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, function(_, _, s)
                        if s then 
                            if GetEntityHealth(PedPlayers) <= 180 then
                                SetEntityHealth(PedPlayers, 200)
                            else
                                Notif("~r~Le joueur n'a pas assez perdu de vie")
                            end
                        end
                    end)

                    RageUI.Separator("↓ ~g~Argents~s~ ↓")

                    RageUI.ButtonWithStyle("Donner de l'argent", nil, {RightBadge = RageUI.BadgeStyle.Star, Color = { HightLightColor = { 0, 155, 0, 50 }}}, true, function(_, _, s)
                        if s then 
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 20)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0);
                                Wait(1)
                                end
                            local rsltdonnerjouer = GetOnscreenKeyboardResult()
                            if tonumber(rsltdonnerjouer) then
                                TriggerEventServ("dakom:playeractionsmoney", "addplayercashmoney", IdSelected, rsltdonnerjouer, GetPlayerName(GetPlayerFromServerId(IdSelected)))
                                Notif("Player: ~b~" ..GetPlayerName(GetPlayerFromServerId(IdSelected)).. "~s~\nActions: ~g~+$" ..rsltdonnerjouer)
                            else
                                Notif("~r~Veuillez donner des caractères correctes")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Retirer de l'argent", nil, {RightBadge = RageUI.BadgeStyle.Star, Color = { HightLightColor = { 255, 0, 0, 50 }}}, true, function(_, _, s)
                            if s then 
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 20)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0);
                                Wait(1)
                                end
                                local rsltretirerjouer = GetOnscreenKeyboardResult()
                                if rsltretirerjouer == "" then
                                Notif("~o~Admin\n~r~Vous n'avez pas fourni de montant valable")
                            else   
                                if tonumber(rsltretirerjouer) then
                                    TriggerEventServ("dakom:removeplayermoney", IdSelected, rsltretirerjouer)
                                    Notif("Player: ~b~" ..GetPlayerName(GetPlayerFromServerId(IdSelected)).. "~s~\nActions: ~r~-$" ..rsltretirerjouer)
                                else
                                    Notif("~r~Veuillez donner des caractères correctes")
                                end
                            end
                        end
                    end)

                    RageUI.Separator("↓ ~r~Important~s~ ↓")

                    RageUI.ButtonWithStyle("Supprimer Toutes les armes", nil, {RightBadge = RageUI.BadgeStyle.Alert, Color = { HightLightColor = { 255, 0, 0, 150 }}}, true, function(_, _, s)
                        if s then
                            TriggerEventServ("dakom:removeallweapon", IdSelected)
                            AdvancedNotif("Armes", "Administration", "Toutes les armes du joueur ~o~" ..GetPlayerName(GetPlayerFromServerId(IdSelected)).. "~s~ on était supprimer de sont inventaire", "CHAR_ARTHUR", 1)
                        end
                    end)

                    RageUI.ButtonWithStyle("Déconnectez le Joueur", nil, {RightBadge = RageUI.BadgeStyle.Alert, Color = { HightLightColor = { 255, 0, 0, 150 }}}, true, function(_, _, s)
                        if s then
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 20)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0);
                                Wait(1)
                                end
                                local resultraison = GetOnscreenKeyboardResult()
                            if resultraison == "" or resultraison == nil then
                                Notif("~o~Admin\n~r~Vous n'avez pas fourni de raison valable")
                            else   
                                if resultraison then
                                    local raisonkick = GetOnscreenKeyboardResult()
                                    Notif("Actions: ~o~Kick\nPlayer: ~b~" ..GetPlayerName(GetPlayerFromServerId(IdSelected)))
                                    TriggerEventServ("dakom:kickplayer", IdSelected, raisonkick) 
                                end
                            end
                        end
                    end)
                end)

                    RageUI.IsVisible(RMenu:Get("Admin", "infoslistjoueurs"), true, true, true, function()
                        if dakomm == nil then
                            RageUI.Separator("")
                            RageUI.Separator("Données en cours de chargement...")
                            RageUI.Separator("")
                        else
                            RageUI.Separator("Prénom: ~b~" ..dakomm.firstname.. "~s~ Nom: ~b~" ..dakomm.lastname)
                            RageUI.Separator("Groupe: ~r~" ..dakomm.usergroup)
                            RageUI.Separator("Date de Naissance: ~y~" ..dakomm.dob)
                            if dakomm.sex == "m" then
                                RageUI.Separator("Sexe: ~b~Homme~s~")
                            end
                            if dakomm.sex == "f" then
                                RageUI.Separator("Sexe: ~p~Femme~s~")
                            end
                            RageUI.Separator("Taille: ~o~" ..dakomm.height.. " cm")
                            RageUI.Separator("")
                            RageUI.Separator("Liquide: ~g~$" ..dakomm.liquide)
                            RageUI.Separator("Jobs: ~c~" ..dakomm.jobbing)
                        end
                end, function() 
                end)
			end
		end)
	end
end

local function getUserGroup()
    ESX.TriggerServerCallback("dakom:getUserGroup", function(plyGroup)
        if plyGroup ~= nil and plyGroup == "superadmin" then
            if adminmenuopen == false then
                openAdminMenu()
                Notif("Tu est " ..plyGroup)
            end
        end
    end, false)
end

Keys.Register('F2', '-openAdminMenu', 'Ouverture du Menu Admin', function() getUserGroup() end)
Keys.Register('E', '-tpadmin', 'Téléportation Admin', function() 
    if IsControlPressed(1, iAdmin.TeleportPressed1) and IsControlPressed(1, iAdmin.TeleportPressed2) then
        TeleportBlips()
    end
end)

AddEventHandler("playerSpawned", function() 
    TriggerEventServ('vSync:requestSync')
    CreateThread(function()
        while not PlayerLoaded do Wait(10) end

        if PlayerLoaded then
            Mugshot("Administration", "Aide", iAdmin.MessagePlayerSpawn ..iAdmin.ToucheOpen)
        end
    end)
 end)
