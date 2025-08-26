Config = Config or {}

Config.StartingApartment = false -- Starting in Appartment is true or Starting at Cityhall is false
Config.DefaultSpawn = vector3(-1035.71, -2731.87, 12.86) -- Default spawn coords if you have start apartments disabled

Config.Characters = {
    ["StartPedCoords"] = {x = 971.69085693359, y = 68.758193969727, z = 116.16414642334, h = 33.758647918701, r = 1.0}, -- Spot where fake characters are placed.
    ["PedCoords"] = {x = 968.18151855469, y = 74.033889770508, z = 116.17604064941, h = 270.71209716797, r = 1.0}, -- Spot where fake characters walk to.
    ["EndPedCoords"] = {x = 971.69085693359, y = 68.758193969727, z = 116.16414642334, h = 33.758647918701, r = 1.0}, -- Spot where character will walk when chosen.
    ["EndPedCoordsCreated"] = {x = 971.69085693359, y = 68.758193969727, z = 116.16414642334, h = 33.758647918701, r = 1.0}, -- Spot where character will walk when chosen when creating char.
    ["HiddenCoords"] = {x = 975.11138916016, y = 64.798667907715, z = 116.16413116455, h = 326.09295654297, r = 1.0}, -- Spot where actual character will be placed.
    ["CamCoords"] = {x = 974.12359619141, y = 73.996482849121, z = 117.16416168213},  -- Position of camera that is looking at fake characters.
}