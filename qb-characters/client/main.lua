local QBCore = exports['qb-core']:GetCoreObject()
local SpawnCam, charPed = nil, nil


RegisterNetEvent('QBCore:Client:CloseNui', function()
    SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if NetworkIsSessionStarted() then
			StartCharScreen()
			return
		end
	end
end)

-- // Code \\ --

-- // Events \\ --

RegisterNetEvent('qb-multicharacter:client:chooseChar', function()
    StartCharScreen()
end)


RegisterNetEvent('qb-characters:client:selectChar', function(CharId)
    QBCore.Functions.TriggerCallback('qb-characters:server:get:char:data:manual', function(result)
        if result ~= nil then
            QBCore.Functions.TriggerCallback('qb-characters:server:logout:player', function(yeet) end)
            Citizen.Wait(650)
            TriggerServerEvent('qb-characters:server:load:user:data', result)
        else
            QBCore.Functions.Notify("You don't even have this char?", "error", 2500)
        end
    end, CharId)
end)

RegisterNetEvent('qb-characters:client:starting:point', function() -- This event is only for no starting apartments
    LocalPlayer.state:set('FirstCharacter', true, false)
    DoScreenFadeOut(500)
    SetEntityVisible(PlayerPedId(), true)
    Citizen.Wait(2000)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerEvent('fivem-appearance:client:CreateFirstCharacter')
end)

-- // NUI Callbacks \\ --

RegisterNUICallback('CloseUI', function()
    OpenCharMenu(false)
end)

RegisterNUICallback('DisconnectButton', function()
    SetEntityAsMissionEntity(charPed, true, true)
    DeleteEntity(charPed)
    TriggerServerEvent('qb-characters:server:disconnect')
end)

local currentTattoos = {}

RegisterNUICallback('cDataPed', function(data, cb)
    local cData = data.cData  
    if charPed ~= nil then
        TaskGoStraightToCoord(charPed, Config.Characters["StartPedCoords"].x, Config.Characters["StartPedCoords"].y, Config.Characters["StartPedCoords"].z - 0.98, 1.0, -1, Config.Characters["StartPedCoords"].h)
        Citizen.Wait(2500)
        SetEntityAsMissionEntity(charPed, true, true)
        DeleteEntity(charPed) 
        Citizen.Wait(150)
    end
    if cData ~= nil then
        QBCore.Functions.TriggerCallback('qb-characters:server:getSkin', function(skinData)
            if skinData then
                local model = joaat(skinData.model)
                CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(10)
                    end
                    charPed = CreatePed(2, model, Config.Characters["StartPedCoords"].x, Config.Characters["StartPedCoords"].y, Config.Characters["StartPedCoords"].z - 0.98, Config.Characters["StartPedCoords"].h, false, false)
                    SetEveryoneIgnorePlayer(charPed, true)
                    NetworkSetEntityInvisibleToNetwork(charPed, true)
                    SetEntityInvincible(charPed, true)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    SetPedConfigFlag(charPed, 410, true)
                    SetEntityCanBeDamagedByRelationshipGroup(charPed, false, GetHashKey('PLAYER'))
                    FreezeEntityPosition(charPed, false)
                    SetEntityAsMissionEntity(charPed, true, true)
                    PlaceObjectOnGroundProperly(charPed)
                    TaskGoStraightToCoord(charPed, Config.Characters["PedCoords"].x, Config.Characters["PedCoords"].y, Config.Characters["PedCoords"].z - 0.98, 1.0, -1, Config.Characters["PedCoords"].h)
                    Citizen.SetTimeout(3000, function()
                        SendNUIMessage({
                            action = "EnableCharSelector"
                        })
                    end)
                    exports['fivem-appearance']:setPedAppearance(charPed, skinData)
                end)
            else
                CreateThread(function()
                    local randommodels = {
                        "mp_m_freemode_01",
                        "mp_f_freemode_01",
                    }
                    local model = GetHashKey(randommodels[math.random(1, #randommodels)])
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(10)
                    end
                    charPed = CreatePed(2, model, Config.Characters["StartPedCoords"].x, Config.Characters["StartPedCoords"].y, Config.Characters["StartPedCoords"].z - 0.98, Config.Characters["StartPedCoords"].h, false, false)
                    SetEveryoneIgnorePlayer(charPed, true)
                    NetworkSetEntityInvisibleToNetwork(charPed, true)
                    SetEntityInvincible(charPed, true)
                    SetBlockingOfNonTemporaryEvents(charPed, true)
                    SetPedConfigFlag(charPed, 410, true)
                    SetEntityCanBeDamagedByRelationshipGroup(charPed, false, GetHashKey('PLAYER'))
                    FreezeEntityPosition(charPed, false)
                    SetEntityAsMissionEntity(charPed, true, true)
                    PlaceObjectOnGroundProperly(charPed)
                    TaskGoStraightToCoord(charPed, Config.Characters["PedCoords"].x, Config.Characters["PedCoords"].y, Config.Characters["PedCoords"].z - 0.98, 1.0, -1, Config.Characters["PedCoords"].h)
                    Citizen.SetTimeout(3000, function()
                        SendNUIMessage({
                            action = "EnableCharSelector"
                        })
                    end)
                end)
            end
        end, cData.citizenid)
    else
        Citizen.CreateThread(function()
            local randommodels = {
                "mp_m_freemode_01",
                "mp_f_freemode_01",
            }
            local model = GetHashKey(randommodels[math.random(1, #randommodels)])
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            charPed = CreatePed(2, model, Config.Characters["StartPedCoords"].x, Config.Characters["StartPedCoords"].y, Config.Characters["StartPedCoords"].z - 0.98, Config.Characters["StartPedCoords"].h, false, false)
            SetEveryoneIgnorePlayer(charPed, true)
            NetworkSetEntityInvisibleToNetwork(charPed, true)
            SetEntityInvincible(charPed, true)
            SetBlockingOfNonTemporaryEvents(charPed, true)
            SetPedConfigFlag(charPed, 410, true)
            SetEntityCanBeDamagedByRelationshipGroup(charPed, false, GetHashKey('PLAYER'))
            FreezeEntityPosition(charPed, false)
            SetEntityAsMissionEntity(charPed, true, true)
            PlaceObjectOnGroundProperly(charPed)
            TaskGoStraightToCoord(charPed, Config.Characters["PedCoords"].x, Config.Characters["PedCoords"].y, Config.Characters["PedCoords"].z - 0.98, 1.0, -1, Config.Characters["PedCoords"].h)
            Citizen.SetTimeout(3000, function()
                SendNUIMessage({
                    action = "EnableCharSelector"
                })
            end)
        end)
    end
end)


function SpawnDefaultPed()
    Citizen.CreateThread(function()
        local randommodels = {
            "mp_m_freemode_01",
            "mp_f_freemode_01",
        }
        local model = GetHashKey(randommodels[math.random(1, #randommodels)])
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
        charPed = CreatePed(2, model, Config.Characters["StartPedCoords"].x, Config.Characters["StartPedCoords"].y, Config.Characters["StartPedCoords"].z - 0.98, Config.Characters["StartPedCoords"].h, false, false)
        NetworkSetEntityInvisibleToNetwork(charPed, true)
        SetPedComponentVariation(charPed, 0, 0, 0, 2)
        FreezeEntityPosition(charPed, false)
        SetEntityInvincible(charPed, true)
        SetEntityCanBeDamagedByRelationshipGroup(charPed, false, `PLAYER`)
        PlaceObjectOnGroundProperly(charPed)
        SetBlockingOfNonTemporaryEvents(charPed, true)
        TaskGoStraightToCoord(charPed, Config.Characters["PedCoords"].x, Config.Characters["PedCoords"].y, Config.Characters["PedCoords"].z - 0.98, 1.0, -1, Config.Characters["PedCoords"].h)
        Citizen.SetTimeout(3000, function()
            SendNUIMessage({
                action = "EnableCharSelector"
            })
        end)
    end) 
end

function StartCharScreen()
    TriggerEvent('cd_easytime:PauseSync', true, 18)
    DoScreenFadeOut(10)
    Citizen.Wait(1000)
    local Interior = GetInteriorAtCoords(976.6364, 70.29476, 115.164131)
    LoadInterior(Interior)
    while not IsInteriorReady(Interior) do
        Citizen.Wait(1000)
    end
    OpenCharMenu(true)
    -- LoadTattoos(true)
    SetEntityCoords(PlayerPedId(), Config.Characters["HiddenCoords"].x, Config.Characters["HiddenCoords"].y, Config.Characters["HiddenCoords"].z)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityVisible(PlayerPedId(), false)
    -- weather shit here 
    Citizen.Wait(750)
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    DoScreenFadeIn(1000)
end

RegisterNUICallback('SetupCharacters', function()
    QBCore.Functions.TriggerCallback("qb-characters:server:get:char:data", function(result)
        SendNUIMessage({
            action = "SetupCharacters",
            characters = result
        })
    end)
end)

RegisterNUICallback('SelectCharacter', function(data)
    local cData = data.cData
    TaskGoStraightToCoord(charPed, Config.Characters["EndPedCoords"].x, Config.Characters["EndPedCoords"].y, Config.Characters["EndPedCoords"].z - 0.98, 1.0, -1, Config.Characters["EndPedCoords"].h)
    Citizen.SetTimeout(2000, function()
        DoScreenFadeOut(10)
        Citizen.Wait(150)
        NetworkRequestControlOfEntity(charPed)
        DeleteEntity(charPed)
        TriggerServerEvent('qb-characters:server:load:user:data', cData)
        OpenCharMenu(false)
        SetEntityAsMissionEntity(charPed, true, true)
        charPed = nil
    end)
end)

RegisterNUICallback('CreateNewCharacter', function(data)
    local cData = data
    if cData.gender == "male" then
        cData.gender = 0
    elseif cData.gender == "female" then
        cData.gender = 1
    end
    TaskGoStraightToCoord(charPed, Config.Characters["EndPedCoordsCreated"].x, Config.Characters["EndPedCoordsCreated"].y, Config.Characters["EndPedCoordsCreated"].z - 0.98, 1.0, -1, Config.Characters["StartPedCoords"].h)
    Citizen.SetTimeout(2000, function()
        DoScreenFadeOut(150)
        Citizen.Wait(150)
        NetworkRequestControlOfEntity(charPed)
        DeleteEntity(charPed)
        OpenCharMenu(false)
        charPed = nil
        TriggerServerEvent('qb-characters:server:createCharacter', cData)
    end)
end)

RegisterNUICallback('RemoveCharacter', function(data)
    TaskGoStraightToCoord(charPed, Config.Characters["EndPedCoordsCreated"].x, Config.Characters["EndPedCoordsCreated"].y, Config.Characters["EndPedCoordsCreated"].z - 0.98, 1.0, -1, Config.Characters["StartPedCoords"].h)
    Citizen.SetTimeout(2500, function()
        DoScreenFadeOut(10)
        SetEntityAsMissionEntity(charPed, true, true)
        DeleteEntity(charPed)
        OpenCharMenu(false)
        charPed = nil
        TriggerServerEvent('qb-characters:server:deleteCharacter', data.citizenid)
    end)
end)

-- // Functions \\ --

function SetCam(bool)
    DestroyAllCams()
    SpawnCam = nil
    if SpawnCam == nil then
        SpawnCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",Config.Characters["CamCoords"].x, Config.Characters["CamCoords"].y, Config.Characters["CamCoords"].z, -3.00, 0.00, 91.17, 50.00, false, 0)
        SetCamActive(SpawnCam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        DestroyAllCams()
        SpawnCam = nil
    end
end

function OpenCharMenu(Bool)
    SetNuiFocus(Bool, Bool)
    SendNUIMessage({
        action = "ui",
        toggle = Bool,
    })
    SetCam(Bool)
end

-- Delete Ped
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        SetEntityAsMissionEntity(charPed, true, true)
        DeleteEntity(charPed)
    end
end)

function SetSkyCam(bool)
    if bool then
          Cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -265.51, -811.01, 31.85 + 300, -85.00, 0.00, 0.00, 100.00, false, 0)
          SetCamActive(Cam, true)
          SetFocusArea(-265.51, -811.01, 31.85 + 175, 0.0, 0.0, 0.0)
          ShakeCam(Cam, "HAND_SHAKE", 0.15)
          SetEntityVisible(PlayerPedId(), false)
          RenderScriptCams(true, false, 3000, 1, 1)
    else
        if DoesCamExist(Cam) then
          RenderScriptCams(false, true, 500, true, true)
          SetCamActive(Cam, false)
          DestroyCam(Cam, true)
        end
        SetFocusEntity(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityVisible(PlayerPedId(), true)
    end
end


RegisterNetEvent('Spawnappart1:getout', function(data)
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), vec3(-1447.6859130859,-537.29974365234,34.740119934082))
    SetEntityHeading(PlayerPedId(), 214.19271850586)
    if LocalPlayer.state.FirstCharacter then
        LocalPlayer.state:set('FirstCharacter', false, false)
        TriggerServerEvent('qb-apartments:server:RoutingBucket')
    end
    Wait(1000)
    DoScreenFadeIn(1000)
end)

-- CreateThread(function()
--     Wait(1000)
--     exports['qb-target']:AddBoxZone("spawngetuot1", vector3(-1451.25, -540.52, 74.04), 0.4, 0.2, {
--         name="spawngetuot1",
--         heading=35,
--         --debugPoly=true,
--         minZ=74.04,
--         maxZ=74.44
--     }, {
--         options = { 
--         { 
--             type = "client", 
--             event = "Spawnappart1:getout",  
--             icon = 'fas fa-example', 
--             label = 'Get Out', 
--         }
--         },
--         distance = 2.0, 
--     })
-- end)

RegisterNetEvent('qb-characters:client:setupSpawns', function(cData, new, apps)
    if not new then
        local ped = PlayerPedId()
        local PlayerData = QBCore.Functions.GetPlayerData()
        QBCore.Functions.GetPlayerData(function(PlayerData)
            SetEntityCoords(PlayerPedId(), PlayerData.position.x, PlayerData.position.y, PlayerData.position.z)
            SetEntityHeading(PlayerPedId(), PlayerData.position.h)
            FreezeEntityPosition(PlayerPedId(), false)
        end)
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        DoScreenFadeOut(500)
        Wait(2000)
        FreezeEntityPosition(PlayerPedId(), false)
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        SetCamActive(cam2, false)
        DestroyCam(cam2, true)
        SetEntityVisible(PlayerPedId(), true)
        Wait(500)
        DoScreenFadeIn(250)
    elseif new then
        local ped = PlayerPedId()
        DoScreenFadeOut(500)
        Wait(5000)
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        FreezeEntityPosition(ped, false)
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        SetCamActive(cam2, false)
        DestroyCam(cam2, true)
        SetEntityVisible(ped, true)
        SetEntityHealth(ped, 200)
        NetworkFadeOutEntity(ped, true, false)
        Citizen.Wait(250)
        FreezeEntityPosition(ped,false)
        SetEntityCoords(ped, 974.86041259766,64.578681945801,116.16416168213)
        SetEntityHeading(ped, 326.63674926758)
        NetworkFadeInEntity(ped, 0)
        Wait(1000)
        DoScreenFadeIn(250)
        Wait(1000)
        TriggerEvent('qb-clothes:client:CreateFirstCharacter')
    end
    TriggerEvent('cd_easytime:PauseSync', false)
end)


CreateThread(function()
    local Box = lib.zones.box({
        name = "hotelspawn",
        coords = vec3(982.49, 64.99, 116.5),
        size = vec3(4.0, 4.0, 2.75),
        rotation = 330.0,
        debug = false,
        onEnter = function(_)
            lib.showTextUI('[ E ] Leave', {
                position = "left-center",
            })
        end,
        onExit = function(_)
            lib.hideTextUI()
        end,
        inside = function(_)
            if IsControlJustReleased(0, 38) then
                local ped = PlayerPedId()
                SetEntityCoords(ped, 923.41754150391,47.151775360107,81.106323242188)
                SetEntityHeading(ped, 65.09691619873)
            end
        end
    })
end)