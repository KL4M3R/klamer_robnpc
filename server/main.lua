
ESX = exports["es_extended"]:getSharedObject()

local listnpcs ={}

ESX.RegisterServerCallback('klamer_robnpc:check_npc', function(source,cb,npc)
    for i,v in pairs(listnpcs) do
        if v == npc then
            print(true)
            cb(true)
            return
        end
    end
    table.insert(listnpcs,npc)
    cb(false)
end)

ESX.RegisterServerCallback('klamer:piecznie_chleba', function(source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local szansa = math.random(1,100)
    local loot = 0
    if szansa < Config.percent_to_get_money then
        local fiutek = math.random(Config.MinMoney,Config.MaxMoney)
        xPlayer.addInventoryItem('money', fiutek)
        loot = loot+1
    end
    for i,v in pairs(Config.items) do
        local szansa = math.random(1,100)
        if szansa < v.chance then
            xPlayer.addInventoryItem(v.item, 1)
            loot = loot+1
        end
    end
    if loot == 0 then
        cb(false)
    else
        cb(true)
    end
end)

