local QBCore = exports['qb-core']:GetCoreObject()

local setLocPick = math.random(1, #Config['LocationSets'])
local Locations = {
    ["coords"] = {
        [1] = {
            x = tonumber(Config['LocationSets'][setLocPick].x),
            y = tonumber(Config['LocationSets'][setLocPick].y),
            z = tonumber(Config['LocationSets'][setLocPick].z),
            w = tonumber(Config['LocationSets'][setLocPick].w),
        },
    },
}
local position = Locations["coords"]

for k, v in pairs(position) do
    TriggerServerEvent('Blackmarket-V2:server:CreatePed', v.x, v.y, v.z, v.w)
end

if Config['Test_Command'] then
    RegisterCommand('market', function()
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "data",
            item = Config['items']
        })
    end)
end


RegisterNetEvent('Blackmarket-V2:client:CreatePed', function(x, y, z, w)
    if not DoesEntityExist(dealer) then
        RequestModel('g_m_m_chicold_01')
        while not HasModelLoaded('g_m_m_chicold_01') do
            Wait(10)
        end
        dealer = CreatePed(26, 'g_m_m_chicold_01', x, y, z - 1, true, false)
        SetEntityHeading(dealer, w)
        SetBlockingOfNonTemporaryEvents(dealer, true)
        TaskStartScenarioInPlace(dealer, 'WORLD_HUMAN_AA_SMOKE', 0, false)
        FreezeEntityPosition(dealer, true)
        SetEntityInvincible(dealer, true)
        exports["qb-target"]:AddBoxZone("marketped", vector3(x, y, z), 0.75, 0.75, {
            name = "marketped",
            heading = w,
            debugPoly = false,
            minZ = z - 1,
            maxZ = z + 1
        }, {
            options = {{
                type = "client",
                event = "Blackmarket-V2:client:openstore",
                icon = "fas fa-box",
                label = "View The Store!"
            }},
            distance = 1.5
        })
    end
end)

RegisterNetEvent('Blackmarket-V2:client:openstore', function()
    if GetClockHours() >= Config['Open'] and GetClockHours() <= Config['Close'] then
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "data",
            item = Config['items']
        })
    else
        QBCore.Functions.Notify("Come back another time.", 'error', 500)
    end    
end)

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNUICallback('escape', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("itemdata", function(data, cb)
    money = tonumber(data.price)
    itemname = data.itemcode
    itemstring = data.itemsname
    TriggerServerEvent('Blackmarket-V2:server:itemgo', money, itemname, itemstring)
end)
