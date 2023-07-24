ESX = exports["es_extended"]:getSharedObject()


local tumma = {
    "copper"
}
local item = tumma[math.random(1,#tumma)]
RegisterNetEvent("tumma", function ()
local source = source
local palyer = ESX.GetPlayerFromId(source)
palyer.addInventoryItem(item, 1)
end)