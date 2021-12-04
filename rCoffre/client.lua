ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

local societe = nil
local LabelMenu = nil
local lequelle = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

function MenuCoffre()
    local Coffre = RageUI.CreateMenu("Coffre "..LabelMenu, "Interaction")
    Coffre:SetRectangleBanner(100, 100, 100)
        RageUI.Visible(Coffre, not RageUI.Visible(Coffre))
            while Coffre do
            Citizen.Wait(0)
            RageUI.IsVisible(Coffre, true, true, true, function()
                if lequelle == "legal" then
                   RageUI.Separator("~o~Entreprise : "..LabelMenu)
                else
                   RageUI.Separator("~r~Organisation : "..LabelMenu)
                end

                RageUI.ButtonWithStyle("Prendre objet",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        CoffreRetirer()
                        RageUI.CloseAll()
                    end
                end)
                
                RageUI.ButtonWithStyle("Déposer objet",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        CoffreDeposer()
                        RageUI.CloseAll()
                    end
                end)

                RageUI.ButtonWithStyle("Prendre Arme(s)",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        CoffreRetirerWeapon()
                        RageUI.CloseAll()
                    end
                end)
                
                RageUI.ButtonWithStyle("Déposer Arme(s)",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        CoffreDeposerWeapon()
                        RageUI.CloseAll()
                    end
                end)

                end, function()
                end)
            if not RageUI.Visible(Coffre) then
            Coffre = RMenu:DeleteType("Coffre", true)
        end
    end
end


--- Item

itemstock = {}
function CoffreRetirer()
    local StockCoffre = RageUI.CreateMenu("Coffre", LabelMenu)
    StockCoffre:SetRectangleBanner(100, 100, 100)
    ESX.TriggerServerCallback('rCoffre:getStockItems', function(items) 
    itemstock = items
    RageUI.Visible(StockCoffre, not RageUI.Visible(StockCoffre))
        while StockCoffre do
            Citizen.Wait(0)
                RageUI.IsVisible(StockCoffre, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle("~r~→~s~ "..v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local cbRetirer = CoffreKeyboardInput("Combien ?", "", 15)
                                    TriggerServerEvent('rCoffre:getStockItem', v.name, tonumber(cbRetirer), societe)
                                    CoffreRetirer()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(StockCoffre) then
            StockCoffre = RMenu:DeleteType("Coffre", true)
        end
    end
    end, societe)
end

function CoffreDeposer()
    local StockPlayer = RageUI.CreateMenu("Coffre", "Voici votre ~y~inventaire")
    StockPlayer:SetRectangleBanner(100, 100, 100)
    ESX.TriggerServerCallback('rCoffre:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle("~r~→~s~ "..item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local cbDeposer = CoffreKeyboardInput("Combien ?", '' , 15)
                                            TriggerServerEvent('rCoffre:putStockItems', item.name, tonumber(cbDeposer), societe)
                                            CoffreDeposer()
                                        end
                                    end)
                            end
                    end
                end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end

--Weapon


Weaponstock = {}
function CoffreRetirerWeapon()
    local StockCoffreWeapon = RageUI.CreateMenu("Coffre", LabelMenu)
    StockCoffreWeapon:SetRectangleBanner(100, 100, 100)
    ESX.TriggerServerCallback('rCoffre:getArmoryWeapons', function(weapons)
    Weaponstock = weapons
    RageUI.Visible(StockCoffreWeapon, not RageUI.Visible(StockCoffreWeapon))
        while StockCoffreWeapon do
            Citizen.Wait(0)
                RageUI.IsVisible(StockCoffreWeapon, true, true, true, function()
                        for k,v in pairs(Weaponstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle("~r~→~s~ "..ESX.GetWeaponLabel(v.name), nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    --local cbRetirer = rGangBuilderKeyboardInput("Combien ?", "", 15)
                                    ESX.TriggerServerCallback('rCoffre:removeArmoryWeapon', function()
                                        CoffreRetirerWeapon()
                                    end, v.name, societe)
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(StockCoffreWeapon) then
            StockCoffreWeapon = RMenu:DeleteType("Coffre", true)
        end
    end
    end, societe)
end

function CoffreDeposerWeapon()
    local StockPlayerWeapon = RageUI.CreateMenu("Coffre", "Voici votre ~y~inventaire d'armes")
    StockPlayerWeapon:SetRectangleBanner(100, 100, 100)
        RageUI.Visible(StockPlayerWeapon, not RageUI.Visible(StockPlayerWeapon))
    while StockPlayerWeapon do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayerWeapon, true, true, true, function()
                
                local weaponList = ESX.GetWeaponList()

                for i=1, #weaponList, 1 do
                    local weaponHash = GetHashKey(weaponList[i].name)
                    if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
                    RageUI.ButtonWithStyle("~r~→~s~ "..weaponList[i].label, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                        --local cbDeposer = rGangBuilderKeyboardInput("Combien ?", '' , 15)
                        ESX.TriggerServerCallback('rCoffre:addArmoryWeapon', function()
                            CoffreDeposerWeapon()
                        end, weaponList[i].name, true, societe)
                    end
                end)
            end
            end
            end, function()
            end)
                if not RageUI.Visible(StockPlayerWeapon) then
                StockPlayerWeapon = RMenu:DeleteType("Coffre", true)
            end
        end
end


---- Job 1

Citizen.CreateThread(function()
    while true do
        local Timer = 500
            for k,v in pairs(Config.Coffre.Legal) do
                if ESX.PlayerData.job and ESX.PlayerData.job.name == v.Name then
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.Pos)
                if dist <= 10.0 and Config.jeveuxmarker then
                    Timer = 0
                    DrawMarker(20, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, v.Marker.r, v.Marker.g, v.Marker.b, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                    if dist <= 1.0 then
                    Timer = 0
                    RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour ouvrir le coffre", time_display = 1 })
                    if IsControlJustPressed(1,51) then
                        societe = v.Name
                        LabelMenu = v.Label
                        lequelle = "legal"
                        MenuCoffre()
                    end
                end
            end
        end
        Citizen.Wait(Timer)
    end
end)


---- Job 2

Citizen.CreateThread(function()
    while true do
        local Timer = 500
            for k,v in pairs(Config.Coffre.Illegal) do
                if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == v.Name then
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.Pos)
                if dist <= 10.0 and Config.jeveuxmarker then
                    Timer = 0
                    DrawMarker(v.Marker.Type, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, v.Marker.r, v.Marker.g, v.Marker.b, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                    if dist <= 1.0 then
                    Timer = 0
                    RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour ouvrir le coffre", time_display = 1 })
                    if IsControlJustPressed(1,51) then
                        societe = v.Name
                        LabelMenu = v.Label
                        lequelle = "illegal"
                        MenuCoffre()
                    end
                end
            end
        end
        Citizen.Wait(Timer)
    end
end)



function CoffreKeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end