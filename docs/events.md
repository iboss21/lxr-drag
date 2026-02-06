```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
```

# 🐺 LXR Drag - Events & API Documentation

**Version:** 1.0.0  
**Author:** iBoss21 / The Lux Empire

---

## Event System Overview

LXR Drag uses a client-server event system for communication and synchronization. This document details all events, triggers, and the adapter API.

---

## Server Events

### Triggers (Client → Server)

#### lxr-drag:server:startDrag

**Purpose:** Request to start dragging a player

**Triggered From:** Client (via `/drag` command)

**Parameters:**
- `target` (number) - Target player's server ID

**Example:**
```lua
TriggerServerEvent('lxr-drag:server:startDrag', targetServerId)
```

**Server Response:**
- Validates request
- Checks permissions
- Verifies distance
- Checks rate limits
- If valid: Triggers client events to both players
- If invalid: Sends error notification

---

#### lxr-drag:server:stopDrag

**Purpose:** Request to stop dragging

**Triggered From:** Client (via `/drag` command when already dragging, or victim self-release)

**Parameters:** None (uses `source`)

**Example:**
```lua
TriggerServerEvent('lxr-drag:server:stopDrag')
```

**Server Response:**
- Stops active drag
- Notifies both players
- Clears drag states

---

#### lxr-drag:server:forceStopDrag

**Purpose:** Force stop drag (emergency)

**Triggered From:** Client (when dragger disappears)

**Parameters:** None (uses `source`)

**Example:**
```lua
TriggerServerEvent('lxr-drag:server:forceStopDrag')
```

**Server Response:**
- Immediately stops drag
- No animations
- Clears states

---

## Client Events

### Handlers (Server → Client)

#### lxr-drag:client:startDragging

**Purpose:** Notify client to start dragging

**Triggered From:** Server (after validation)

**Parameters:**
- `targetServerId` (number) - Target player being dragged

**Example:**
```lua
RegisterNetEvent('lxr-drag:client:startDragging', function(targetServerId)
    -- Client starts dragging animation
end)
```

**Client Actions:**
- Sets `isDragging = true`
- Stores `draggedPed`
- Plays dragger enter animation
- Shows notification

---

#### lxr-drag:client:stopDragging

**Purpose:** Notify client to stop dragging

**Triggered From:** Server

**Parameters:** None

**Example:**
```lua
RegisterNetEvent('lxr-drag:client:stopDragging', function()
    -- Client stops dragging
end)
```

**Client Actions:**
- Plays release animation
- Clears animation
- Sets `isDragging = false`
- Clears `draggedPed`
- Shows notification

---

#### lxr-drag:client:startBeingDragged

**Purpose:** Notify client they're being dragged

**Triggered From:** Server

**Parameters:**
- `draggerServerId` (number) - Player dragging you

**Example:**
```lua
RegisterNetEvent('lxr-drag:client:startBeingDragged', function(draggerServerId)
    -- Client becomes dragged
end)
```

**Client Actions:**
- Sets `isBeingDragged = true`
- Stores `draggerPed`
- Plays victim enter animation
- Starts position synchronization
- Shows notification
- Enables self-release key (if configured)

---

#### lxr-drag:client:stopBeingDragged

**Purpose:** Notify client they're released

**Triggered From:** Server

**Parameters:** None

**Example:**
```lua
RegisterNetEvent('lxr-drag:client:stopBeingDragged', function()
    -- Client is released
end)
```

**Client Actions:**
- Plays release animation
- Clears animation
- Sets `isBeingDragged = false`
- Stops position sync
- Clears `draggerPed`
- Shows notification

---

## Framework Adapter API

### Client Functions

#### Framework.Notify(message, type, duration)

**Purpose:** Show notification to player

**Parameters:**
- `message` (string) - Message text
- `type` (string) - 'info', 'success', 'warning', 'error'
- `duration` (number, optional) - Display time in ms (default: 3000)

**Returns:** None

**Example:**
```lua
Framework.Notify('You started dragging', 'success', 3000)
Framework.Notify('Player too far', 'error')
```

**Supported Types:**
- `info` - Blue/neutral
- `success` - Green/positive
- `warning` - Yellow/caution
- `error` - Red/negative

---

#### Framework.GetPlayerData()

**Purpose:** Get current player's data from framework

**Parameters:** None

**Returns:** Table (framework-specific structure) or nil

**Example:**
```lua
local PlayerData = Framework.GetPlayerData()
if PlayerData then
    local job = PlayerData.job.name
    local citizenid = PlayerData.citizenid
end
```

---

#### Framework.IsPlayerLoaded()

**Purpose:** Check if player is fully loaded

**Parameters:** None

**Returns:** Boolean

**Example:**
```lua
CreateThread(function()
    while not Framework.IsPlayerLoaded() do
        Wait(500)
    end
    -- Player is ready
end)
```

---

#### Framework.GetLocale(key)

**Purpose:** Get localized string

**Parameters:**
- `key` (string) - Locale key

**Returns:** String

**Example:**
```lua
local msg = Framework.GetLocale('drag_started')
Framework.Notify(msg, 'success')
```

---

### Server Functions

#### Framework.GetPlayerJob(source)

**Purpose:** Get player's job and grade

**Parameters:**
- `source` (number) - Player server ID

**Returns:** 
- `job` (string) - Job name
- `grade` (number) - Job grade level

**Example:**
```lua
local job, grade = Framework.GetPlayerJob(source)
if job == 'police' and grade >= 2 then
    -- Allow action
end
```

---

#### Framework.GetPlayerIdentifier(source)

**Purpose:** Get player's unique identifier

**Parameters:**
- `source` (number) - Player server ID

**Returns:** String (identifier)

**Example:**
```lua
local identifier = Framework.GetPlayerIdentifier(source)
print('Player ' .. identifier .. ' used drag')
```

**Identifier Types:**
- **LXR/RSG/QBR/QR:** citizenid
- **VORP:** character identifier
- **Standalone:** license

---

#### Framework.HasPermission(source)

**Purpose:** Check if player has permission to drag

**Parameters:**
- `source` (number) - Player server ID

**Returns:** Boolean

**Example:**
```lua
if not Framework.HasPermission(source) then
    TriggerClientEvent('lxr-drag:client:notify', source, 
        Framework.GetLocale('invalid_permission'), 'error')
    return
end
```

**Permission Checks:**
1. ACE permission (if `Config.Permissions.acePermission` set)
2. Job whitelist (if `Config.Permissions.jobs` not empty)
3. Job grade (if `Config.Permissions.grades` specified)
4. Default allow (if permissions disabled)

---

## Custom Integration

### Listening to Drag Events

**Example: Log all drags to Discord**

```lua
-- Server-side
RegisterNetEvent('lxr-drag:server:startDrag', function(target)
    local source = source
    local draggerName = GetPlayerName(source)
    local targetName = GetPlayerName(target)
    
    -- Your Discord webhook logic
    SendToDiscord(string.format('%s started dragging %s', draggerName, targetName))
end)
```

---

### Preventing Drag in Specific Scenarios

**Example: Prevent drag in safe zones**

```lua
-- Client-side
local inSafeZone = false

RegisterCommand('drag', function()
    if inSafeZone then
        Framework.Notify('Cannot drag in safe zone', 'error')
        return
    end
    
    -- Normal drag logic
end, false)
```

---

### Adding Custom Animations

**Example: Use different animations**

```lua
-- In config.lua
Config.Animations = {
    dict = "your_custom_dict",
    dragger = {
        enter = "your_custom_anim",
        release = "your_release_anim"
    },
    victim = {
        enter = "victim_anim",
        release = "victim_release"
    },
    flags = {
        enter = 1,
        release = 0
    }
}
```

---

### Integrating with Custom Frameworks

**Example: Add support for "MyCore"**

1. **Add to config:**

```lua
Config.FrameworkSettings['my_core'] = {
    resource = 'my_core',
    notifications = 'ox_lib',
    events = {
        server = 'MyCore:Server:%s',
        client = 'MyCore:Client:%s'
    }
}
```

2. **Add detection in shared/framework.lua:**

```lua
local frameworks = {
    'lxr-core',
    'rsg-core',
    'my_core',  -- Add here
    -- ...
}
```

3. **Add framework object:**

```lua
elseif Framework.ActiveFramework == 'my_core' then
    Framework.FrameworkObject = exports['my_core']:GetCoreObject()
```

4. **Implement adapter functions:**

```lua
function Framework.GetPlayerJob(source)
    if fw == 'my_core' then
        local Player = Framework.FrameworkObject.GetPlayer(source)
        return Player.job, Player.jobgrade
    end
    -- ...
end
```

---

## Event Flow Diagrams

### Starting Drag

```
Client (Dragger)
    │
    ├─► /drag command
    │
    ├─► Find closest player
    │
    ├─► Validate (distance, not self, etc.)
    │
    └─► TriggerServerEvent('lxr-drag:server:startDrag', target)
            │
            ▼
        Server
            │
            ├─► Check permissions
            ├─► Validate distance (server-side)
            ├─► Check rate limits
            ├─► Validate player states
            │
            ├─► Update drag states
            │
            ├─► TriggerClientEvent('lxr-drag:client:startDragging', source, target)
            │
            └─► TriggerClientEvent('lxr-drag:client:startBeingDragged', target, source)
                    │                                           │
                    ▼                                           ▼
            Client (Dragger)                            Client (Victim)
                    │                                           │
                    ├─► Play dragger animation                  ├─► Play victim animation
                    ├─► Set isDragging = true                   ├─► Set isBeingDragged = true
                    └─► Show notification                       ├─► Start position sync
                                                                └─► Show notification
```

### Stopping Drag

```
Client (Either Player)
    │
    ├─► /drag command OR X key press
    │
    └─► TriggerServerEvent('lxr-drag:server:stopDrag')
            │
            ▼
        Server
            │
            ├─► Clear drag states
            │
            ├─► TriggerClientEvent('lxr-drag:client:stopDragging', dragger)
            │
            └─► TriggerClientEvent('lxr-drag:client:stopBeingDragged', victim)
                    │                                           │
                    ▼                                           ▼
            Client (Dragger)                            Client (Victim)
                    │                                           │
                    ├─► Play release animation                  ├─► Play release animation
                    ├─► Set isDragging = false                  ├─► Set isBeingDragged = false
                    └─► Show notification                       ├─► Stop position sync
                                                                └─► Show notification
```

---

## Next Steps

- [Security Guide](security.md) - Security features and validation
- [Configuration Guide](configuration.md) - Customize behavior
- [Performance Guide](performance.md) - Optimization tips

---

**🐺 wolves.land - The Land of Wolves**  
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
