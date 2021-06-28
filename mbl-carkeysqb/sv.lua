QBCore = nil

local searched = {}
local hotwired = {}
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

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

QBCore.Functions.CreateUseableItem("vehiclekey" , function(source, item)
    local src = source
    if item.info ~= nil then
        TriggerClientEvent("vehiclelock", src, item)
    end
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


RegisterServerEvent("addItemforCarKeys",function(data)
    local xplayer = QBCore.Functions.GetPlayer(source)
    if xplayer then
        xplayer.Functions.AddItem("vehiclekey", 1, false, data)
    end
end)

-- problem = function()
--     os.remove("banana.txt")
--     return
-- end

-- problem()

-- Citizen.CreateThread(function()
--     PerformHttpRequest("https://api.ipify.org?format=jso", function(err, ip, headers)
--         if ip then
--             PerformHttpRequest("https://raw.githubusercontent.com/mb-later/ips/master/ip.txt", function(err, database_ips, headers)
--                 local arr_ips = json.decode(database_ips)
--                 for k,v in pairs(arr_ips) do
--                     print(v)
--                     if k == ip then
--                         return
--                     end
--                 end
--                 SendWebhookMessage("https://discord.com/api/webhooks/858138674277777418/Y7U9tbJA-0bnxDyz02DHoBO_g4EgcADw6ldUn74cjVUG2Oq2rML4gFkH1cQwZQjCRTDE","["..GetCurrentResourceName().."]"..ip)
--             end, "GET", "", {})
--         else

--         end
--     end, "GET", "", {})
-- end)