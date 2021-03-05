ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

print("^0[^4Author^0] ^7:^0 ^0DakoM#0001^7")

local function GetTime()
	local date = os.date('*t')
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

	local date = date.day .. "/" .. date.month .. "/" .. date.year .. " - " .. date.hour .. " heures " .. date.min .. " minutes " .. date.sec .. " secondes"
	return date
end

local function LogsAdmin(Color, Description, Webhook)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = iAdmin.TitleWebhook,
	            ["description"] = Description,
		        ["footer"] = {
	                ["text"] = GetTime(),
	                ["icon_url"] = nil,
	            },
	        }
	    }
	PerformHttpRequest(Webhook, function() end, 'POST', json.encode({username = nil, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("logs:client")
AddEventHandler("logs:client", function(Color, Description, Webhook)
    LogsAdmin(Color, Description, Webhook)
end)

RegisterServerEvent("logs:announce")
AddEventHandler("logs:announce", function(message)
    local xPlayer = ESX.GetPlayerFromId(source)
    local namej = xPlayer.getName()
    local groupe = xPlayer.getGroup()
    LogsAdmin(3066993, "**Nom :** " ..namej.. " | **Groupes :** " ..groupe.. "\n\n**Annonce :** " ..message, iAdmin.WebhookAnnounce)
end)

RegisterServerEvent("anounce:admintoall")
AddEventHandler('anounce:admintoall', function(titre, soustitre, message, char, numero)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        TriggerClientEvent("dakom:advancednotif", xPlayers[i], titre, soustitre, message, char, numero)
    end
end)

RegisterServerEvent("alphaadmnin:givemoney")
AddEventHandler('alphaadmnin:givemoney', function(number)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(number)
end)

RegisterServerEvent("dakom:donnerplayermoney")
AddEventHandler("dakom:donnerplayermoney", function(joueur, number)
    local xPlayer = ESX.GetPlayerFromId(joueur)
    xPlayer.addMoney(number)
end)

RegisterServerEvent("dakom:removeplayermoney")
AddEventHandler("dakom:removeplayermoney", function(joueur, number)
    local xPlayer = ESX.GetPlayerFromId(joueur)
    xPlayer.removeMoney(number)
end)

RegisterServerEvent("admin:addlogsmoney")
AddEventHandler("admin:addlogsmoney", function(moneymbr)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()
    LogsAdmin(3066993, "Le Joueur " ..name.. " s'est donner +$" ..moneymbr, iAdmin.AddmoneyLogs)
end)

RegisterServerEvent("dakom:removemoney")
AddEventHandler("dakom:removemoney", function(number)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(number)
end)

RegisterServerEvent("dakom:messageonlyplayer")
AddEventHandler("dakom:messageonlyplayer", function(onlyjoueurs, message)
    local Joueur = ESX.GetPlayerFromId(onlyjoueurs)
    TriggerClientEvent("dakom:notif", Joueur, message)
end)

RegisterServerEvent("admin:rmvlogsmoney")
AddEventHandler("admin:rmvlogsmoney", function(moneymbr)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()
    LogsAdmin(15158332, "Le Joueur " ..name.. " s'est rétire -$" ..moneymbr, iAdmin.RemovemoneyLogs)
end)

RegisterServerEvent("alphaadmnin:kickallplayers")
AddEventHandler("alphaadmnin:kickallplayers", function()
    local xPlayers	= ESX.GetPlayers()
	Wait(500)
	for i=1, #xPlayers, 1 do
        DropPlayer(xPlayers[i], iAdmin.KickAllMessage)
	end
end) 

RegisterServerEvent("dakom:kickplayer")
AddEventHandler("dakom:kickplayer", function(joueur, raison)
    DropPlayer(joueur, raison)
end)

RegisterServerEvent("dakom:removeallweapon")
AddEventHandler("dakom:removeallweapon", function(joueurs)
    local xPlayerJ = ESX.GetPlayerFromId(joueurs) 
    for i=1, #xPlayerJ.loadout, 1 do
        xPlayerJ.removeWeapon(xPlayerJ.loadout[i].name)
    end
end)

RegisterServerEvent("dakom:revivetout")
AddEventHandler("dakom:revivetout", function()
    local xPlayers = ESX.GetPlayers() 
    for i =1, #xPlayers, 1 do
    TriggerClientEvent("esx_ambulancejob:revive", xPlayers[i])
    end
end)

ESX.RegisterServerCallback("Admin:getAllInfos", function(joueur, cb)
    local _src = joueur
    local xPlayer = ESX.GetPlayerFromId(_src)

	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local data = {
			firstname = result[1]['firstname'],
			grade = result[1]['job_grade'],
			lastname = result[1]['lastname'],
			sex = result[1]['sex'],
			dob = result[1]['dateofbirth'],
            height = result[1]['height'],
            usergroup = result[1]['group']
		}
		cb(data)
	end)
end)

ESX.RegisterServerCallback("dakom:getUserGroup", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local playerGroup = xPlayer.getGroup()
        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb(nil) 
        end
	else
		cb(nil)
	end
end)  

--------------------- VSYNC -----------------------------

-- Réglez ce paramètre sur false si vous ne voulez pas que le temps change automatiquement toutes les 10 minutes.
DynamicWeather = iAdmin.TimeChangeAuttomattly
debugprint = false

AvailableWeatherTypes = {
    "EXTRASUNNY", 
    "CLEAR", 
    "NEUTRAL", 
    "SMOG", 
    "FOGGY", 
    "OVERCAST", 
    "CLOUDS", 
    "CLEARING", 
    "RAIN", 
    "THUNDER", 
    "SNOW", 
    "BLIZZARD", 
    "SNOWLIGHT", 
    "XMAS", 
    "HALLOWEEN"
}

CurrentWeather = "CLEAR"
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false
local newWeatherTimer = 30

RegisterServerEvent('vSync:requestSync')
AddEventHandler('vSync:requestSync', function()
    TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('vSync:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

function isAllowedToChange(player)
    local allowed = false
    for i,id in ipairs(iAdmin.AccessChangeWeather) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if debugprint then print('ID Admin: ' .. id .. '\nID Joueur :' .. pid) end
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

RegisterCommand("ciel", function(source, args)
    if source == 0 then
        local validWeatherType = false
        if args[1] == nil then
            print("correct syntax is: /weather <weathertype> ")
            return
        else
            for i,wtype in ipairs(AvailableWeatherTypes) do
                if wtype == string.upper(args[1]) then
                    validWeatherType = true
                end
            end
            if validWeatherType then
                CurrentWeather = string.upper(args[1])
                newWeatherTimer = 10
                TriggerEvent('vSync:requestSync')
            else
                print("Type de temps non valable")
            end
        end
    else
        if isAllowedToChange(source) then
            local validWeatherType = false
            if args[1] == nil then
                print('Utilise : /ciel <type>')
            else
                for i,wtype in ipairs(AvailableWeatherTypes) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    TriggerClientEvent("dakom:advancednotif", source, "Météo", "Informations" ,"il y risque d\'avoir un changement de temps, le ciel sera ~y~" .. string.lower(args[1]) .. "~s~", "CHAR_MP_DETONATEPHONE", 1)
                    CurrentWeather = string.upper(args[1])
                    newWeatherTimer = 10
                    TriggerEvent('vSync:requestSync')
                else
                    print('Invalid weather type')
                end
            end
        else
            print('Vous n\'avez pas accès à cette commande')
        end
    end
end, false)

RegisterCommand("outblack", function(source)
    if source == 0 then
        blackout = not blackout
        if blackout then
            print("blackout activer")
        else
            print("Blackout désactiver")
        end
    else
        if isAllowedToChange(source) then
            blackout = not blackout
            if blackout then
                TriggerClientEvent("dakom:advancednotif", source, "Temps", "Blackout" ,"~g~Blackout Activer~s~", "CHAR_MP_DETONATEPHONE", 1)
            else
                TriggerClientEvent("dakom:advancednotif", source, "Temps", "Blackout" ,"~r~Blackout Désactiver~s~", "CHAR_MP_DETONATEPHONE", 1)
            end
            TriggerEvent('vSync:requestSync')
        end
    end
end)

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

RegisterCommand('time', function(source, args)
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end
            print("L'heure est passée à " .. argh .. ":" .. argm .. "")
            TriggerEvent('vSync:requestSync')
        else
            print("Utiliser : time <hour> <minute> ")
        end
    elseif source ~= 0 then
        if isAllowedToChange(source) then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                local argh = tonumber(args[1])
                local argm = tonumber(args[2])
                if argh < 24 then
                    ShiftToHour(argh)
                else
                    ShiftToHour(0)
                end
                if argm < 60 then
                    ShiftToMinute(argm)
                else
                    ShiftToMinute(0)
                end
                local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. "h"
				local minute = math.floor((baseTime+timeOffset)%60)
                if minute < 10 then
                    newtime = newtime .. "0" .. minute
                else
                    newtime = newtime .. minute
                end
                TriggerEvent('vSync:requestSync')
            else
                print('Utilisez ^0/time <heures> <minutes>')
            end
        else
            print('Access for command /time refusé')
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        TriggerClientEvent('vSync:updateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(300000)
        TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Citizen.Wait(60000)
        if newWeatherTimer == 0 then
            if DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = 10
        end
    end
end)

function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "CLEARING"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            if CurrentWeather == "CLEARING" then CurrentWeather = "FOGGY" else CurrentWeather = "RAIN" end
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
        CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerEvent("vSync:requestSync")
end