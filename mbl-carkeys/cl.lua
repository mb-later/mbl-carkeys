local hotwiredVeh = {}
local searchedVeh = {}
local startedEngine = {}
local ownedKeys = {}  

ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(31)
  end
end)


Progressbar = function(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish ~= nil then
                onFinish()
            end
        else
            if onCancel ~= nil then
                onCancel()
            end
        end
    end)
end



Citizen.CreateThread(function()
    while true do
      
        local veh = GetVehiclePedIsIn(PlayerPedId(), true)
        local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
        if ESX ~= nil then
            if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), true), -1) == PlayerPedId() then
                
                if LastVehicle ~= GetVehiclePedIsIn(PlayerPedId(), false) then
                  
                    if hotwiredVeh[plate] == true or startedEngine[plate] == true then
                        SetVehicleEngineOn(veh, true, true, false)
                    else
               
                        SetVehicleEngineOn(veh, false, false, true)
                    end
                end
     
            else
            end
        end

        if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() and ESX ~= nil and not IsHotwiring then
            -- if not hasKey then
                if not hotwiredVeh[plate] then
                    if not startedEngine[plate] then
                        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                        SetVehicleEngineOn(veh, false, false, true)

                        if IsControlJustPressed(0, 311) then
                            Hotwire()
                        end
                    
                        if IsControlJustPressed(1, 38) then
                            Search()
                        end
                    
                    end
                end
            -- else
            --     print("hasana tten")
            -- end
              
        end
        Citizen.Wait(0)
    end
end)

--Events


RegisterNetEvent("tbinsert:client:forhotwired")
AddEventHandler("tbinsert:client:forhotwired", function (plate)
    table.insert(hotwiredVeh, plate)
end)
--Funtions--
Hotwire = function()
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
    if not startedEngine[plate] and not hotwiredVeh[GetVehicleNumberPlateText(veh)] then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        if vehicle ~= nil and vehicle ~= 0 then
            if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
                IsHotwiring = true

                local dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                local anim = "machinic_loop_mechandplayer"
				TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,1.0, 4.0, -1, 49, 0, false, false, false)

                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    RequestAnimDict(dict)
                    Citizen.Wait(100)
                end

                if exports["reload-skillbar"]:taskBar(math.random(4000,15000),math.random(10,20)) ~= 100 then             
					StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                    SetVehicleEngineOn(vehicle, false, false, true)
                    TriggerEvent('Notification',"Başarısız.")
                    IsHotwiring = false

                    return
                end
    
                if exports["reload-skillbar"]:taskBar(math.random(4000,15000),math.random(10,20)) ~= 100 then
                    StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                    SetVehicleEngineOn(vehicle, false, false, true)
                    TriggerEvent('Notification',"Başarısız.")
                    IsHotwiring = false
                    return
                end

                if exports["reload-skillbar"]:taskBar(1500,math.random(5,15)) ~= 100 then
                    StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                    SetVehicleEngineOn(vehicle, false, false, true)
                    TriggerEvent('Notification',"Başarısız.")
                    IsHotwiring = false
                    return
                end 

                StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                TriggerEvent('Notification',"Düzkontak Başarılı.")
                hotwiredVeh[plate] = true
                startedEngine[plate] = true
                IsHotwiring = false

            end
        end
    end
end

-- Hotwire = function()
--     local veh = GetVehiclePedIsIn(PlayerPedId(), true)
--     local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
--     if not hotwiredVeh[GetVehicleNumberPlateText(veh)] then
--         IsHotwiring = true
        
--         QBCore.Functions.Progressbar("hotwiring", "Düzkontak Yapılıyor...", 1000, false, true, {
--             disableMovement = true,
--             disableCarMovement = true,
--             disableMouse = false,
--             disableCombat = true,
--         }, {}, {}, {}, function()
--             QBCore.Functions.Notify("Araç çalıştı.")
--             -- TriggerServerEvent("tbinsert:server:forhotwiredVeh",GetVehicleNumberPlateText(veh))-- Buraya dönülecek tekrar
--             hotwiredVeh[GetVehicleNumberPlateText(veh)] = true
--             startedEngine[GetVehicleNumberPlateText(veh)] = true
--             SetVehicleEngineOn(veh, true, true, true)
--             IsHotwiring = false
--             end, function()
--             IsHotwiring = false
--         end)
--     end
-- end

function Search()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    if searchedVeh[GetVehicleNumberPlateText(vehicle)] then
        TriggerEvent('Notification',"Aracı Zaten Aradın.")
        return
    end
    searchedVeh[GetVehicleNumberPlateText(vehicle)] = true
    IsHotwiring = true
    Progressbar("searching_vehicle", "Aracı arıyorsun", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 16,
    }, {}, {}, function() 
        StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        TriggerServerEvent('mbl:reward')
        if (math.random(0, 100) < 5) then
            local info = {}
            local vehModel = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))):upper()
            info.model = vehModel:upper()
            info.plaka = GetVehicleNumberPlateText(vehicle)
            if TriggerServerEvent('mbl:giveItem',"vehiclekey", 1 , false, info) then
                print("ok")
            end
        else
            TriggerEvent('Notification',"Boş Kardeşim Başka Arabaya.")
        end
        IsHotwiring = false
    end, function() -- Cancel
        StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        IsHotwiring = false
    end)
end

-- Functions end -- 


RegisterNetEvent("vehiclelock")
AddEventHandler("vehiclelock", function (item)
    local veh = ESX.Game.GetClosestVehicle()
    local coordA = GetEntityCoords(PlayerPedId(), true)
    local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 255.0, 0.0)
    -- local veh = GetClosestVehicleInDirection(coordA, coordB)
    local pos = GetEntityCoords(PlayerPedId(), true)
    local plate = GetVehicleNumberPlateText(veh)
    local vehpos = GetEntityCoords(veh, false)
    local ped = GetPlayerPed(-1)
    local class = GetVehicleClass(veh)
    local vehLockStatus = GetVehicleDoorLockStatus(veh)
    local retval = IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()))
    if item.info.plaka == plate then
        if IsPedInAnyVehicle(ped, false) then
            if retval then
                startedEngine[plate] = false
                SetVehicleEngineOn(veh, false, false, true)
            else
                startedEngine[plate] = true
                SetVehicleEngineOn(veh, true, true, false)
            end
        else
            if class == 8 then
                TriggerEvent('Notification',"Motoru Kitleyemezsin.")
                return
                
            end
            if vehLockStatus == 1 then
                if class == 4 or class == 8 then
                    if #(GetEntityCoords(PlayerPedId(), true) - vector3(vehpos.x, vehpos.y, vehpos.z)) < 2.0 then
                        local SpatelObject = CreateObject(GetHashKey("p_car_keys_01"), 0, 0, 0, true, true, true)
                        AttachEntityToEntity(SpatelObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.08, 0.0, -0.02, 0.0, -25.0, 130.0, true, true, false, true, 1, true)
                        loadAnimDict("veh@break_in@0h@p_m_one@")
                        TaskPlayAnim(PlayerPedId(), 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds' ,1.0, 4.0, -1, 49, 0, false, false, false)
                        Citizen.Wait(1500)
                        DeleteEntity(SpatelObject)
                        ClearPedTasksImmediately(PlayerPedId())
                        DeleteEntity(SpatelObject)
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                        SetVehicleDoorsLocked(veh, 2)
                        TriggerEvent('Notification',"Araç Kitlendi.")
                    else
                        TriggerEvent('Notification',"Yakında aracın yok yada araca yakın değilsin. Aracın muscle ise lütfen yanına yaklaş")
                    end
                else
                    if #(GetEntityCoords(PlayerPedId(), true) - vector3(vehpos.x, vehpos.y, vehpos.z)) < 30.0 then
                        loadAnimDict("anim@mp_player_intmenu@key_fob@")
                        TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
                        Citizen.Wait(750)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
                        SetVehicleDoorsLocked(veh, 2)
                        TriggerEvent('Notification',"Araç Kitlendi.")
                    end
                end
            else
                if GetVehicleClass(veh) == 4 or GetVehicleClass(veh) == 5 then
                    if GetVehicleClass(veh) == 8 then
                        TriggerEvent('Notification',"Araç Açamazsın.")
                    else
                    if #(GetEntityCoords(PlayerPedId(), true) - vector3(vehpos.x, vehpos.y, vehpos.z)) < 2.0 then
                        local SpatelObject = CreateObject(GetHashKey("p_car_keys_01"), 0, 0, 0, true, true, true)
                        AttachEntityToEntity(SpatelObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.08, 0.0, -0.02, 0.0, -25.0, 130.0, true, true, false, true, 1, true)
                        loadAnimDict("veh@break_in@0h@p_m_one@")
                        TaskPlayAnim(PlayerPedId(), 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds' ,1.0, 4.0, -1, 49, 0, false, false, false)
                        Citizen.Wait(1500)
                        DeleteEntity(SpatelObject)
                        ClearPedTasksImmediately(PlayerPedId())
                        DeleteEntity(SpatelObject)
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
                        SetVehicleDoorsLocked(veh, 1)
                        TriggerEvent('Notification',"Araç Açıldı.")
                        end
                    end
                    else
                        if #(GetEntityCoords(PlayerPedId(), true) - vector3(vehpos.x, vehpos.y, vehpos.z)) < 30.0 then
                        loadAnimDict("anim@mp_player_intmenu@key_fob@")
                        TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
                        Citizen.Wait(750)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "unlock", 0.3)
                        SetVehicleDoorsLocked(veh, 1)
                        if(GetVehicleDoorLockStatus(veh) == 1)then
                            TriggerEvent('Notification',"Araç Açıldı.")
                        end
                    end
                end
        
                if not IsPedInAnyVehicle(PlayerPedId()) then
                    SetVehicleInteriorlight(veh, true)
                    SetVehicleIndicatorLights(veh, 0, true)
                    SetVehicleIndicatorLights(veh, 1, true)
                    Citizen.Wait(450)
                    SetVehicleIndicatorLights(veh, 0, false)
                    SetVehicleIndicatorLights(veh, 1, false)
                    Citizen.Wait(450)
                    SetVehicleInteriorlight(veh, true)
                    SetVehicleIndicatorLights(veh, 0, true)
                    SetVehicleIndicatorLights(veh, 1, true)
                    Citizen.Wait(450)
                    SetVehicleInteriorlight(veh, false)
                    SetVehicleIndicatorLights(veh, 0, false)
                    SetVehicleIndicatorLights(veh, 1, false)
                end 
            end
        end
    end
end)

loadAnimDict = function(anim)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end
end



exports("CarKey",function (vehicleLabel, plate)
    local info = {
        model = vehicleLabel:upper(),
        plaka = plate
    }
    if TriggerServerEvent('mbl:giveItem',"vehiclekey", 1 , false, info) then
        print("ok")
    end
end)



-- PART 2 Bu kısım daha sonra yazılacak



RegisterNetEvent("vehicle:searched:syNc:client")
AddEventHandler("vehicle:searched:syNc:client", function (searched, hotwired)
    table.insert(searchedVeh, searched)
    table.insert(hotwiredVeh, hotwired)
end)