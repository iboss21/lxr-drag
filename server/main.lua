--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
                                                                    
    🐺 LXR Drag - Server Script
    
    Server-side drag system with security validation and state management.
    Handles drag authorization, distance validation, and anti-abuse measures.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 STATE MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

local dragStates = {}
local dragAttempts = {}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local function DebugPrint(msg)
    if Config.Debug then
        print('[LXR-Drag Server] ' .. msg)
    end
end

local function GetPlayerCoords(source)
    local ped = GetPlayerPed(source)
    if ped and ped > 0 then
        return GetEntityCoords(ped)
    end
    return nil
end

local function GetDistance(source1, source2)
    local coords1 = GetPlayerCoords(source1)
    local coords2 = GetPlayerCoords(source2)
    
    if not coords1 or not coords2 then
        return 999999
    end
    
    return #(coords1 - coords2)
end

local function IsDragging(source)
    return dragStates[source] and dragStates[source].dragging ~= nil
end

local function IsBeingDragged(source)
    return dragStates[source] and dragStates[source].draggedBy ~= nil
end

local function GetDragTarget(source)
    if dragStates[source] and dragStates[source].dragging then
        return dragStates[source].dragging
    end
    return nil
end

local function GetDragger(source)
    if dragStates[source] and dragStates[source].draggedBy then
        return dragStates[source].draggedBy
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 ANTI-ABUSE SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

local function CheckDragAttempts(source)
    if not Config.Security.antiSpam then
        return true
    end
    
    local currentTime = os.time()
    
    if not dragAttempts[source] then
        dragAttempts[source] = {
            attempts = {},
            lastAttempt = 0
        }
    end
    
    -- Remove old attempts (older than 60 seconds)
    local newAttempts = {}
    for _, timestamp in ipairs(dragAttempts[source].attempts) do
        if (currentTime - timestamp) < 60 then
            table.insert(newAttempts, timestamp)
        end
    end
    dragAttempts[source].attempts = newAttempts
    
    -- Check if too many attempts
    if #dragAttempts[source].attempts >= Config.Security.maxDragsPerMinute then
        DebugPrint(string.format('Player %s exceeded max drag attempts per minute', source))
        if Config.Security.logSuspiciousActivity then
            print(string.format('[LXR-Drag SECURITY] Player %s exceeded max drag attempts (%d/min)', 
                source, Config.Security.maxDragsPerMinute))
        end
        return false
    end
    
    -- Add new attempt
    table.insert(dragAttempts[source].attempts, currentTime)
    dragAttempts[source].lastAttempt = currentTime
    
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DRAG VALIDATION
-- ═══════════════════════════════════════════════════════════════════════════════

local function ValidateDragStart(source, target)
    -- Check if players exist
    if not source or not target then
        DebugPrint('Invalid source or target')
        return false, 'player_not_found'
    end
    
    -- Check if same player
    if source == target then
        DebugPrint('Cannot drag self')
        return false, 'cannot_drag_self'
    end
    
    -- Check permissions
    if not Framework.HasPermission(source) then
        DebugPrint(string.format('Player %s lacks permission', source))
        return false, 'invalid_permission'
    end
    
    -- Check if already dragging someone
    if IsDragging(source) then
        DebugPrint(string.format('Player %s already dragging', source))
        return false, 'already_dragging'
    end
    
    -- Check if target is already being dragged
    if IsBeingDragged(target) then
        DebugPrint(string.format('Player %s already being dragged', target))
        return false, 'player_already_dragged'
    end
    
    -- Check distance
    if Config.Security.enabled and Config.Security.maxDragDistance then
        local distance = GetDistance(source, target)
        if distance > Config.Security.maxDragDistance then
            DebugPrint(string.format('Distance too far: %.2f > %.2f', distance, Config.Security.maxDragDistance))
            return false, 'player_too_far'
        end
    end
    
    -- Check rate limit
    if not CheckDragAttempts(source) then
        return false, 'too_many_attempts'
    end
    
    return true, nil
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DRAG STATE MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

local function StartDrag(source, target)
    -- Initialize states if needed
    if not dragStates[source] then
        dragStates[source] = {}
    end
    if not dragStates[target] then
        dragStates[target] = {}
    end
    
    -- Set drag states
    dragStates[source].dragging = target
    dragStates[target].draggedBy = source
    
    -- Notify clients
    TriggerClientEvent('lxr-drag:client:startDragging', source, target)
    TriggerClientEvent('lxr-drag:client:startBeingDragged', target, source)
    
    DebugPrint(string.format('Player %s started dragging %s', source, target))
end

local function StopDrag(source)
    local target = GetDragTarget(source)
    
    if target then
        -- Clear states
        if dragStates[source] then
            dragStates[source].dragging = nil
        end
        if dragStates[target] then
            dragStates[target].draggedBy = nil
        end
        
        -- Notify clients
        TriggerClientEvent('lxr-drag:client:stopDragging', source)
        TriggerClientEvent('lxr-drag:client:stopBeingDragged', target)
        
        DebugPrint(string.format('Player %s stopped dragging %s', source, target))
    end
end

local function StopBeingDragged(target)
    local dragger = GetDragger(target)
    
    if dragger then
        -- Clear states
        if dragStates[dragger] then
            dragStates[dragger].dragging = nil
        end
        if dragStates[target] then
            dragStates[target].draggedBy = nil
        end
        
        -- Notify clients
        TriggerClientEvent('lxr-drag:client:stopDragging', dragger)
        TriggerClientEvent('lxr-drag:client:stopBeingDragged', target)
        
        DebugPrint(string.format('Player %s released from drag by %s', target, dragger))
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 EVENT HANDLERS
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-drag:server:startDrag', function(target)
    local source = source
    
    -- Validate
    local valid, errorKey = ValidateDragStart(source, target)
    
    if not valid then
        if errorKey then
            TriggerClientEvent('lxr-drag:client:notify', source, Framework.GetLocale(errorKey), 'error')
        end
        return
    end
    
    -- Start drag
    StartDrag(source, target)
end)

RegisterNetEvent('lxr-drag:server:stopDrag', function()
    local source = source
    
    if IsDragging(source) then
        StopDrag(source)
    elseif IsBeingDragged(source) then
        StopBeingDragged(source)
    end
end)

RegisterNetEvent('lxr-drag:server:forceStopDrag', function()
    local source = source
    
    if IsDragging(source) then
        StopDrag(source)
    elseif IsBeingDragged(source) then
        StopBeingDragged(source)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 PLAYER DISCONNECT HANDLER
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('playerDropped', function(reason)
    local source = source
    
    -- Stop any active drags
    if IsDragging(source) then
        StopDrag(source)
    end
    if IsBeingDragged(source) then
        StopBeingDragged(source)
    end
    
    -- Cleanup state
    dragStates[source] = nil
    dragAttempts[source] = nil
    
    DebugPrint(string.format('Player %s disconnected, cleaned up drag state', source))
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DISTANCE MONITORING (Security)
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.Security.enabled and Config.Security.maxDragDistance then
    CreateThread(function()
        while true do
            Wait(5000) -- Check every 5 seconds
            
            for dragger, state in pairs(dragStates) do
                if state.dragging then
                    local target = state.dragging
                    local distance = GetDistance(dragger, target)
                    
                    -- If distance is suspicious, force stop
                    if distance > (Config.Security.maxDragDistance * 3) then
                        if Config.Security.logSuspiciousActivity then
                            print(string.format(
                                '[LXR-Drag SECURITY] Suspicious distance detected: %s dragging %s (%.2fm)',
                                dragger, target, distance
                            ))
                        end
                        StopDrag(dragger)
                    end
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLEANUP THREAD
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    while true do
        Wait(Config.Performance.cleanupInterval)
        
        -- Cleanup old drag attempts
        local currentTime = os.time()
        for source, data in pairs(dragAttempts) do
            if (currentTime - data.lastAttempt) > 300 then -- 5 minutes
                dragAttempts[source] = nil
            end
        end
        
        DebugPrint('Performed cleanup of old data')
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 STARTUP MESSAGE
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(3000)
    DebugPrint('Server-side drag system initialized')
    print('[LXR-Drag] Server-side drag system ready')
end)
