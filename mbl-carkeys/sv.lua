ESX = nil

local searched = {}
local hotwired = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent("vehicle:everything:syNc:server")
AddEventHandler("vehicle:everything:syNc:server", function ()
    TriggerClientEvent("vehicle:searched:syNc:client", source, searched, hotwired)
end)


RegisterServerEvent("tbinsert:server:forsearched")
AddEventHandler("tbinsert:server:forsearched", function (plate)
    table.insert(searched, plate)
    TriggerClientEvent('tbinsert:client:forsearched', -1, searched)
end)

RegisterServerEvent("tbinsert:server:forhotwiredVeh")
AddEventHandler("tbinsert:server:forhotwiredVeh", function (plate)
    hotwired[plate] = true
    TriggerClientEvent('tbinsert:client:forhotwired', -1, plate)
end)


ESX.RegisterUsableItem("vehiclekey" , function(source)
    print("anahtar used")
end)


-- RegisterServerEvent("mbl:reward")
-- AddEventHandler("mbl:reward", function (plate)

-- end)
-- QBCore.Functions.CreateCallback("mbl:checkVehicleItemInfo", function (source,cb,plaka)
--     print("triggerladımbakalım")
--     local xPlayer = QBCore.Functions.GetPlayer(source)
--     local itemstabke = xPlayer.PlayerData.items
--     for k,v in pairs(itemstabke) do
--         print(json.encode(v))
--         if v.name == "vehiclekey" then
--             print("hayda bakım")
--             if v.info.plaka == plaka then
--                 print("trues")
--                 cb(true)
--             else
--                 print("false")
--                 cb(false)
--             end
--         else
--             print("anahtar yok knk")
--         end
--     end
-- end)


-- exports("CarKey", function(source, label, plate)
--     local data = {
--         model = label:upper(),
--         plaka = plate
--     }
--     local xPlayer = ESX.GetPlayerFromId(source)
--     xPlayer.addInventoryItem("vehiclekey", 1 , false, data)
--     TriggerClientEvent('inventory:client:ItemBox',source,ESX.GetItems()["vehiclekey"],'add',1)
-- end)


RegisterServerEvent("mbl:giveItem")
AddEventHandler("mbl:giveItem",function(itemName, itemAmount, slot,ItemInfo)
    local xpLayer = ESX.GetPlayerFromId(source)
    xpLayer.addInventoryItem(itemName, itemAmount, slot,ItemInfo)
end)