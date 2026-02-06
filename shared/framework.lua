--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
                                                                    
    🐺 LXR Drag - Framework Adapter / Bridge
    
    This file provides a unified interface for multi-framework support.
    It auto-detects the active framework and maps unified function calls
    to framework-specific implementations.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK AUTO-DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

Framework = {}
Framework.ActiveFramework = nil
Framework.FrameworkObject = nil

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end
    
    -- Priority order detection
    local frameworks = {
        'lxr-core',
        'rsg-core',
        'vorp_core',
        'redem_roleplay',
        'qbr-core',
        'qr-core'
    }
    
    for _, fw in ipairs(frameworks) do
        if GetResourceState(fw) == 'started' then
            return fw
        end
    end
    
    return 'standalone'
end

-- Initialize framework
CreateThread(function()
    Wait(500) -- Wait for other resources to load
    
    Framework.ActiveFramework = DetectFramework()
    
    if Config.Debug then
        print('[LXR-Drag] Framework detected: ' .. Framework.ActiveFramework)
    end
    
    -- Initialize framework-specific object
    if Framework.ActiveFramework == 'lxr-core' then
        Framework.FrameworkObject = exports['lxr-core']:GetCoreObject()
    elseif Framework.ActiveFramework == 'rsg-core' then
        Framework.FrameworkObject = exports['rsg-core']:GetCoreObject()
    elseif Framework.ActiveFramework == 'vorp_core' then
        Framework.FrameworkObject = exports.vorp_core:GetCore()
    elseif Framework.ActiveFramework == 'qbr-core' then
        Framework.FrameworkObject = exports['qbr-core']:GetCoreObject()
    elseif Framework.ActiveFramework == 'qr-core' then
        Framework.FrameworkObject = exports['qr-core']:GetCoreObject()
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UNIFIED ADAPTER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

--[[
    These unified functions provide a single interface for core gameplay logic.
    Core scripts call these functions instead of framework-specific calls.
    The adapter maps them to the appropriate framework implementation.
]]

-- ════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ════════════════════════════════════════════════════════════════════════════

function Framework.Notify(message, type, duration)
    if not Config.General.enableNotifications then return end
    
    type = type or 'info'
    duration = duration or 3000
    
    local fw = Framework.ActiveFramework
    local notifSystem = Config.FrameworkSettings[fw] and Config.FrameworkSettings[fw].notifications or 'print'
    
    if notifSystem == 'ox_lib' then
        exports.ox_lib:notify({
            title = 'Drag System',
            description = message,
            type = type,
            duration = duration
        })
    elseif notifSystem == 'vorp' then
        TriggerEvent("vorp:NotifyLeft", "Drag System", message, "generic_textures", "tick", duration)
    elseif notifSystem == 'redem' then
        TriggerEvent('redem_roleplay:NotifyLeft', "Drag System", message, 'inventory_items', 'clothing_generic_gear', duration)
    else
        -- Fallback to print
        print('[LXR-Drag] ' .. message)
    end
end

-- ════════════════════════════════════════════════════════════════════════════
-- PLAYER DATA FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════

function Framework.GetPlayerData()
    local fw = Framework.ActiveFramework
    
    if fw == 'lxr-core' or fw == 'rsg-core' or fw == 'qbr-core' or fw == 'qr-core' then
        if Framework.FrameworkObject and Framework.FrameworkObject.Functions then
            return Framework.FrameworkObject.Functions.GetPlayerData()
        end
    elseif fw == 'vorp_core' then
        if Framework.FrameworkObject then
            return Framework.FrameworkObject.getUser(GetPlayerServerId(PlayerId())).getUsedCharacter
        end
    end
    
    return nil
end

function Framework.IsPlayerLoaded()
    local fw = Framework.ActiveFramework
    
    if fw == 'lxr-core' or fw == 'rsg-core' or fw == 'qbr-core' or fw == 'qr-core' then
        if Framework.FrameworkObject and Framework.FrameworkObject.Functions then
            local PlayerData = Framework.FrameworkObject.Functions.GetPlayerData()
            return PlayerData and PlayerData.citizenid ~= nil
        end
    elseif fw == 'vorp_core' then
        -- VORP uses character selection event
        return true -- Will be set via event
    end
    
    return true -- Standalone always ready
end

-- ════════════════════════════════════════════════════════════════════════════
-- JOB FUNCTIONS (Server-side)
-- ════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() then -- Server-side only
    function Framework.GetPlayerJob(source)
        local fw = Framework.ActiveFramework
        
        if fw == 'lxr-core' or fw == 'rsg-core' or fw == 'qbr-core' or fw == 'qr-core' then
            if Framework.FrameworkObject and Framework.FrameworkObject.Functions then
                local Player = Framework.FrameworkObject.Functions.GetPlayer(source)
                if Player then
                    return Player.PlayerData.job.name, Player.PlayerData.job.grade.level
                end
            end
        elseif fw == 'vorp_core' then
            if Framework.FrameworkObject then
                local User = Framework.FrameworkObject.getUser(source)
                if User then
                    local Character = User.getUsedCharacter
                    return Character.job, Character.jobGrade
                end
            end
        end
        
        return nil, 0
    end
    
    function Framework.GetPlayerIdentifier(source)
        local fw = Framework.ActiveFramework
        
        if fw == 'lxr-core' or fw == 'rsg-core' or fw == 'qbr-core' or fw == 'qr-core' then
            if Framework.FrameworkObject and Framework.FrameworkObject.Functions then
                local Player = Framework.FrameworkObject.Functions.GetPlayer(source)
                if Player then
                    return Player.PlayerData.citizenid
                end
            end
        elseif fw == 'vorp_core' then
            if Framework.FrameworkObject then
                local User = Framework.FrameworkObject.getUser(source)
                if User then
                    return User.getUsedCharacter.identifier
                end
            end
        end
        
        -- Fallback to license
        for k, v in ipairs(GetPlayerIdentifiers(source)) do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                return v
            end
        end
        
        return nil
    end
end

-- ════════════════════════════════════════════════════════════════════════════
-- PERMISSIONS CHECK (Server-side)
-- ════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() then -- Server-side only
    function Framework.HasPermission(source)
        if not Config.Permissions.enabled then
            return true
        end
        
        -- Check ACE permission
        if Config.Permissions.acePermission and IsPlayerAceAllowed(source, Config.Permissions.acePermission) then
            return true
        end
        
        -- Check job permission
        if Config.Permissions.jobs and #Config.Permissions.jobs > 0 then
            local job, grade = Framework.GetPlayerJob(source)
            
            for _, allowedJob in ipairs(Config.Permissions.jobs) do
                if job == allowedJob then
                    -- Check grade if specified
                    if Config.Permissions.grades[allowedJob] then
                        if grade >= Config.Permissions.grades[allowedJob] then
                            return true
                        end
                    else
                        return true
                    end
                end
            end
            
            return false
        end
        
        return true
    end
end

-- ════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════

function Framework.GetLocale(key)
    local lang = Config.Lang or 'en'
    if Config.Locale[lang] and Config.Locale[lang][key] then
        return Config.Locale[lang][key]
    end
    return key
end

-- ════════════════════════════════════════════════════════════════════════════
-- STARTUP NOTIFICATION
-- ════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(2000)
    if Config.Debug then
        print(string.format(
            '[LXR-Drag] Framework Adapter Initialized | Active Framework: %s',
            Framework.ActiveFramework or 'Unknown'
        ))
    end
end)
