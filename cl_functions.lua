function CenterText(msg, time) ClearPrints() BeginTextCommandPrint('STRING') AddTextComponentSubstringPlayerName(msg) EndTextCommandPrint(time, 1) end
function Mugshot(title, subject, msg, player) local mugshot, mugshotStr = ESX.Game.GetPedMugshot(player) AdvancedNotif(title, subject, msg, mugshotStr, 1) UnregisterPedheadshot(mugshot) end
function Notif(msg) SetNotificationTextEntry('STRING') AddTextComponentSubstringPlayerName(msg) DrawNotification(false, true) end
function AdvancedNotif(title, subject, msg, icon, iconType) SetNotificationTextEntry('STRING') AddTextComponentSubstringPlayerName(msg) SetNotificationMessage(icon, icon, false, iconType, title, subject) DrawNotification(false, false) end
function PlayerMarqueur(player) local ped = GetPlayerPed(player) local pos = GetEntityCoords(ped) DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 255, 255, 170, 1, 1, 2, 0, nil, nil, 0) end

RegisterNetEvent("dakom:advancednotif")
AddEventHandler("dakom:advancednotif", function(title, subject, msg, icon, iconType)
    AdvancedNotif(title, subject, msg, icon, iconType)
end)

RegisterNetEvent("dakom:notif")
AddEventHandler("dakom:notif", function(msg)
    Notif(msg)
end)

RegisterNetEvent("dakom:mughshotnotif")
AddEventHandler("dakom:mughshotnotif", function(title, subject, msg, player)
    Mugshot(title, subject, msg, player)
end)

function TeleportBlips()
    local entity = PlayerPedId()
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    local success = false
    local blipFound = false
    local blipIterator = GetBlipInfoIdIterator()
    local blip = GetFirstBlipInfoId(8)
    
    while DoesBlipExist(blip) do
        if GetBlipInfoIdType(blip) == 4 then
            cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector()))
            blipFound = true
            break
        end
        blip = GetNextBlipInfoId(blipIterator)
        Wait(0)
    end
    
    if blipFound then
        local groundFound = false
        local yaw = GetEntityHeading(entity)
        
        for i = 0, 1000, 1 do
            SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
            SetEntityRotation(entity, 0, 0, 0, 0, 0)
            SetEntityHeading(entity, yaw)
            Wait(0)
            if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then
                cz = ToFloat(i)
                groundFound = true
                break
            end
        end
        if not groundFound then
            cz = -300.0
        end
        success = true
    else
        Notif(iAdmin.Nomarkeroffset)
    end
    
    if success then
        SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
                SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
            end
        end
    end
end

function SupprVehicle()
    local pos = GetEntityCoords(PlayerPedId())
    local veh = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
    pos = GetEntityCoords(veh)
    local _, distance = ESX.Game.GetClosestVehicle()
    if distance <= 2.0 then
        local pPed = PlayerPedId()
        if IsPedInAnyVehicle(pPed, false) then
            local pVeh = GetVehiclePedIsIn(pPed, false)
            TaskLeaveAnyVehicle(pPed, 1, 1)
            Wait(2500)
            while IsPedInAnyVehicle(pPed, false) do
                TaskLeaveAnyVehicle(pPed, 1, 1)
                Wait(200)
            end
            DeleteEntity(pVeh)
        else
            Notif("~b~Police\n~r~Tu dois rentrer dans le véhicule~s~")
        end
    else
        Notif("~b~Admin\n~r~Aucun véhicule a proximité~s~")
    end
end

local function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

function SpawnVeh()
    if IsPedInAnyVehicle(PlayerPedId(), -1) then
        Notif("~r~Veuillez sortir du véhicule pour effectuer cette action !")
else
	local vehicleName = KeyboardInput("DAKOM_BOX_VEHICLE_NAME", 'Nom du véhicule', "", 15)
	if vehicleName ~= nil then
		vehicleName = tostring(vehicleName)
		if type(vehicleName) == 'string' then
			local cardako = GetHashKey(vehicleName)
            CreateThread(function()
				RequestModel(cardako)
				while not HasModelLoaded(cardako) do
					Wait(0)
				end
				local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
				local veh = CreateVehicle(cardako, x, y, z, 0.0, true, false)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh, true)
                SetPedIntoVehicle(PlayerPedId(), veh, -1)
            end)
        end
        end
	end
end

-------------------------- FUNCTIONS NOCLIP ------------------------------

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function setupScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(1)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    Button(GetControlInstructionalButton(2, iAdmin.goUp, true))
    ButtonMessage(iAdmin.UpNoclip)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, iAdmin.goDown, true))
    ButtonMessage(iAdmin.DownNoclip)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(1, iAdmin.turnRight, true))
    Button(GetControlInstructionalButton(1, iAdmin.turnLeft, true))
    ButtonMessage(iAdmin.LeftRightNoclip)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(1, iAdmin.goBackward, true))
    Button(GetControlInstructionalButton(1, iAdmin.goForward, true))
    ButtonMessage(iAdmin.ForwardsNoclip)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, iAdmin.changeSpeed, true))
    ButtonMessage(iAdmin.SpeedTextNoclip.. " ("..iAdmin.speeds[index].label..")")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(iAdmin.bgR)
    PushScaleformMovieFunctionParameterInt(iAdmin.bgG)
    PushScaleformMovieFunctionParameterInt(iAdmin.bgB)
    PushScaleformMovieFunctionParameterInt(iAdmin.bgA)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

noclipActive = false
index = 1

CreateThread(function()

    buttons = setupScaleform("instructional_buttons")

    currentSpeed = iAdmin.speeds[index].speed

    while true do
        Wait(1)

        if noclipActive then
            DrawScaleformMovieFullscreen(buttons)

            local yoff = 0.0
            local zoff = 0.0

            if IsControlJustPressed(1, iAdmin.changeSpeed) then
                if index ~= 8 then
                    index = index+1
                    currentSpeed = iAdmin.speeds[index].speed
                else
                    currentSpeed = iAdmin.speeds[1].speed
                    index = 1
                end
                setupScaleform("instructional_buttons")
            end

			if IsControlPressed(0, iAdmin.goForward) then
                yoff = configs.offsets.y
			end
			
            if IsControlPressed(0, iAdmin.goBackward) then
                yoff = -configs.offsets.y
			end
			
            if IsControlPressed(0, iAdmin.turnLeft) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)+configs.offsets.h)
			end
			
            if IsControlPressed(0, iAdmin.turnRight) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)-configs.offsets.h)
			end
			
            if IsControlPressed(0, iAdmin.goUp) then
                zoff = configs.offsets.z
			end
			
            if IsControlPressed(0, iAdmin.goDown) then
                zoff = -configs.offsets.z
			end
			
            local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))
            local heading = GetEntityHeading(noclipEntity)
            SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
            SetEntityHeading(noclipEntity, heading)
            SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, noclipActive, noclipActive, noclipActive)
        end
    end
end)

configs = {
    offsets = {
        y = 0.4,
        z = 0.2,
        h = 3,
    },
}

function MarkerVehicle()
        local pos = GetEntityCoords(PlayerPedId())
        local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
        pos = GetEntityCoords(veh)
        local _, distance = ESX.Game.GetClosestVehicle()
        if distance <= 5.0 then
        DrawMarker(2, pos.x, pos.y, pos.z+1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, iAdmin.ColorMarkVeh.R, iAdmin.ColorMarkVeh.G, iAdmin.ColorMarkVeh.B, iAdmin.ColorMarkVeh.A, 0, 1, 2, 1, nil, nil, 0)
    end
end

--------------------------------- SPECTATE ---------------------------------

function DrawPlayerInfo(target) drawTarget = target drawInfo = true end
function StopDrawPlayerInfo() drawInfo = false drawTarget = 0 end

CreateThread(function()
	while true do
		Wait(0)
        if drawInfo then
            getInformations()
            local text = {}
            local PlayerNamee = GetPlayerName(GetPlayerFromServerId(IdSelected))
            if dakomm then
			table.insert(text,"Vous Regardez le Joueur ~b~" ..PlayerNamee.. "~s~ Groupe: ~r~" ..dakomm.usergroup)
			for i,theText in pairs(text) do
                    SetTextFont(6)
                    SetTextProportional(1)
                    SetTextScale(0.0, 0.55)
                    SetTextEdge(1, 0, 0, 0, 255)
                    SetTextEntry("STRING")
                    AddTextComponentString(theText)
                    EndTextCommandDisplayText(0.350, 0.9+(i/30))
                end
			end
		end
	end
end)

function SpectatePlayer(targetPed,target)
    local playerPed = PlayerPedId()
	enable = true
	if targetPed == playerPed then enable = false end

    if (enable) then
        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(true, targetPed)
		DrawPlayerInfo(target)
    else
        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(false, targetPed)
        StopDrawPlayerInfo()
    end
end