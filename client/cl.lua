local pedModel = Config.pedAppearance
local pos_ped = Config.pedPosition

function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end
end

-- Create Ped
LoadModel(pedModel)
local spawnedPed =  CreatePed(4, GetHashKey(pedModel), pos_ped.x, pos_ped.y, pos_ped.z, 0.0, true, true)
    
-- Config Ped 
SetEntityCanBeDamaged(spawnedPed, false) 
SetBlockingOfNonTemporaryEvents(spawnedPed, true) 
SetPedFleeAttributes(spawnedPed, 0, false) 
SetPedCombatAttributes(spawnedPed, 17, true) 
SetPedAsEnemy(spawnedPed, false) 
SetPedCanRagdoll(spawnedPed, false)
FreezeEntityPosition(spawnedPed, true)
TaskLookAtEntity(spawnedPed, playerPed, -1, 0, 2)

Citizen.CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = Config.pedPosition,
        options = {
            {
                label = "Ouvrir le magasin illégal",
                icon = "fa-solid fa-gun",
                onSelect = function()
                    lib.showContext('Illégal_Shop')
                end
            }
        }
    })
end)

lib.registerContext({
    id = 'Illégal_Shop',
    title = 'Shop Illégal',
    options = {
        {
            title = 'Acheter une arme blanche',
            icon = "fa-solid fa-gun",
            onSelect = function()
                OpenArmeBlancheMenu()
            end
        },
        {
            title = "Acheter une arme à feu",
            icon = "fa-solid fa-gun",
            onSelect = function()
                OpenArmeFeuMenu()
            end
        },
        {
            title = "Acheter des munitions",
            icon = "fa-solid fa-gun",
            onSelect = function()
                OpenMunitionMenu()
            end
        }
    }
})

function OpenArmeBlancheMenu()
    local option = {}
    for k, v in pairs(Config.ArmeBlanche) do
        table.insert(option, {
            title = v.label,
            description = "\n 📋 Description : " .. v.description .. "\n 💸 Prix : " .. v.price .."$",
            onSelect = function()
                TriggerServerEvent('addItem', v.name, v.price)
            end
        })
    end

    lib.registerContext({
        id = "ArmeBlanche:Menu",
        title = "Arme Blanche",
        options = option
    })
    lib.showContext('ArmeBlanche:Menu')
end

function OpenArmeFeuMenu()
    local option = {}
    for k, v in pairs(Config.ArmeFeu) do
        table.insert(option, {
            title = v.label,
            description = "\n 📋 Description : " .. v.description .. "\n 💸 Prix : " .. v.price .."$",
            onSelect = function()
                TriggerServerEvent('addItem', v.name, v.price)
            end
        })
    end

    lib.registerContext({
        id = "OpenArmeFeuMenu:Menu",
        title = "Arme à Feu",
        options = option
    })
    lib.showContext('OpenArmeFeuMenu:Menu')
end

function OpenMunitionMenu()
    local option = {}
    for k, v in pairs(Config.Munition) do
        table.insert(option, {
            title = v.label,
            description = "\n 📋 Description : " .. v.description .. "\n 💸 Prix : " .. v.price .. "$",
            onSelect = function()
                local input = lib.inputDialog("Combien de munitions ?", {
                    { type = "number", label = "Quantité", min = 1, default = 1 }
                })

                if input and input[1] then
                    local quantity = tonumber(input[1])
                    local totalPrice = v.price * quantity

                    local confirm = lib.alertDialog({
                        header = "Confirmer l'achat",
                        content = "Acheter " .. quantity .. "x " .. v.label .. " pour $" .. totalPrice .. " ?",
                        centered = true,
                        cancel = true
                    })

                    if confirm == "confirm" then
                        TriggerServerEvent('addItem', v.name, totalPrice, quantity)
                    end
                end
            end
        })
    end

    lib.registerContext({
        id = "OpenMunition:Menu",
        title = "Munition",
        options = option
    })
    lib.showContext('OpenMunition:Menu')
end  