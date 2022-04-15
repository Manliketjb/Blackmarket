-------------------- Core --------------------

local QBCore = exports['qb-core']:GetCoreObject()

-------------------- Events --------------------

RegisterServerEvent('Blackmarket:server:itemgo', function(money, itemcode, itemstring)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    local moneyPlayer = tonumber(Player.PlayerData.money.crypto)

    if moneyPlayer <= money then
        TriggerClientEvent('QBCore:Notify', source, "You don't have enough Crypto!", 'error')
    else
        Player.Functions.RemoveMoney('crypto', tonumber(money), 'black-market')
        Player.Functions.AddItem(itemcode, 1, false)
    end
end)

-------------------- Functions --------------------

local function CreatePed(x, y, z, w)
    TriggerClientEvent('Blackmarket:client:CreatePed', -1, x, y, z, w)
end

-------------------- Location Picker --------------------

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
    CreatePed(v.x, v.y, v.z, v.w) --- Ped Sync
end
