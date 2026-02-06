```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
```

# 🐺 LXR Drag - Framework Support Guide

**Version:** 1.0.0  
**Author:** iBoss21 / The Lux Empire

---

## Multi-Framework Architecture

LXR Drag uses a **Framework Adapter Pattern** to support multiple frameworks through a unified interface. Core gameplay logic calls adapter functions instead of framework-specific code.

### How It Works

```
Core Logic → Framework Adapter → Detected Framework → Framework Functions
```

**Example:**
```lua
-- Core logic (works everywhere)
Framework.Notify('You are dragging a player', 'success')

-- Adapter routes to framework
if framework == 'lxr-core' then
    exports.ox_lib:notify({...})
elseif framework == 'vorp_core' then
    TriggerEvent("vorp:NotifyLeft", ...)
end
```

---

## Supported Frameworks

### 1. LXR-Core (Primary)

**Status:** ✅ Primary Support  
**Resource:** `lxr-core`  
**Notifications:** ox_lib

**Features:**
- Full permission integration
- Job-based restrictions
- Player data access
- Identifier retrieval

**No configuration needed** - Auto-detected and fully supported.

---

### 2. RSG-Core (Primary)

**Status:** ✅ Primary Support  
**Resource:** `rsg-core`  
**Notifications:** ox_lib

**Features:**
- Full permission integration
- Job-based restrictions
- Player data access
- Identifier retrieval

**No configuration needed** - Auto-detected and fully supported.

**Event naming:**
- Server: `RSGCore:Server:*`
- Client: `RSGCore:Client:*`
- Callbacks: `RSGCore:Callback:*`

---

### 3. VORP Core (Compatible)

**Status:** ✅ Compatible  
**Resource:** `vorp_core`  
**Notifications:** VORP native

**Features:**
- Permission integration
- Job-based restrictions
- Player data access
- Character system support

**Setup:**
Ensure `vorp_core` starts before `lxr-drag`:

```cfg
ensure vorp_core
ensure lxr-drag
```

**Event naming:**
- Server: `vorp:server:*`
- Client: `vorp:client:*`

**Notifications:**
Uses VORP's native notification system (`vorp:NotifyLeft`).

---

### 4. RedEM:RP (Compatible)

**Status:** ✅ Compatible  
**Resource:** `redem_roleplay`  
**Notifications:** RedEM native

**Features:**
- Basic integration
- Job system support (if applicable)

**Setup:**
Ensure `redem_roleplay` starts before `lxr-drag`:

```cfg
ensure redem_roleplay
ensure lxr-drag
```

**Event naming:**
- Server: `redem:*:server`
- Client: `redem:*:client`

---

### 5. QBR-Core (Compatible)

**Status:** ✅ Compatible  
**Resource:** `qbr-core`  
**Notifications:** ox_lib

**Features:**
- Full permission integration
- Job-based restrictions
- Player data access

**Event naming:**
- Server: `QBR:Server:*`
- Client: `QBR:Client:*`

---

### 6. QR-Core (Compatible)

**Status:** ✅ Compatible  
**Resource:** `qr-core`  
**Notifications:** ox_lib

**Features:**
- Full permission integration
- Job-based restrictions
- Player data access

**Event naming:**
- Server: `QR:Server:*`
- Client: `QR:Client:*`

---

### 7. Standalone (Fallback)

**Status:** ✅ Fallback Mode  
**Resource:** None  
**Notifications:** Console/Chat

**Features:**
- No framework dependency
- Basic drag functionality
- Console notifications
- No permission system

**When Used:**
- No framework detected
- Manually set: `Config.Framework = 'standalone'`

**Limitations:**
- No job-based permissions
- No framework-specific features
- Console-only notifications

---

## Auto-Detection

### Detection Order

When `Config.Framework = 'auto'`, detection follows this priority:

1. **LXR-Core** (`lxr-core`)
2. **RSG-Core** (`rsg-core`)
3. **VORP Core** (`vorp_core`)
4. **RedEM:RP** (`redem_roleplay`)
5. **QBR-Core** (`qbr-core`)
6. **QR-Core** (`qr-core`)
7. **Standalone** (fallback)

### Detection Logic

```lua
function DetectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework
    end
    
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
```

### Manual Override

Force specific framework:

```lua
Config.Framework = 'rsg-core'  -- Forces RSG-Core
```

**When to use:**
- Running multiple frameworks (advanced)
- Testing specific framework
- Troubleshooting detection issues

---

## Adapter Functions

### Client-Side

#### Framework.Notify(message, type, duration)

Shows notification to player.

**Parameters:**
- `message` (string) - Notification text
- `type` (string) - 'info', 'success', 'warning', 'error'
- `duration` (number) - Display time in ms (optional)

**Example:**
```lua
Framework.Notify('You started dragging', 'success', 3000)
```

**Routing:**
- **ox_lib frameworks:** `exports.ox_lib:notify()`
- **VORP:** `TriggerEvent("vorp:NotifyLeft")`
- **RedEM:** `TriggerEvent('redem_roleplay:NotifyLeft')`
- **Standalone:** `print()`

#### Framework.GetPlayerData()

Gets current player's data.

**Returns:** Table with player data (framework-specific)

**Example:**
```lua
local PlayerData = Framework.GetPlayerData()
if PlayerData then
    local job = PlayerData.job.name
end
```

#### Framework.IsPlayerLoaded()

Checks if player is fully loaded.

**Returns:** Boolean

**Example:**
```lua
if Framework.IsPlayerLoaded() then
    -- Player is ready
end
```

#### Framework.GetLocale(key)

Gets localized string.

**Parameters:**
- `key` (string) - Locale key

**Returns:** String

**Example:**
```lua
local text = Framework.GetLocale('drag_started')
-- Returns: 'You are now dragging a player'
```

### Server-Side

#### Framework.GetPlayerJob(source)

Gets player's job and grade.

**Parameters:**
- `source` (number) - Player server ID

**Returns:** job (string), grade (number)

**Example:**
```lua
local job, grade = Framework.GetPlayerJob(source)
if job == 'police' and grade >= 2 then
    -- Allow action
end
```

#### Framework.GetPlayerIdentifier(source)

Gets player's unique identifier.

**Parameters:**
- `source` (number) - Player server ID

**Returns:** String (identifier)

**Example:**
```lua
local identifier = Framework.GetPlayerIdentifier(source)
-- Returns: citizenid, characterid, or license
```

#### Framework.HasPermission(source)

Checks if player has permission to use drag.

**Parameters:**
- `source` (number) - Player server ID

**Returns:** Boolean

**Example:**
```lua
if Framework.HasPermission(source) then
    -- Allow drag
else
    -- Deny
end
```

**Checks (in order):**
1. ACE permission (if configured)
2. Job permission (if configured)
3. Job grade (if configured)
4. Default (true if permissions disabled)

---

## Framework-Specific Notes

### LXR-Core / RSG-Core

**Player Data Structure:**
```lua
PlayerData = {
    citizenid = "ABC123",
    job = {
        name = "police",
        label = "Police",
        grade = {
            level = 2,
            name = "Officer"
        }
    }
}
```

### VORP Core

**Character System:**
VORP uses character-based system. Adapter handles character selection.

**Player Data Structure:**
```lua
Character = {
    identifier = "steam:123456",
    job = "police",
    jobGrade = 2
}
```

### Standalone

**Limited Features:**
- No player data
- No job system
- No framework events
- Basic functionality only

**Use Case:**
Testing or servers without framework.

---

## Adding New Frameworks

To add a new framework:

1. **Add to Config.FrameworkSettings:**

```lua
Config.FrameworkSettings['my_core'] = {
    resource = 'my_core',
    notifications = 'ox_lib',
    events = {
        server = 'MyCore:Server:%s',
        client = 'MyCore:Client:%s',
        callback = 'MyCore:Callback:%s'
    }
}
```

2. **Add to Detection:**

Edit `shared/framework.lua`:

```lua
local frameworks = {
    'lxr-core',
    'rsg-core',
    'vorp_core',
    'my_core',  -- Add here
    -- ...
}
```

3. **Add Framework Object Initialization:**

```lua
elseif Framework.ActiveFramework == 'my_core' then
    Framework.FrameworkObject = exports['my_core']:GetCoreObject()
```

4. **Implement Adapter Functions:**

Add framework-specific logic to adapter functions in `shared/framework.lua`.

---

## Troubleshooting

### Wrong Framework Detected

**Check detection:**
```lua
Config.Debug = true  -- Enable debug mode
-- Restart resource
-- Check console for: "Framework detected: xxx"
```

**Force specific:**
```lua
Config.Framework = 'your-framework'
```

### Notifications Not Working

**Check notification system:**
- Ensure ox_lib is installed (for ox_lib frameworks)
- Verify framework notifications work elsewhere
- Check `Config.FrameworkSettings[framework].notifications`

### Permissions Not Working

**Check framework object:**
```lua
-- In server console while in-game
/scriptexecutor Framework.FrameworkObject
```

Should return object, not nil.

**Check job names:**
Ensure job names in Config match framework job names exactly (case-sensitive).

---

## Next Steps

- [Events Documentation](events.md) - Event and callback details
- [Configuration Guide](configuration.md) - Customize settings
- [Security Guide](security.md) - Security best practices

---

**🐺 wolves.land - The Land of Wolves**  
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
