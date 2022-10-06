local QBCore = exports['qb-core']:GetCoreObject()
local active = false
local photoyo = false
local dslrmodel = nil
local frontCam = false
local fov_max = Config.MaxFOV
local fov_min = Config.MinFOV
local zoomspeed = Config.ZoomSpeed
local speed_lr = Config.LRspeed
local speed_ud = Config.UDspeed
local fov = (fov_max+fov_min)*0.5
local takethapicbro = false

local function SharedRequestAnimDict(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(10)
		end
	end
	if cb ~= nil then
		cb()
	end
end

local function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
      RequestModel(GetHashKey(model))
      Wait(10)
    end
end

local function CLOSETHATHING()
    active = false
    takethapicbro = false
    SharedRequestAnimDict("amb@world_human_paparazzi@male@exit", function()
        TaskPlayAnim(ped, "amb@world_human_paparazzi@male@exit", "exit", 2.0, 2.0, -1, 1, 0, false, false, false)
    end)
    Wait(1000)
    ClearPedTasks(PlayerPedId())
    if dslrmodel then DeleteEntity(dslrmodel) end
    ClearPedTasks(PlayerPedId())
end

--FUNCTIONS--
function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1) -- Wanted Stars
    HideHudComponentThisFrame(2) -- Weapon icon
    HideHudComponentThisFrame(3) -- Cash
    HideHudComponentThisFrame(4) -- MP CASH
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(8)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13) -- Cash Change
    HideHudComponentThisFrame(11) -- Floating Help Text
    HideHudComponentThisFrame(12) -- more floating help text
    HideHudComponentThisFrame(15) -- Subtitle Text
    HideHudComponentThisFrame(18) -- Game Stream
    HideHudComponentThisFrame(19) -- weapon wheel
end

function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
        new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(PlayerPedId(),new_z)
    end
end

RegisterNUICallback("Close", function()
    SetNuiFocus(false, false)
    photoyo = false
    if photoprop then DeleteEntity(photoprop) end
    ClearPedTasks(PlayerPedId())
end)

function MAKEITZOOM(cam)
    local lPed = PlayerPedId()
    if not ( IsPedSittingInAnyVehicle( lPed ) ) then
        if IsControlJustPressed(0,241) then
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,242) then
            fov = math.min(fov + zoomspeed, fov_max)
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    else
        if IsControlJustPressed(0,17) then
            fov = math.max(fov - zoomspeed, fov_min)
        end
        if IsControlJustPressed(0,16) then
            fov = math.min(fov + zoomspeed, fov_max)
        end
        local current_fov = GetCamFov(cam)
        if math.abs(fov-current_fov) < 0.1 then
            fov = current_fov
        end
        SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
    end
end

RegisterNetEvent('tlm:client:PedChecks', function()
    local PlyPed = PlayerPedId()
    if not IsPedInAnyVehicle(PlyPed) then
        local PlayerData = QBCore.Functions.GetPlayerData()
        if not PlayerData.metadata["isdead"] and not PlayerData.metadata["inlaststand"] and not PlayerData.metadata["ishandcuffed"] and not IsPauseMenuActive() then
            TriggerEvent('tlm:client:takepicture')
        else
            QBCore.Functions.Notify('You can\'t do this action', 'error', 7500)
        end
    else
        QBCore.Functions.Notify('Cant use this camera in a vehicle', 'error', 7500)
    end
end)

RegisterNetEvent("tlm:client:takepicture", function()
    if not active then
        active = true
        local ped = PlayerPedId()
        SharedRequestAnimDict("amb@world_human_paparazzi@male@base", function()
            TaskPlayAnim(ped, "amb@world_human_paparazzi@male@base", "base", 2.0, 2.0, -1, 1, 0, false, false, false)
        end)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        if not HasModelLoaded("prop_pap_camera_01") then
            LoadPropDict("prop_pap_camera_01")
        end
        dslrmodel = CreateObject(GetHashKey("prop_pap_camera_01"), x, y, z+0.2,  true,  true, true)
        AttachEntityToEntity(dslrmodel, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        CreateThread(function()
            while active do
                Wait(200)
                local lPed = PlayerPedId()
                if active then
                    active = true
                    Wait(500)
                    SetTimecycleModifier("default")
                    SetTimecycleModifierStrength(0.3)
                    local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                    AttachCamToEntity(cam, lPed, 0.0, 0.7, 0.7, true)
                    SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
                    SetCamFov(cam, fov)
                    RenderScriptCams(true, false, 0, 1, 0)
                    while active and true do
                        if IsControlJustPressed(0, 177) then
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            CLOSETHATHING()
                        elseif IsControlJustPressed(1, 176) then
                            if not takethapicbro then
                                takethapicbro = true
                                QBCore.Functions.TriggerCallback("tlm:server:WebHookCheck", function(hook)
                                    if hook then
                                        exports['screenshot-basic']:requestScreenshotUpload(tostring(hook), "files[]", function()
                                            CLOSETHATHING()
                                        end)
                                        QBCore.Functions.Notify('Phototaken', 'success', 900)
                                        Wait(1350)
                                        QBCore.Functions.Notify('Uploading to the Cloud', 'success', 1100)
                                        Wait(1850)
                                        QBCore.Functions.Notify('Photo uploaded!', 'success', 1400)
                                    else
                                        QBCore.Functions.Notify('Contact Server Dev\'s about webhook', 'error', 7500)
                                    end
                                end)
                            end
                        end
                        local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
                        CheckInputRotation(cam, zoomvalue)
                        MAKEITZOOM(cam)
                        HideHUDThisFrame()
                        Wait(1)
                    end
                    CLOSETHATHING()
                    ClearTimecycleModifier()
                    fov = (fov_max+fov_min)*0.5
                    RenderScriptCams(false, false, 0, 1, 0)
                    DestroyCam(cam, false)
                end
            end
        end)
    else
        CLOSETHATHING()
    end
end)
