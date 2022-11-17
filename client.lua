local QBCore = exports['qb-core']:GetCoreObject()

local loc = math.random(1, #Config.LocationSets)

--print("loc:"..json.encode(Config.LocationSets[loc]))

RegisterNetEvent('Blackmarket:client:openstore', function()
    if GetClockHours() >= Config.Open and GetClockHours() <= Config.Close then
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "data",
            item = Config.items
        })
    else
        Config.Functions.Notify("Come back another time.", 'error', false)
    end    
end)

RegisterNUICallback("itemdata", function(data, cb)
    money = tonumber(data.price)
    itemname = data.itemcode
    itemstring = data.itemsname
    TriggerServerEvent('Blackmarket:server:itemgo', money, itemname, itemstring)
end)

RegisterNUICallback('escape', function()
    SetNuiFocus(false, false)
end)

if Config.Test_Command then
    RegisterCommand('market', function()
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "data",
            item = Config.items
        })
    end)
end

CreateThread(function()
    RequestModel('s_m_y_dealer_01')
    while not HasModelLoaded('s_m_y_dealer_01') do
        Wait(0)
    end
    local entity = CreatePed(0, 's_m_y_dealer_01', vector3(Config.LocationSets[loc].x, Config.LocationSets[loc].y, Config.LocationSets[loc].z - 1.03), Config.LocationSets[loc].w, true, false)
    NetworkRegisterEntityAsNetworked(entity)
    entitynetworkID = NetworkGetNetworkIdFromEntity(entity)
    SetNetworkIdCanMigrate(entitynetworkID, true)
    SetNetworkIdExistsOnAllMachines(entitynetworkID, true)
    SetPedRandomComponentVariation(entity, 0)
    SetPedRandomProps(entity)
    SetEntityAsMissionEntity(entity)
    SetEntityVisible(entity, true)
    SetPedFleeAttributes(entity, 0, false)
    FreezeEntityPosition(entity, true)
    
    exports['qb-target']:AddEntityZone("blackmarket_v2", entity, {
        name = "blackmarket_v2",
        debugPoly = true
    }, {
        options = {{
            type = "client",
            event = "Blackmarket:client:openstore",
            icon = "fas fa-box",
            label = "View The Store!"
        }},
        distance = 2.5
    })
end)

AddEventHandler('onResourceStop', function(r)
    if r ~= GetCurrentResourceName() then
        return
    end
    exports['qb-target']:RemoveZone("blackmarket_v2")
end)