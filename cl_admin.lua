ESX = nil 

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
        "Aucune",
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
        "Aucune",
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

Citizen.CreateThread(function() while ESX == nil do TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end) Wait(10) end end)

local PlayerLoaded   = false
RegisterNetEvent("esx:playerLoaded") AddEventHandler("esx:playerLoaded", function(xPlayer) PlayerLoaded = true end)

local function TPJoueur() DoScreenFadeOut(550) Wait(550) SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected)))) DoScreenFadeIn(550) Notif(iAdmin.Teleportationsmessage.."" ..GetPlayerName(GetPlayerFromServerId(IdSelected))) end

function getInformations()
    ESX.TriggerServerCallback("Admin:getAllInfos", function(data)
        Citizen.SetTimeout(2200, function()
        dakomm = data
    end)
    end, GetPlayerServerId(IdSelected))
end

local adminmenuopen = false
RMenu.Add("Admin", "principal", RageUI.CreateMenu(iAdmin.TitleMenu, iAdmin.TitleSubMenu, 10, 100))
RMenu:Get("Admin", "principal"):SetRectangleBanner(iAdmin.MenuColorRed, iAdmin.MenuColorGreen, iAdmin.MenuColorBlue, iAdmin.MenuColorAlpha)
RMenu:Get("Admin", "principal"):SetStyleSize(iAdmin.SizeMenuWidth)
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
	if not adminmenuopen then
		adminmenuopen = true
		RageUI.Visible(RMenu:Get("Admin", "principal"), true)
	    CreateThread(function()
		while adminmenuopen do
            Wait(1)
                RageUI.IsVisible(RMenu:Get("Admin", "principal"), true, true, true, function()

                    RageUI.Button("Personnel", nil, {RightLabel = "→→"}, true, function()
                    end, RMenu:Get("Admin", "personnels"))

                    RageUI.Button("Liste de Joueurs", nil, {RightLabel = "→→"}, true, function()
                    end, RMenu:Get("Admin", "listejoueurs"))

                    RageUI.Button("Serveur", nil, {RightLabel = "→→"}, true, function()
                    end, RMenu:Get("Admin", "serveuralpha"))

                end)

                RageUI.IsVisible(RMenu:Get("Admin", "listejoueurs"), true, true, true, function()

                    for k,v in ipairs(ServersIdSession) do
                        if GetPlayerName(GetPlayerFromServerId(v)) == "**Invalid**" then table.remove(ServersIdSession, k) end
                        RageUI.Button(GetPlayerName(GetPlayerFromServerId(v)) .." - [~b~" ..v.. "~s~]", nil, {RightLabel = "→→"}, true, function(_, a, s)
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

                        RageUI.Button("Annonce Serveur", nil, {RightBadge = RageUI.BadgeStyle.Star}, true, function(h, a, s)
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
                                        TriggerServerEvent("logs:announce", annonceserv)
                                        TriggerServerEvent("anounce:admintoall", "Serveur", "Annonce", annonceserv, "CHAR_BLANK_ENTRY", 1)
                                    end
                                end 
                            end
                        end)

                        RageUI.Button("Noms des Joueurs", nil, {}, true, function(_, _, s)
                            if s then
                            end
                        end)

                        RageUI.List("Météo", Admin.meteos, Admin.list4, nil, {}, true, function(_, _, s, i)
                            if s then
                                if i == 1 then
                                elseif i == 2 then
                                        ExecuteCommand("outblack")
                                        CenterText("~r~Veuillez patientez 30 secondes avant de réactiver ce mode", 6500)
                                    elseif i == 3 then
                                        ExecuteCommand("ciel EXTRASUNNY")
                                    elseif i == 4 then
                                        ExecuteCommand("ciel CLEAR")
                                    elseif i == 5 then
                                        ExecuteCommand("ciel NEUTRAL")
                                    elseif i == 6 then
                                        ExecuteCommand("ciel SMOG")
                                    elseif i == 7 then
                                        ExecuteCommand("ciel CLOUDS")
                                    elseif i == 8 then
                                        ExecuteCommand("ciel CLEARING")
                                    elseif i == 9 then
                                        ExecuteCommand("ciel THUNDER")
                                    elseif i == 10 then
                                        ExecuteCommand("ciel SNOW")
                                    elseif i == 11 then
                                        ExecuteCommand("ciel BLIZZARD")
                                    elseif i == 12 then
                                        ExecuteCommand("ciel XMAS")
                                    elseif i == 13 then
                                        ExecuteCommand("ciel HALLOWEEN")
                                    end 
                                end
                            Admin.list4 = i;
                        end)   

                        RageUI.List("Heures", Admin.heures, Admin.list5, nil, {}, true, function(_, _, s, i)
                            if s then
                                    if i == 1 then
                                    elseif i == 2 then
                                        ExecuteCommand("time 07 00")
                                    elseif i == 3 then
                                        ExecuteCommand("time 11 00")
                                    elseif i == 4 then
                                        ExecuteCommand("time 15 00")
                                    elseif i == 5 then
                                        ExecuteCommand("time 18 00")
                                    elseif i == 6 then
                                        ExecuteCommand("time 21 00")
                                    elseif i == 7 then
                                        ExecuteCommand("time 23 00")
                                    elseif i == 8 then
                                        ExecuteCommand("time 02 00")
                                    elseif i == 9 then
                                        ExecuteCommand("time 05 00")
                                    end 
                                end
                            Admin.list5 = i;
                        end)   

                        RageUI.Button("Réanimer Alls", nil, {RightBadge = RageUI.BadgeStyle.Alert, Color = { HightLightColor = { 0, 155, 0, 50 }}}, true, function(h, a, s)
                            if s then 
                                TriggerServerEvent("dakom:revivetout")
                                TriggerServerEvent("anounce:admintoall", iAdmin.ServerName, "Administration", "l'ensemble du serveur a était réanimer par un administrateur !", "CHAR_ARTHUR", 1)
                            end
                        end)

                        RageUI.Button("Expulser Alls", nil, {RightBadge = RageUI.BadgeStyle.Alert, Color = { HightLightColor = { 255, 0, 0, 50 }}}, true, function(h, a, s)
                            if s then 
                                TriggerServerEvent("alphaadmnin:kickallplayers")
                            end
                        end)
                    end)

                RageUI.IsVisible(RMenu:Get("Admin", "personnels"), true, true, true, function()

                        RageUI.Button("TP Marqueur", nil, {RightLabel = "→←"}, true, function(_, _, s)
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
                                    CenterText("~g~Invicibilité", 9999999999999)
                                else
                                    CenterText("~r~Invicibilité", 4500)
                                    SetEntityInvincible(PlayerPedId(), false)
                                end
                                elseif i == 3 then
                                    fantome = not fantome
            
                                    if fantome then
                                        SetEntityVisible(PlayerPedId(), false, false)
                                        CenterText("~g~Fantôme", 9999999999999)
                                    else
                                        CenterText("~r~Fantôme", 4500)
                                        SetEntityVisible(PlayerPedId(), true, false)
                                    end
                                end
                            end
                            Admin.list3 = i;
                        end)   

                        RageUI.List("Véhicules", Admin.vehicles, Admin.list, nil, {}, true, function(_, a, s, i)
                            if a then
                                MarkerVehicle()
                            end
                            if s then
                                if i == 1 then
                                    -- Spawn vehicle
                                    SpawnVeh()
                                elseif i == 2 then
                                    -- Retrouner vehicle
                                    local plyCoords = GetEntityCoords(PlayerPedId())
                                    local newCoords = plyCoords + vector3(0.0, 2.0, 0.0)
                                    local closestVeh = GetClosestVehicle(plyCoords, 5.0, 0, 70)
                                    if IsPedInAnyVehicle(PlayerPedId(), -1) then
                                        Notif("~r~Veuillez sortir du véhicule pour effectuer cette action !")
                                    else
                                        SetEntityCoords(closestVeh, newCoords)
                                    end
                                elseif i == 3 then
                                    -- Fix vehicle
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
                                elseif i == 4 then
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

                        RageUI.List("Argents", Admin.argentmec, Admin.list2, "c'est de l'argent qui vous appartients", {}, true, function(_, _, s, i)
                            if s then
                                if i == 1 then
                                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "20", "20", nil, nil, nil, 10)
                                    while (UpdateOnscreenKeyboard() == 0) do
                                        DisableAllControlActions(0);
                                        Wait(1)
                                    end
                                    local addmoney = GetOnscreenKeyboardResult()
                                    if GetOnscreenKeyboardResult() then
                                        TriggerServerEvent("admin:addlogsmoney", addmoney)
                                        TriggerServerEvent("alphaadmnin:givemoney", addmoney)
                                        Notif(iAdmin.Givemessagemoney.. " ~g~+$" ..addmoney)
                                    end
                                elseif i == 2 then
                                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "20", "20", nil, nil, nil, 10)
                                    while (UpdateOnscreenKeyboard() == 0) do
                                        DisableAllControlActions(0);
                                    Wait(1)
                                    end
                                    local removemoney = GetOnscreenKeyboardResult()
                                    if GetOnscreenKeyboardResult() then
                                        TriggerServerEvent("admin:rmvlogsmoney", removemoney)
                                        TriggerServerEvent("dakom:removemoney", removemoney)
                                        Notif(iAdmin.Removemessagemoney.. " ~r~-$" ..removemoney)
                                    end 
                                end
                            end
                            Admin.list2 = i;
                        end)
                    end)

                    RageUI.IsVisible(RMenu:Get("Admin", "actionslistejouerus"), true, true, true, function()

                    RageUI.Separator("↓ ~b~Informations sur le Joueur~s~ ↓")

                    RageUI.Button("En savoir plus...", nil, {RightLabel = "→→"}, true, function(_, _, s)
                        if s then
                            dakomm = nil
                            getInformations()
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
                        StopDrawPlayerInfo()
                    end)

                    RageUI.Button("TP au Joueur", nil, {}, true, function(_, _, s)
                        if s then
                            TPJoueur()
                        end
                    end)

                    RageUI.Button("TP Joueur sur moi", nil, {}, true, function(_, _, s)
                        if s then
                            SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected))))
                            Notif("Téléportation de ~r~" ..GetPlayerName(GetPlayerFromServerId(IdSelected)).. "~s~ sur moi")
                        end
                    end)

                    RageUI.Button("Envoyez un message", nil, {}, true, function(_, _, s)
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
                                    --TriggerServerEvent("dakom:messageonlyplayer", IdSelected, "Titre" ,"Coucou" , staffenvoimsg, IdSelected)
                                    Notif("le message ~b~" ..staffenvoimsg.. "~s~ a bien été envoyer a ~o~" ..GetPlayerName(GetPlayerFromServerId(IdSelected))) 
                                    TriggerServerEvent("dakom:messageonlyplayer", IdSelected, "~o~Staff\n~s~" ..staffenvoimsg)
                                end
                            end
                        end
                    end)

                    RageUI.Button("Freeze le Joueur", nil, {}, true, function(_, _, s)
                        if s then
                        freezeplayer = not freezeplayer
                            if freezeplayer then
                                FreezeEntityPosition(IdSelected, true)
                            else
                                FreezeEntityPosition(IdSelected, false)
                            end
                        end
                    end)

                    RageUI.Button("Mettre de la vie", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, function(_, _, s)
                        if s then 
                            if GetEntityHealth(PedPlayers) <= 180 then
                                SetEntityHealth(PedPlayers, 200)
                            else
                                Notif("~r~Le joueur n'a pas assez perdu de vie")
                            end
                        end
                    end)

                    RageUI.Separator("↓ ~g~Argents~s~ ↓")

                    RageUI.Button("Donner de l'argent", nil, {RightBadge = RageUI.BadgeStyle.Star, Color = { HightLightColor = { 0, 155, 0, 50 }}}, true, function(_, _, s)
                        if s then 
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 20)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0);
                                Wait(1)
                                end
                                local rsltdonnerjouer = GetOnscreenKeyboardResult()
                                if rsltdonnerjouer == "" then
                                Notif("~o~Admin\n~r~Vous n'avez pas fourni de montant valable")
                            else   
                                if rsltdonnerjouer then
                                    TriggerServerEvent("dakom:donnerplayermoney", IdSelected, rsltdonnerjouer)
                                    Notif( "Vous avez donner ~g~$" ..rsltdonnerjouer) 
                                end
                            end
                        end
                    end)

                    RageUI.Button("Retirer de l'argent", nil, {RightBadge = RageUI.BadgeStyle.Star, Color = { HightLightColor = { 255, 0, 0, 50 }}}, true, function(_, _, s)
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
                                if rsltretirerjouer then
                                    TriggerServerEvent("dakom:removeplayermoney", IdSelected, rsltretirerjouer)
                                    Notif("~r~-$" ..rsltretirerjouer.. "~s~ a ~b~" ..GetPlayerName(GetPlayerFromServerId(IdSelected)))
                                end
                            end
                        end
                    end)

                    RageUI.Separator("↓ ~r~Important~s~ ↓")

                    RageUI.Button("Supprimer Toutes les armes", nil, {RightBadge = RageUI.BadgeStyle.Alert, Color = { HightLightColor = { 255, 0, 0, 150 }}}, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("dakom:removeallweapon", IdSelected)
                            AdvancedNotif("Armes", "Administration", "Toutes les armes du joueur ~o~" ..GetPlayerName(GetPlayerFromServerId(IdSelected)).. "~s~ on était supprimer de sont inventaire", "CHAR_ARTHUR", 1)
                        end
                    end)

                    RageUI.Button("Déconnectez le Joueur", nil, {RightBadge = RageUI.BadgeStyle.Alert, Color = { HightLightColor = { 255, 0, 0, 150 }}}, true, function(_, _, s)
                        if s then
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 20)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0);
                                Wait(1)
                                end
                                local resultraison = GetOnscreenKeyboardResult()
                            if resultraison == "" then
                                Notif("~o~Admin\n~r~Vous n'avez pas fourni de raison valable")
                            else   
                                if resultraison then
                                    local raisonkick = GetOnscreenKeyboardResult()
                                    Notif("~b~Vous venez de kick ~s~ ".. GetPlayerName(GetPlayerFromServerId(IdSelected)))
                                    TriggerServerEvent("dakom:kickplayer", IdSelected, raisonkick) 
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
                        RageUI.Separator("Groupes: ~r~" ..dakomm.usergroup)
                        RageUI.Separator("Date de Naissance: ~o~" ..dakomm.dob)

                        if dakomm.sex == "m" then
                            RageUI.Separator("Sexe: ~b~Homme~s~")
                        end
                        if dakomm.sex == "f" then
                            RageUI.Separator("Sexe: ~p~Femme~s~")
                        end
                        RageUI.Separator("Taille: ~o~" ..dakomm.height.. " cm")
                    end

                end, function() 
                end)
			end
		end)
	end
end

local function getUserGroup()
    ESX.TriggerServerCallback("dakom:getUserGroup", function(plyGroup)
        Group = plyGroup
        if Group ~= nil and (Group == "superadmin") then
            Notif("tu est superadmin")
            openAdminMenu()
        else
            if Group ~= nil and (Group == "admin") then
                Notif("tu est admin")
                openAdminMenu()
            end
            if Group ~= nil and (Group == "mod") then
                Notif("tu est modérateur")
                openAdminMenu()
            end
        end
    end, false)
end

CreateThread(function()
    while true do
        Wait(5)

        if IsControlJustPressed(1, iAdmin.OpenMenuPressed) then
            getUserGroup()
        end

        if IsControlPressed(1, iAdmin.TeleportPressed1) and IsControlJustPressed(1, iAdmin.TeleportPressed2) then
            TeleportBlips()
        end
    end
end)


RegisterCommand("tpm", function()
    ESX.TriggerServerCallback("dakom:getUserGroup", function(plyGroup)
    if plyGroup ~= nil and (plyGroup == "mod") then
        TeleportBlips()
    else
        Notif("~r~Tu n'a pas le grade requis pour accèder a cette commande")
    end
    if plyGroup ~= nil and (plyGroup == "admin") then
        TeleportBlips()
    end
    end, false)
end)

function getUserGroup()
    ESX.TriggerServerCallback("dakom:getUserGroup", function(plyGroup)
        Group = plyGroup
        if Group ~= nil and (Group == "superadmin") then
            Notif("tu est superadmin")
            openAdminMenu()
        else
            if Group ~= nil and (Group == "admin") then
                Notif("tu est admin")
                openAdminMenu()
            end
            if Group ~= nil and (Group == "mod") then
                Notif("tu est modérateur")
                openAdminMenu()
            end
        end
    end, false)
end


local function SpawnPlayer()
CreateThread(function()
    while not PlayerLoaded do
        Wait(10)
    end
    if PlayerLoaded then
        Mugshot("Administration", "Aide", iAdmin.MessagePlayerSpawn ..iAdmin.ToucheOpen)
    end
end)
end

AddEventHandler("playerSpawned", function()
    SpawnPlayer()
end)

---------------------- VSYNC ------------------------------------

---------------------- VSYNC ------------------------------------
CurrentWeather = 'EXTRASUNNY'
local lastWeather, baseTime, timeOffset, timer, freezeTime, blackout = CurrentWeather, 0, 0, 0, false, false

RegisterNetEvent('vSync:updateWeather') AddEventHandler('vSync:updateWeather', function(NewWeather, newblackout) CurrentWeather = NewWeather blackout = newblackout end)

CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Wait(15000)
        end
        Wait(100) -- Wait 0 seconds to prevent crashing.
        SetBlackout(blackout)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

RegisterNetEvent('vSync:updateTime') AddEventHandler('vSync:updateTime', function(base, offset, freeze) freezeTime = freeze timeOffset = offset baseTime = base end)

CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        Wait(0)
        local newBaseTime = baseTime
        if GetGameTimer() - 500  > timer then
            newBaseTime = newBaseTime + 0.25
            timer = GetGameTimer()
        end
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
        hour = math.floor(((baseTime+timeOffset)/60)%24)
        minute = math.floor((baseTime+timeOffset)%60)
        NetworkOverrideClockTime(hour, minute, 0)
    end
end)

AddEventHandler('playerSpawned', function() TriggerServerEvent('vSync:requestSync') end)


active = true  
AddEventHandler("onClientResourceStart", function(resourceName)
    if active then
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end TriggerServerEvent("logs:client", 3066993, "La resource **" ..resourceName.. "** a été démarré sur le serveur: \n\n**" ..GetCurrentServerEndpoint().. "**", "https://discord.com/api/webhooks/803640052492009562/W6HdCTUNPcAMJlQNpsSaZQ5tnNz7kbb4ulpJe73sQTO6PVqsEnkdXlZ42If-h5Z7Rxhk") else
    end
end)