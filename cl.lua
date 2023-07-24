ESX = exports["es_extended"]:getSharedObject()


local search = {
    vec3(1095.3617, -3194.8201, -38.9935),
    vec3(1092.8722, -3194.8223, -38.9934),
    vec3(1090.2234, -3194.8372, -38.9934),
    vec3(1090.2538, -3199.1025, -38.9934),
    vec3(1093.7333, -3199.0852, -38.9934),
    vec3(1093.7183, -3199.0703, -38.9934),
    vec3(1099.6053, -3194.1799, -38.9934),
    vec3(1101.7120, -3193.7695, -38.9934),
    vec3(1100.3370, -3198.7397, -38.9934),
    vec3(1087.2362, -3197.2131, -38.9934),
    vec3(1087.2363, -3194.7844, -38.9934)
}



local murto = {
    vec3(-1547.1635, -561.2876, 33.7267),
    vec3(-1487.2028, -909.9517, 10.0237),
    vec3(-1823.0239, -1201.2888, 19.3850)
}

local place = {
   vec3(-1547.1635, -561.2876, 33.7267),
   vec3(-1487.2028, -909.9517, 10.0237),
   vec3(-1823.0239, -1201.2888, 19.3850)
}

local tiirikoitu = false
local hasTakendrug = false

-- creating npc
AddEventHandler('drug')
CreateThread(function()
	npcModel = GetHashKey("s_m_y_dealer_01")
	RequestModel(npcModel)
	while not HasModelLoaded(npcModel) do
		Wait(0)
	end
	npc = CreatePed(1, npcModel, -1358.8040, -911.1674, 11.4705, 260.7393, false, true) -- coords of the npc
	SetBlockingOfNonTemporaryEvents(npc, true)
	SetPedDiesWhenInjured(npc, false)
	SetPedCanPlayAmbientAnims(npc, true)
	SetPedCanRagdollFromPlayerImpact(npc, false)
	SetEntityInvincible(npc, true)
	FreezeEntityPosition(npc, true)
	TaskStartScenarioInPlace(npc, "WORLD_HUMAN_AA_SMOKE", 0, true);
end)



local isDoingdrug = false

exports.ox_target:addBoxZone({
    coords = vec3(-1358.9117, -911.1705, 13.0440),
    size = vec3(1.5, 1.5, 1.5),
    rotation = 160,
    distance = 1,
    debug = drawZones,
    options = {
        {
            name = 'drug',
            event = 'drug:start',
            icon = 'fa-solid fa-bars-progress',
            label = 'Get a drug',
            canInteract = function(entity, distance, coords, name)
                return not isDoingdrug
            end
        }
    }
})

RegisterNetEvent('drug:start')
AddEventHandler('drug:start', function()
    local p = PlayerPedId()
    ExecuteCommand('e wait5')
    FreezeEntityPosition(p, true)
    exports['progressbar']:Progress({
        name = "drug",
        duration = 5000,
        label = "Looking for a drug...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        if not cancelled then
            isDoingdrug = true
            local randomPlace = place[math.random(1, #place)] -- Valitse random paikka 
            ok(randomPlace)
            SetNewWaypoint(randomPlace.x, randomPlace.y, randomPlace.z) -- Aseta waypoint random paikkaan
            FreezeEntityPosition(p, false)
            isDoingdrug = false
            hasTakendrug = true -- Merkitään, että pelaaja on ottanut keikan aloituspaikasta
        end
    end)
end)

function ok (randomPlace)
    
    exports.ox_target:addBoxZone({
    coords = randomPlace,
    size = vec3(1.5, 1.5, 1.5),
    rotation = 160,
    distance = 1,
    debug = drawZones,
    options = {
        {
            name = 'rob',
            event = 'drug:rob',
            icon = 'fa-solid fa-joint',
            label = 'rob',
            canInteract = function(entity, distance, coords, name)
                return true
            end
        }
    }
})
end

RegisterNetEvent('drug:rob')
AddEventHandler('drug:rob', function()
    if hasTakendrug then
        ExecuteCommand('e mechanic')
        local success = lib.skillCheck({'easy', 'easy', { areaSize = 60, speedMultiplier = 2 }, 'easy'}, {'1', '2', '3', '4'})
        if success then
            tiirikoitu = true
            SetEntityCoords(PlayerPedId(), 1088.5219, -3187.4624, -38.9935, false, false, false, false)
            SetEntityHeading(PlayerPedId(), 172.7577)
            ClearPedTasks(PlayerPedId())
        end
    end
end)

RegisterNetEvent('jees')
AddEventHandler('jees', function()
    ExecuteCommand('e mechanic')
     local success exports['np']:StartLockPickCircle(2, 9)

     if success then
        TriggerServerEvent('tumma')
        ClearPedTasks(PlayerPedId())
     end
     if not success then
        ClearPedTasks(PlayerPedId())
     end
end)

    for c = 1, #search do 
    exports.ox_target:addBoxZone({
        coords = search[c],
        size = vec3(1.5, 1.5, 1.5),
        rotation = 160,
        debug = drawZones,
        options = {
            {
                name = 'search',
                event = 'jees',
                icon = 'fa-solid fa-magnifying-glass',
                label = 'search',
                canInteract = function(entity, distance, coords, name)
                    return tiirikoitu
                end
            }
        }
    })
end



RegisterNetEvent('lähe')
AddEventHandler('lähe', function()
    local p = PlayerPedId()
    ExecuteCommand('e mechanic')
    SetEntityCoords(p, murto.x, murto.y, murto.z, false, false, false, false) 
    ClearPedTasks(PlayerPedId())
end)

exports.ox_target:addBoxZone({
    coords = vec3(1088.8081, -3187.7017, -38.9935),
    size = vec3(1.5, 1.5, 1.5),
    rotation = 160,
    debug = drawZones,
    options = {
        {
            name = 'Lähde',
            event = 'lähe',
            icon = 'fa-solid fa-building',
            label = 'lähde',
            canInteract = function(entity, distance, coords, name)
                return true
            end
        }
    }
})