local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('Blackmarket-V2:server:itemgo', function(money, itemcode, itemstring)
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

RegisterServerEvent('Blackmarket-V2:server:CreatePed', function(x, y, z, w)
	TriggerClientEvent('Blackmarket-V2:client:CreatePed', -1, x, y, z, w)
end)
