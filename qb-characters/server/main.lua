local QBCore = exports['qb-core']:GetCoreObject()

-- // Code \\ --

-- // Events \\ --

local function InsertToMDT(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        MySQL.Async.insert('INSERT INTO mdt_data (cid, fingerprint) VALUES (:cid, :fingerprint) ON DUPLICATE KEY UPDATE cid = :cid, fingerprint = :fingerprint', {
            cid = Player.PlayerData.citizenid,
            fingerprint = Player.PlayerData.metadata['fingerprint'],
        })
    end
end

local function GiveStarterItems(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports['qb-inventory']:AddItem(src, 'starterbag', 1)
end

RegisterServerEvent('qb-characters:server:load:user:data')
AddEventHandler('qb-characters:server:load:user:data', function(cData)
    local src = source
    if QBCore.Player.Login(src, cData.citizenid) then
        print('^2[Old-Character]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has been successfully loaded!')
        QBCore.Functions.CreateLog(
            "loaded",
            "Character loaded",
            "green",
            "**".. GetPlayerName(src) .. "** (Citizen ID: "..cData.citizenid.." | ID : "..src..") has been successfully loaded",
            false
        )
        local Player = QBCore.Functions.GetPlayer(src)
        while Player == nil do
            Player = QBCore.Functions.GetPlayer(src)
            Citizen.Wait(100)
        end
        QBCore.Commands.Refresh(src)
        TriggerClientEvent("qb-characters:client:setupSpawns", src, false, false)
	end
end)

RegisterServerEvent('qb-characters:server:createCharacter')
AddEventHandler('qb-characters:server:createCharacter', function(data)
    local src = source
    local newData = {}
    newData.cid = data.cid
    newData.charinfo = data

    if QBCore.Player.Login(src, false, newData) then
        if Config.StartingApartment then
            local randbucket = (GetPlayerPed(src) .. math.random(1,999))
            SetPlayerRoutingBucket(src, randbucket)
            print('^2[New-Character]^7 '..GetPlayerName(src)..' has succesfully loaded!')
            QBCore.Commands.Refresh(src)
            TriggerClientEvent("qb-multicharacter:client:closeNUI", src)
            GiveStarterItems(src)
        else
            SetPlayerRoutingBucket(src, tonumber(src))
            print('^2[New-Character]^7 '..GetPlayerName(src)..' has succesfully loaded!')
            QBCore.Commands.Refresh(src)
            TriggerClientEvent("qb-characters:client:starting:point", src)
            GiveStarterItems(src)
        end

        QBCore.Functions.CreateLog(
            "loaded",
            "New Character",
            "green",
            "**".. GetPlayerName(src) .. "** Just Created New Character | "..newData.cid.."",
            false
        )
        TriggerClientEvent("qb-characters:client:setupSpawns", src, false, true)
        InsertToMDT(src)
	end
end)
 
RegisterServerEvent('qb-characters:server:deleteCharacter')
AddEventHandler('qb-characters:server:deleteCharacter', function(citizenid)
    local src = source
    QBCore.Player.DeleteCharacter(src, citizenid)
    TriggerClientEvent('qb-multicharacter:client:chooseChar', src)
end)

RegisterServerEvent('qb-characters:server:disconnect')
AddEventHandler('qb-characters:server:disconnect', function()
    local src = source
    DropPlayer(src, "You left the city!")
end)

QBCore.Functions.CreateCallback("qb-characters:here", function(source, cb)
    print'ss'
end)

QBCore.Functions.CreateCallback("qb-characters:server:get:char:data", function(source, cb)
    local license = QBCore.Functions.GetIdentifier(source, 'license')
    local plyChars = {}
    exports['oxmysql']:execute('SELECT * FROM players WHERE license = @license', {['@license'] = license}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            table.insert(plyChars, result[i])
        end
        cb(plyChars)
    end)
end)

QBCore.Functions.CreateCallback("qb-characters:server:getSkin", function(source, cb, cid)
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {cid, 1})
    if result[1] ~= nil then
        cb(json.decode(result[1].skin))
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback("qb-characters:server:getTattoos", function(source, cb, cid)
    exports.oxmysql:execute('SELECT tattoos FROM players WHERE citizenid = ?', {cid}, function(result)
        if result[1].tattoos and result[1].tattoos ~= nil then
            cb(json.decode(result[1].tattoos))
        else
            cb()
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-characters:server:logout:player", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local PlayerItems = Player.PlayerData.inventory
    TriggerClientEvent('qb-radio:drop:radio', source)
    if PlayerItems ~= nil then
        QBCore.Functions.UpdateSql(true, "UPDATE `players` SET `inventory` = '"..QBCore.EscapeSqli(json.encode(PlayerItems)).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
    else
        QBCore.Functions.UpdateSql(true, "UPDATE `players` SET `inventory` = '{}' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
    end
    QBCore.Player.Logout(source)
end)

QBCore.Functions.CreateCallback("qb-characters:server:get:char:data:manual", function(source, cb, CharId)
    local Steam = GetPlayerIdentifiers(source)[1]
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE steam = '"..Steam.."' AND cid = '"..CharId.."'", function(result)
        if result[1] ~= nil then
            cb(result[1])
        else
            cb(nil)
        end
    end)
end)

-- // Commands \\ --

QBCore.Commands.Add("char", "Go to the characters menu.", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    QBCore.Player.Logout(source)
    Citizen.Wait(550)
    TriggerClientEvent('qb-multicharacter:client:chooseChar', source)
end, {'god', 'admin', 'operator'})

QBCore.Commands.Add('charp', "Give Player characters menu.", { { name = 'ID', help = 'Player ID' } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        QBCore.Player.Logout(Player.PlayerData.source)
        Citizen.Wait(550)
        TriggerClientEvent('qb-multicharacter:client:chooseChar', Player.PlayerData.source)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Player is not online', 'error')
    end
end, {'god', 'admin', 'operator'})

QBCore.Functions.CreateUseableItem("starterbag", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        for k, v in pairs(QBCore.Shared.StarterItems) do
            local info = {}
            if v.item == "id_card" then
                info.citizenid = Player.PlayerData.citizenid
                info.firstname = Player.PlayerData.charinfo.firstname
                info.lastname = Player.PlayerData.charinfo.lastname
                info.birthdate = Player.PlayerData.charinfo.birthdate
                info.gender = Player.PlayerData.charinfo.gender
                info.nationality = Player.PlayerData.charinfo.nationality
            elseif v.item == "driver_license" then
                info.firstname = Player.PlayerData.charinfo.firstname
                info.lastname = Player.PlayerData.charinfo.lastname
                info.birthdate = Player.PlayerData.charinfo.birthdate
                info.type = "Class C Driver License"
            end
            exports['qb-inventory']:AddItem(src, v.item, v.amount, nil, info)
        end
        if math.random(1, 10) >= 8 then 
            exports['qb-inventory']:AddItem(src, 'lockpick', 1)
        end
    end
end)