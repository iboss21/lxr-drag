```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
```

# 🐺 LXR Drag - Configuration Guide

**Version:** 1.0.0  
**Author:** iBoss21 / The Lux Empire

---

## Configuration Overview

All settings are centralized in `config.lua`. The configuration file is heavily commented and organized into logical sections.

## Table of Contents

1. [Server Information](#server-information)
2. [Framework Settings](#framework-settings)
3. [Language Configuration](#language-configuration)
4. [General Settings](#general-settings)
5. [Key Configuration](#key-configuration)
6. [Animation Configuration](#animation-configuration)
7. [Permissions](#permissions)
8. [Security Settings](#security-settings)
9. [Performance Settings](#performance-settings)
10. [Debug Settings](#debug-settings)

---

## Server Information

Customize server branding (optional):

```lua
Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!',
    type = 'Serious Hardcore Roleplay',
    access = 'Discord & Whitelisted',
    website = 'https://www.wolves.land',
    discord = 'https://discord.gg/CrKcWdfd3A',
    github = 'https://github.com/iBoss21',
    store = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer = 'iBoss21 / The Lux Empire',
    tags = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'Drag', 'PlayerInteraction', 'Roleplay'}
}
```

This is displayed in the startup banner.

---

## Framework Settings

### Framework Selection

```lua
Config.Framework = 'auto'
```

**Options:**
- `'auto'` - Auto-detect (recommended)
- `'lxr-core'` - Force LXR-Core
- `'rsg-core'` - Force RSG-Core
- `'vorp_core'` - Force VORP Core
- `'redem_roleplay'` - Force RedEM:RP
- `'qbr-core'` - Force QBR-Core
- `'qr-core'` - Force QR-Core
- `'standalone'` - Force standalone mode

**Detection Priority (when auto):**
1. LXR-Core
2. RSG-Core
3. VORP Core
4. RedEM:RP
5. QBR-Core
6. QR-Core
7. Standalone (fallback)

### Framework-Specific Settings

Each framework has its own configuration:

```lua
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',
        notifications = 'ox_lib',
        events = {
            server = 'lxr-core:server:%s',
            client = 'lxr-core:client:%s',
            callback = 'lxr-core:callback:%s'
        }
    },
    -- ... more frameworks
}
```

**Do not modify unless you know what you're doing.**

---

## Language Configuration

### Active Language

```lua
Config.Lang = 'en'  -- 'en' or 'ge'
```

### Locale Strings

Built-in languages:

**English (`en`):**
```lua
Config.Locale.en = {
    drag_started = 'You are now dragging a player',
    drag_stopped = 'You stopped dragging',
    being_dragged = 'You are being dragged',
    drag_released = 'You were released',
    player_not_found = 'No player nearby to drag',
    player_too_far = 'Player is too far away',
    cannot_drag_self = 'You cannot drag yourself',
    already_dragging = 'You are already dragging someone',
    player_already_dragged = 'This player is already being dragged',
    drag_command_help = 'Toggle dragging the nearest player',
    invalid_permission = 'You do not have permission to use this command',
    player_not_dead = 'You can only drag dead/downed players',
    player_in_vehicle = 'Cannot drag player in vehicle'
}
```

**Georgian (`ge`):**
```lua
Config.Locale.ge = {
    drag_started = 'თამაშის მოთამაშის გადატანა დაიწყო',
    -- ... more Georgian translations
}
```

### Adding Custom Languages

```lua
Config.Locale.es = {
    drag_started = 'Estás arrastrando a un jugador',
    drag_stopped = 'Dejaste de arrastrar',
    -- ... more Spanish translations
}

Config.Lang = 'es'
```

---

## General Settings

```lua
Config.General = {
    dragDistance = 3.0,           -- Max distance to start dragging (meters)
    enableSounds = true,          -- Enable drag sounds (future feature)
    requireDeadPlayer = false,    -- Only allow dragging dead/downed players
    allowSelfRelease = true,      -- Allow dragged player to press X to release
    enableNotifications = true    -- Show notifications for drag events
}
```

### dragDistance

How close you must be to start dragging.

- **Low (1.0-2.0)**: Must be very close
- **Medium (2.5-3.5)**: Comfortable range (recommended)
- **High (4.0-5.0)**: Can drag from further away

### requireDeadPlayer

**false** - Can drag any player (good for general RP)  
**true** - Can only drag dead/downed players (good for serious RP, medical scenarios)

### allowSelfRelease

**true** - Dragged player can press X to break free  
**false** - Only dragger can stop drag

---

## Key Configuration

```lua
Config.Keys = {
    release = 0x8CC9CD42  -- X key to release when being dragged
}
```

RedM key hashes:
- `0x8CC9CD42` - X key
- `0xD9D0E1C0` - Space
- `0x156F7119` - E key

Find more: https://github.com/femga/rdr3_discoveries/tree/master/Controls

---

## Animation Configuration

```lua
Config.Animations = {
    dict = "mech_grapple@unarmed@_male@ind1@_healthy@drag@_streamed",
    
    dragger = {
        enter = "enter_drag_front_onass_att",
        release = "release_att",
        throw = "throw_fwd_att"
    },
    
    victim = {
        enter = "enter_drag_front_onass_vic",
        release = "release_vic",
        throw = "throw_fwd_vic"
    },
    
    flags = {
        enter = 1,    -- Animation flag for entering drag (repeat)
        release = 0,  -- Animation flag for release (normal)
        throw = 0     -- Animation flag for throw (normal)
    }
}
```

**Do not modify unless replacing with different animations.**

Animation flags:
- `0` - Normal (play once)
- `1` - Repeat
- `2` - Stop on last frame
- `4` - Upperbody only
- `8` - Allow player control

---

## Permissions

```lua
Config.Permissions = {
    enabled = false,              -- Enable permission checks
    jobs = {},                    -- Allowed jobs (empty = all jobs)
    grades = {},                  -- Minimum job grades
    acePermission = 'drag.use'    -- ACE permission name
}
```

### Job-Based Permissions

**Allow specific jobs:**
```lua
Config.Permissions.enabled = true
Config.Permissions.jobs = {'police', 'sheriff', 'medic'}
```

**Require minimum grades:**
```lua
Config.Permissions.grades = {
    police = 2,   -- Police need grade 2+
    sheriff = 1,  -- Sheriff need grade 1+
    medic = 0     -- Medic any grade
}
```

### ACE Permissions

```lua
Config.Permissions.enabled = true
Config.Permissions.acePermission = 'drag.use'
```

In server.cfg:
```cfg
add_ace group.admin drag.use allow
add_ace identifier.license:abc123 drag.use allow
```

---

## Security Settings

```lua
Config.Security = {
    enabled = true,                  -- Enable security checks
    maxDragDistance = 5.0,           -- Max distance validation (server-side)
    validatePlayerExists = true,     -- Validate target player exists
    logSuspiciousActivity = false,   -- Log suspicious behavior
    antiSpam = true,                 -- Prevent command spam
    spamDelay = 2000,                -- Delay between drag toggles (ms)
    maxDragsPerMinute = 10           -- Max drag attempts per minute
}
```

### enabled

Master switch for all security features.

**Recommendation:** Always keep `true` for public servers.

### maxDragDistance

Server-side distance validation. Should be higher than `Config.General.dragDistance` to account for lag.

**Formula:** `maxDragDistance = dragDistance + 2.0`

### logSuspiciousActivity

Logs suspicious behavior to server console.

**Examples logged:**
- Exceeding drag rate limit
- Suspicious distances
- Invalid state transitions

### antiSpam

Prevents players from spamming the `/drag` command.

### maxDragsPerMinute

Rate limit per player.

**Server Type Recommendations:**
- **Serious RP:** 5-10
- **Casual RP:** 10-15
- **PvP/Action:** 15-20

---

## Performance Settings

```lua
Config.Performance = {
    syncInterval = 100,            -- Position sync interval in ms
    nearbyPlayerCheck = 500,       -- Check for nearby players every X ms
    cleanupInterval = 300000,      -- Cleanup old data every 5 minutes
    cacheAnimations = true         -- Pre-cache animation dictionaries
}
```

### syncInterval

How often dragged player position updates (milliseconds).

**Lower = Smoother but more resource usage**
- **Ultra Smooth (50ms)**: High resource usage
- **Smooth (100ms)**: Balanced (recommended)
- **Performance (150ms)**: Lower resource usage
- **Low Performance (200ms)**: Noticeable lag

### nearbyPlayerCheck

How often client checks for nearby players.

**Lower = More responsive but more CPU**

### cacheAnimations

**true** - Preload animations on client startup (smoother)  
**false** - Load animations on-demand (slower first drag)

**Recommendation:** Keep `true` unless you have many scripts loading animations.

---

## Debug Settings

```lua
Config.Debug = false  -- Enable debug prints and extra logging
```

**true** - Prints detailed information to console  
**false** - Normal operation (recommended for production)

**When to enable:**
- Troubleshooting issues
- Testing configuration changes
- Development/debugging

**Output examples:**
```
[LXR-Drag Client] Started dragging player 5
[LXR-Drag Server] Player 3 started dragging 5
[LXR-Drag Client] Animation dictionary preloaded
```

---

## Configuration Templates

### Serious RP Server

```lua
Config.General.dragDistance = 2.5
Config.General.requireDeadPlayer = true
Config.General.allowSelfRelease = false

Config.Permissions.enabled = true
Config.Permissions.jobs = {'police', 'sheriff', 'medic'}

Config.Security.enabled = true
Config.Security.maxDragsPerMinute = 5
Config.Security.logSuspiciousActivity = true
```

### Casual RP Server

```lua
Config.General.dragDistance = 3.5
Config.General.requireDeadPlayer = false
Config.General.allowSelfRelease = true

Config.Permissions.enabled = false

Config.Security.enabled = true
Config.Security.maxDragsPerMinute = 15
```

### PvP/Action Server

```lua
Config.General.dragDistance = 4.0
Config.General.requireDeadPlayer = false
Config.General.allowSelfRelease = true

Config.Permissions.enabled = false

Config.Security.enabled = true
Config.Security.maxDragsPerMinute = 20

Config.Performance.syncInterval = 50  -- Smoother for fast action
```

---

## Next Steps

- [Frameworks Guide](frameworks.md) - Framework-specific details
- [Security Guide](security.md) - Security best practices
- [Performance Guide](performance.md) - Optimization tips

---

**🐺 wolves.land - The Land of Wolves**  
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
