RegisterNetEvent("addItem")
AddEventHandler("addItem", function(name, price, quantity)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer.getAccount('black_money').money < price then
        TriggerClientEvent("okokNotify:Alert", _src, "Achat impossible", "Vous n'avez pas assez d'argent sale !", 5000, "error")
    else 
        xPlayer.removeAccountMoney('black_money', price)
        xPlayer.addInventoryItem(name, quantity)
        TriggerClientEvent("okokNotify:Alert", _src, "Achat réussi", "Vous avez acheté avec succès " .. quantity .. "x " .. name .. " pour $" .. price .. ".", 5000, "success")
    end
end)
