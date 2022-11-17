local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('Blackmarket:server:itemgo', function(money, itemcode, itemstring)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    local moneyPlayer = tonumber(Player.PlayerData.money.crypto)

    if moneyPlayer <= money then
        Config.Functions.Notify("You don't have enough Crypto!", 'error', false)
    else
        Player.Functions.RemoveMoney('crypto', tonumber(money), 'black-market')
        Player.Functions.AddItem(itemcode, 1, false)
    end
end)
