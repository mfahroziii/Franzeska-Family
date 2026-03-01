Framework = 'qbox'
PlayerLoaded, PlayerData = nil, {}

local function InitializeFramework()
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        PlayerData = exports.qbx_core:GetPlayerData()
        PlayerLoaded = true
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        PlayerData = {}
        PlayerLoaded = false
    end)

    -- This event fires when metadata changes (death, laststand, etc.)
    RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
        PlayerData = val
    end)

    AddEventHandler('onResourceStart', function(resourceName)
        if GetCurrentResourceName() ~= resourceName then return end
        PlayerData = exports.qbx_core:GetPlayerData()
        PlayerLoaded = true
    end)

    print('[RPEmotes-Reborn] Framework initialized: ' .. Framework)
end

function CanDoAction()
    return LocalPlayer.state.isLoggedIn and not (PlayerData.metadata.inlaststand or PlayerData.metadata.isdead or PlayerData.metadata.ishandcuffed)
end

InitializeFramework()


-- EVENTS

RegisterNetEvent('animations:client:PlayEmote', function(args)
    if CanDoAction() then
        EmoteCommandStart(args)
    end
end)

if Config.Keybinding then
    RegisterNetEvent('animations:client:BindEmote', function(args)
        if CanDoAction() then
            EmoteBindStart(nil, args)
        end
    end)

    RegisterNetEvent('animations:client:EmoteBinds', function()
        if CanDoAction() then
            ListKeybinds()
        end
    end)

    RegisterNetEvent('animations:client:EmoteDelete', function(args)
        if CanDoAction() then
            DeleteEmote(args)
        end
    end)
end


RegisterNetEvent('animations:client:EmoteMenu', function()
    if CanDoAction() then
        OpenEmoteMenu()
    end
end)

RegisterNetEvent('animations:client:Walk', function(args)
    if CanDoAction() then
        WalkCommandStart(args)
    end
end)

RegisterNetEvent('animations:client:ListWalks', function()
    if CanDoAction() then
        WalksOnCommand()
    end
end)


local function DelayedHandleWalkstyle()
    SetTimeout(1500, HandleWalkstyle)
end

RegisterNetEvent('hospital:client:Revive', DelayedHandleWalkstyle)
RegisterNetEvent('qbx_medical:client:playerRevived', DelayedHandleWalkstyle)