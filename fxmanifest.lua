--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
                                                                    
    🐺 LXR Drag - Player Dragging System
    
    This resource provides a fully synchronized player dragging system for RedM.
    Players can drag other players using the /drag command with proper animations,
    security checks, and multi-framework support.
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    
    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted
    
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    Version: 1.0.0
    Performance Target: Optimized for minimal server overhead and client FPS impact
    
    Tags: RedM, Georgian, SeriousRP, Whitelist, Drag, PlayerInteraction, Roleplay
    
    Framework Support:
    - LXR Core (Primary)
    - RSG Core (Primary)
    - VORP Core (Compatible)
    - RedEM:RP (Compatible)
    - QBR Core (Compatible)
    - QR Core (Compatible)
    - Standalone (Compatible)
    
    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    Animation Research: RedM Community
    Inspired by: Enhanced roleplay player interactions
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'

name 'lxr-drag'
author 'iBoss21 / The Lux Empire'
description '🐺 LXR Drag - Player Dragging System | Multi-framework support with auto-detection | wolves.land'
version '1.0.0'

--[[
    ═══════════════════════════════════════════════════════════════════════════════
    SCOPE: Player Dragging System
    ═══════════════════════════════════════════════════════════════════════════════
    
    This manifest defines the player dragging system for RedM.
    
    Responsibilities:
    - Load configuration and framework detection
    - Initialize client-side drag controls and animations
    - Initialize server-side validation and synchronization
    - Provide multi-framework support through adapter layer
    
    Architecture:
    - config.lua:           Central configuration with all settings
    - shared/framework.lua: Framework detection and unified adapter
    - client/main.lua:      Client-side drag mechanics and animations
    - server/main.lua:      Server-side validation and state management
    
    ═══════════════════════════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- SHARED FILES (Loaded on both client and server)
-- ═══════════════════════════════════════════════════════════════════════════════
shared_scripts {
    'config.lua',
    'shared/framework.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- CLIENT FILES (Player-side scripts)
-- ═══════════════════════════════════════════════════════════════════════════════
client_scripts {
    'client/main.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVER FILES (Authority and validation)
-- ═══════════════════════════════════════════════════════════════════════════════
server_scripts {
    'server/main.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEPENDENCIES (Optional - multi-framework support)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Note: No hard dependencies as this resource supports multiple frameworks
-- and standalone mode. Framework detection happens at runtime.
