ESX = exports["es_extended"]:getSharedObject()










local robbedRecently = false
local graj_animke_npc = false

function ___KLAMER___NOTIFY___(title,text,time,type)
    if Config.Notify == 'okokNotify' then
        exports['okokNotify']:Alert(title, text, time, type)
    elseif Config.Notify == 'ox_lib' then
        lib.notify({title = title,description = text,type = type})    
    else
        print('[ERROR WITH CONFIG.NOTIFY] if u want to set custom notify u need to add your export in client/main.lua line 13.')
    end
end

function GetStreetAndZone()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
    local street = street1 .. ", " .. zone
    return street
end

Citizen.CreateThread(function()
    exports.ox_target:addGlobalPed({
        label = _U('target_label'),
        icon = "fa-solid fa-people-robbery",
        distance = 3,
        event = "cwel"
    })
end)

RegisterNetEvent('cwel')
AddEventHandler('cwel',function(data)
    local playerPed = GetPlayerPed(-1)
    local pCoords = GetEntityCoords(playerPed, true)
    local targetPed = 	data.entity
    local tCoords = GetEntityCoords(targetPed, true)
 
    if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) then
    local bron = GetSelectedPedWeapon(GetPlayerPed(-1))
        if robbedRecently then
            ___KLAMER___NOTIFY___(_U('robbed_too_recently'), '', 2500, 'error')
        elseif IsPedDeadOrDying(targetPed, true) then
            ___KLAMER___NOTIFY___(_U('target_dead'), '', 2500, 'error')
        else
            if bron ~= -1569615261 then
                robNpc(targetPed)
            else
                ___KLAMER___NOTIFY___(_U('cant_rob_npc'), _U('need_weapon'), 2500, 'error')
            end
        end

    end
end)


function randomId()
    math.randomseed(GetCloudTimeAsInt())
    return string.gsub("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx", "[xy]", function(c)
        return string.format("%x", (c == "x") and math.random(0, 0xf) or math.random(8, 0xb))
    end)
end
function robNpc(targetPed)
    if Config.Use_Disptach then
        robbedRecently = true
        local coordy_pedofila = GetEntityCoords(GetPlayerPed(-1))
        local cwelcweldziwka = {
        code = "",
        street = GetStreetAndZone(),
        id = randomId(),
        priority = 1,
        title = _U("robbery_notify"),
        duration = 10000,
        blipname = _U('robbery_blip_name'),
        color = 1,
        sprite = 480,
        fadeOut = 30,
        position = {
            x = coordy_pedofila.x,
            y = coordy_pedofila.y,
            z = coordy_pedofila.z
        },
        job = "police"
        }
        TriggerServerEvent("dispatch:svNotify", cwelcweldziwka)
    end
    Citizen.CreateThread(function()
        local dict = 'random@mugging3'
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(10)
        end
        TaskStandStill(targetPed, Config.RobAnimationSeconds * 1000)
        FreezeEntityPosition(targetPed, true)
        TaskPlayAnim(targetPed, dict, 'handsup_standing_base', 8.0, -8, .01, 49, 0, 0, 0, 0)
        ___KLAMER___NOTIFY___(_U('robbering_notify'), _U('get_gloser'), 2500, 'success')
        local nie_blisko = true
        local ___done___ = false
        while nie_blisko do
            if not IsEntityPlayingAnim(targetPed, dict, 'handsup_standing_base', 1) then
                TaskPlayAnim(targetPed, dict, 'handsup_standing_base', 8.0, -8, .01, 49, 0, 0, 0, 0)
            end
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local NpcCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - NpcCoords)
            if distance < 0.72 then
                nie_blisko = false
                ___done___ = true
                break
            elseif distance > 8 then
                nie_blisko = false
                ___done___ = false
                break
            end
            Citizen.Wait(250)
        end
        if ___done___ then
            graj_animke_npc = true
            Wait(50)
            if lib.progressBar({
                duration = 8000,
                label = _U('robbering_pg'),
                useWhileDead = false,
                canCancel = true,
                disable = {
                car = true,
                move = true,
                combat = true,
                },
                anim = {
                dict = 'oddjobs@shop_robbery@rob_till',
                clip = 'loop' 
                },
                }) 
                then
                    graj_animke_npc = false
                            FreezeEntityPosition(targetPed, false)
                            ClearPedTasks(targetPed)
                            ESX.TriggerServerCallback('klamer:piecznie_chleba',function(ile_chleba)
                                if ile_chleba == true then
                                    ___KLAMER___NOTIFY___(_U('rob_success'), '', 2500, 'success')
                                else
                                    ___KLAMER___NOTIFY___(_U('nothing'), '', 2500, 'error')
                                end
                            end)
                    
                            if Config.ShouldWaitBetweenRobbing then
                                Citizen.Wait(math.random(Config.MinWaitSeconds, Config.MaxWaitSeconds) * 1000)
                                ___KLAMER___NOTIFY___(_U('end_cooldown'), '', 2500, 'info')
                            end
                    
                            robbedRecently = false
            else
                graj_animke_npc=false
                ClearPedTasks(targetPed)
                FreezeEntityPosition(targetPed, false)
                ___KLAMER___NOTIFY___(_U('cancel'),'', 2500, 'info')
            end
        else
            FreezeEntityPosition(targetPed, false)
            ClearPedTasks(targetPed)
            ___KLAMER___NOTIFY___(_U('too_far'),'', 2500, 'info')
        end
    
    end)
end
