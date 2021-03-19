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

	local date = date.day .. "/" .. date.month .. "/" .. date.year .. " - " .. date.hour .. "h" .. date.min
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
	                ["icon_url"] = iAdmin.FooterLogoDiscord,
	            },
	        }
	    }
	PerformHttpRequest(Webhook, function() end, 'POST', json.encode({username = iAdmin.BOTName, embeds = Content}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("logs:announce")
AddEventHandler("logs:announce", function(message)
    local xPlayer = ESX.GetPlayerFromId(source)
    local namej = xPlayer.getName()
    local groupe = xPlayer.getGroup()
    LogsAdmin(3066993, "**Nom:** " ..namej.. " | **Groupes:** " ..groupe.. "\n\n**Annonce:** " ..message, iAdmin.WebhookAnnounce)
end)

RegisterServerEvent("anounce:admintoall")
AddEventHandler('anounce:admintoall', function(titre, soustitre, message, char, numero)
    TriggerClientEvent("dakom:advancednotif", -1, titre, soustitre, message, char, numero)
end)

RegisterServerEvent("dakomm:giveoremovecash")
AddEventHandler('dakomm:giveoremovecash', function(typee, number)
    local xPlayer = ESX.GetPlayerFromId(source)
    if typee == "addmoney" then
        xPlayer.addMoney(number)
        TriggerClientEvent("dakom:notif", source, "Tu t'es donner ~g~+$" ..number)
        LogsAdmin(3066993, "Le Staff **" ..xPlayer.getName().. "** s'est donner +$" ..number.. "\n**Groupes:** " ..xPlayer.getGroup(), iAdmin.AddmoneyLogs)
    elseif typee == "rmvmoney" then
        if xPlayer.getMoney() >= tonumber(number) then
            xPlayer.removeMoney(number)
            TriggerClientEvent("dakom:notif", source, "Tu as retiré ~r~-$" ..number)
            LogsAdmin(15158332, "Le Staff **" ..xPlayer.getName().. "** s'est rétire -$" ..number.. "\n**Groupes:** " ..xPlayer.getGroup(), iAdmin.RemovemoneyLogs)
        else
            TriggerClientEvent("dakom:notif", source, "~r~Tu n'a pas assez d'argent pour retirer tout ca")
        end
    end
end)

RegisterServerEvent("dakom:playeractionsmoney")
AddEventHandler("dakom:playeractionsmoney", function(joueur, number)
    if typee == "addplayercashmoney" then
        local Player = ESX.GetPlayerFromId(joueur)
        Player.addMoney(number)
    elseif typee == "removeplayercashmoney" then
        local Player = ESX.GetPlayerFromId(joueur)
        Player.removeMoney(number)
    end
end)

RegisterServerEvent("dakom:removeplayermoney")
AddEventHandler("dakom:removeplayermoney", function(joueur, number)
    local xPlayer = ESX.GetPlayerFromId(joueur)
    xPlayer.removeMoney(number)
end)

RegisterServerEvent("dakom:messageonlyplayer")
AddEventHandler("dakom:messageonlyplayer", function(onlyjoueurs, message)
    local Joueur = ESX.GetPlayerFromId(onlyjoueurs)
    TriggerClientEvent("dakom:notif", Joueur, message)
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

RegisterServerEvent("dakom:adminoptionsall")
AddEventHandler("dakom:adminoptionsall", function(typee)
    if typee == "reviveall" then
        TriggerClientEvent("ambulance:revive", -1)
    elseif typee == "kickall" then
        DropPlayer(-1, iAdmin.KickAllMessage)
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
			lastname = result[1]['lastname'],
			sex = result[1]['sex'],
			dob = result[1]['dateofbirth'],
            height = result[1]['height'],
            usergroup = result[1]['group'],
            liquide = result[1]['money'],
            jobbing = result[1]['job']
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
