--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
                                                                    
    🐺 LXR Drag - Client Script
    
    Client-side drag system implementation with synchronized animations.
    Handles drag commands, player detection, and animation playback.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LOCAL VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════

local isDragging = false
local isBeingDragged = false
local draggerPed = nil
local draggedPed = nil
local lastDragTime = 0

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local function DebugPrint(msg)
    if Config.Debug then
        print('[LXR-Drag Client] ' .. msg)
    end
end

local function GetClosestPlayer()
    local players = GetActivePlayers()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer = nil
    local closestDistance = Config.General.dragDistance + 1.0
    
    for _, player in ipairs(players) do
        if player ~= PlayerId() then
            local targetPed = GetPlayerPed(player)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)
            
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end
    
    return closestPlayer, closestDistance
end

local function IsPlayerDead(ped)
    return IsEntityDead(ped) or IsPedDeadOrDying(ped, true)
end

local function IsPlayerInVehicle(ped)
    return IsPedInAnyVehicle(ped, false)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 ANIMATION FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        local timeout = 0
        while not HasAnimDictLoaded(dict) and timeout < 5000 do
            Wait(10)
            timeout = timeout + 10
        end
        if timeout >= 5000 then
            DebugPrint('Failed to load animation dictionary: ' .. dict)
            return false
        end
    end
    return true
end

local function PlayDragAnimation(ped, animType, role)
    local dict = Config.Animations.dict
    local anim = Config.Animations[role][animType]
    local flag = Config.Animations.flags[animType]
    
    if LoadAnimDict(dict) then
        TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, flag, 0, false, false, false)
        DebugPrint(string.format('Playing %s animation for %s', animType, role))
        return true
    end
    
    return false
end

local function StopDragAnimation(ped)
    ClearPedTasks(ped)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DRAG SYSTEM CORE
-- ═══════════════════════════════════════════════════════════════════════════════

local function StartDragging(targetServerId)
    local playerPed = PlayerPedId()
    
    isDragging = true
    draggedPed = GetPlayerPed(GetPlayerFromServerId(targetServerId))
    
    -- Play enter animation
    PlayDragAnimation(playerPed, 'enter', 'dragger')
    
    -- Notify
    Framework.Notify(Framework.GetLocale('drag_started'), 'success')
    
    DebugPrint('Started dragging player ' .. targetServerId)
end

local function StopDragging()
    local playerPed = PlayerPedId()
    
    if isDragging then
        -- Play release animation
        PlayDragAnimation(playerPed, 'release', 'dragger')
        Wait(1000) -- Let animation play
        StopDragAnimation(playerPed)
        
        isDragging = false
        draggedPed = nil
        
        -- Notify
        Framework.Notify(Framework.GetLocale('drag_stopped'), 'info')
        
        DebugPrint('Stopped dragging')
    end
end

local function StartBeingDragged(draggerServerId)
    local playerPed = PlayerPedId()
    
    isBeingDragged = true
    draggerPed = GetPlayerPed(GetPlayerFromServerId(draggerServerId))
    
    -- Attach to dragger for smooth dragging
    AttachEntityToEntity(
        playerPed,              -- Entity to attach (victim)
        draggerPed,             -- Entity to attach to (dragger)
        0,                      -- Bone index (0 = root bone)
        0.0, -0.5, 0.0,        -- Offset X, Y, Z (behind the dragger)
        0.0, 0.0, 0.0,         -- Rotation X, Y, Z
        false,                  -- p9
        false,                  -- useSoftPinning
        false,                  -- collision
        false,                  -- isPed
        2,                      -- vertexIndex
        true                    -- fixedRot
    )
    
    -- Play enter animation
    PlayDragAnimation(playerPed, 'enter', 'victim')
    
    -- Notify
    Framework.Notify(Framework.GetLocale('being_dragged'), 'warning')
    
    DebugPrint('Being dragged by player ' .. draggerServerId)
end

local function StopBeingDragged()
    local playerPed = PlayerPedId()
    
    if isBeingDragged then
        -- Detach from dragger
        DetachEntity(playerPed, true, false)
        
        -- Play release animation
        PlayDragAnimation(playerPed, 'release', 'victim')
        Wait(1000) -- Let animation play
        StopDragAnimation(playerPed)
        
        isBeingDragged = false
        draggerPed = nil
        
        -- Notify
        Framework.Notify(Framework.GetLocale('drag_released'), 'success')
        
        DebugPrint('Released from drag')
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DRAG SYNCHRONIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    while true do
        Wait(Config.Performance.syncInterval)
        
        if isBeingDragged and draggerPed then
            local playerPed = PlayerPedId()
            
            -- Check if dragger still exists and is close
            if DoesEntityExist(draggerPed) then
                -- Ensure animation is playing
                if not IsEntityPlayingAnim(playerPed, Config.Animations.dict, Config.Animations.victim.enter, 3) then
                    PlayDragAnimation(playerPed, 'enter', 'victim')
                end
            else
                -- Dragger disappeared, stop being dragged
                TriggerServerEvent('lxr-drag:server:forceStopDrag', GetPlayerServerId(PlayerId()))
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SELF-RELEASE KEY HANDLER
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.General.allowSelfRelease then
    CreateThread(function()
        while true do
            Wait(0)
            
            if isBeingDragged then
                -- Draw help text
                local text = "Press ~INPUT_FRONTEND_X~ to break free"
                SetTextScale(0.35, 0.35)
                SetTextColor(255, 255, 255, 255)
                SetTextCentre(true)
                SetTextDropshadow(0, 0, 0, 0, 255)
                BeginTextCommandDisplayText("STRING")
                AddTextComponentString(text)
                EndTextCommandDisplayText(0.5, 0.9)
                
                -- Check for key press
                if IsControlJustPressed(0, Config.Keys.release) then
                    TriggerServerEvent('lxr-drag:server:stopDrag', GetPlayerServerId(PlayerId()))
                end
            else
                Wait(500)
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 COMMAND REGISTRATION
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterCommand('drag', function(source, args, rawCommand)
    local currentTime = GetGameTimer()
    
    -- Anti-spam check
    if Config.Security.antiSpam and (currentTime - lastDragTime) < Config.Security.spamDelay then
        Framework.Notify('Please wait before using this command again', 'error')
        return
    end
    
    lastDragTime = currentTime
    
    if isDragging then
        -- Stop dragging
        TriggerServerEvent('lxr-drag:server:stopDrag', GetPlayerServerId(PlayerId()))
    else
        -- Start dragging
        local closestPlayer, distance = GetClosestPlayer()
        
        if not closestPlayer then
            Framework.Notify(Framework.GetLocale('player_not_found'), 'error')
            return
        end
        
        if distance > Config.General.dragDistance then
            Framework.Notify(Framework.GetLocale('player_too_far'), 'error')
            return
        end
        
        local targetServerId = GetPlayerServerId(closestPlayer)
        local targetPed = GetPlayerPed(closestPlayer)
        
        -- Validation checks
        if targetServerId == GetPlayerServerId(PlayerId()) then
            Framework.Notify(Framework.GetLocale('cannot_drag_self'), 'error')
            return
        end
        
        if Config.General.requireDeadPlayer and not IsPlayerDead(targetPed) then
            Framework.Notify(Framework.GetLocale('player_not_dead'), 'error')
            return
        end
        
        if IsPlayerInVehicle(targetPed) then
            Framework.Notify(Framework.GetLocale('player_in_vehicle'), 'error')
            return
        end
        
        -- Request drag from server
        TriggerServerEvent('lxr-drag:server:startDrag', targetServerId)
    end
end, false)

-- Register command suggestion
TriggerEvent('chat:addSuggestion', '/drag', Framework.GetLocale('drag_command_help'))

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER EVENT HANDLERS
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-drag:client:startDragging', function(targetServerId)
    StartDragging(targetServerId)
end)

RegisterNetEvent('lxr-drag:client:stopDragging', function()
    StopDragging()
end)

RegisterNetEvent('lxr-drag:client:startBeingDragged', function(draggerServerId)
    StartBeingDragged(draggerServerId)
end)

RegisterNetEvent('lxr-drag:client:stopBeingDragged', function()
    StopBeingDragged()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 ANIMATION PRELOAD
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.Performance.cacheAnimations then
    CreateThread(function()
        Wait(5000) -- Wait for game to load
        LoadAnimDict(Config.Animations.dict)
        DebugPrint('Animation dictionary preloaded')
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLEANUP ON RESOURCE STOP
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if isDragging then
            StopDragging()
        end
        if isBeingDragged then
            StopBeingDragged()
        end
    end
end)
