```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
```

# 🐺 LXR Drag - Installation Guide

**Version:** 1.0.0  
**Author:** iBoss21 / The Lux Empire

---

## Prerequisites

### Required

- RedM server (latest build recommended)
- FXServer (latest artifacts)

### Optional (for framework features)

- One of the supported frameworks:
  - LXR-Core
  - RSG-Core
  - VORP Core
  - RedEM:RP
  - QBR-Core
  - QR-Core
  - Or run in Standalone mode

## Installation Steps

### Step 1: Download

Download the latest release from:
- GitHub: https://github.com/iboss21/lxr-drag
- Store: https://theluxempire.tebex.io

### Step 2: Extract

Extract the archive to your server's `resources` folder.

### Step 3: Rename Folder

**CRITICAL:** The folder MUST be named exactly `lxr-drag` (lowercase, with hyphen).

```
resources/
└── lxr-drag/          ← Must be exactly this name
    ├── fxmanifest.lua
    ├── config.lua
    ├── client/
    ├── server/
    └── shared/
```

If the folder name is wrong, the resource will display a critical error and refuse to load.

### Step 4: Add to server.cfg

Add to your `server.cfg`:

```cfg
ensure lxr-drag
```

**Recommended placement:**
- After your framework (if using one)
- Before other player interaction scripts

Example:
```cfg
ensure lxr-core          # Your framework
ensure lxr-drag          # Drag system
ensure lxr-interaction   # Other interaction scripts
```

### Step 5: Configure (Optional)

Edit `config.lua` to customize:

```lua
-- Basic settings
Config.General.dragDistance = 3.0        -- Max drag distance
Config.General.requireDeadPlayer = false -- Only drag dead players?

-- Security
Config.Security.enabled = true           -- Enable security checks
Config.Security.maxDragsPerMinute = 10   -- Rate limit

-- Permissions (if needed)
Config.Permissions.enabled = false       -- Enable job restrictions
Config.Permissions.jobs = {'police'}     -- Allowed jobs
```

See [Configuration Guide](configuration.md) for all options.

### Step 6: Restart Server

```bash
# In server console
restart lxr-drag

# Or full server restart
```

### Step 7: Verify Installation

Check server console for startup banner:

```
═══════════════════════════════════════════════════════════════════════════════

    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 

═══════════════════════════════════════════════════════════════════════════════
🐺 DRAG SYSTEM - SUCCESSFULLY LOADED
═══════════════════════════════════════════════════════════════════════════════

Version:     1.0.0
Server:      The Land of Wolves 🐺

Framework:   Auto-detect enabled
Language:    en
...
```

### Step 8: Test In-Game

1. Join your server
2. Stand near another player
3. Type `/drag` in chat
4. You should start dragging the nearest player
5. Type `/drag` again to stop
6. If being dragged, press X to break free (if enabled)

## Framework-Specific Setup

### LXR-Core / RSG-Core

No additional setup needed. The system will auto-detect and use framework functions.

### VORP Core

No additional setup needed. Ensure vorp_core is started before lxr-drag.

### QBR-Core / QR-Core

No additional setup needed. Framework will be detected automatically.

### RedEM:RP

No additional setup needed. Framework will be detected automatically.

### Standalone (No Framework)

Works out of the box. Notifications will use chat/console instead of framework notifications.

## Post-Installation Configuration

### Permissions Setup

If you want only certain jobs to drag:

```lua
Config.Permissions.enabled = true
Config.Permissions.jobs = {'police', 'sheriff', 'medic'}
Config.Permissions.grades = {
    police = 2,  -- Police need grade 2+
    sheriff = 1  -- Sheriff need grade 1+
}
```

### ACE Permissions

For ACE-based permissions:

```lua
Config.Permissions.enabled = true
Config.Permissions.acePermission = 'drag.use'
```

Then in server.cfg:
```cfg
add_ace group.admin drag.use allow
add_ace group.police drag.use allow
```

### Language Setup

For Georgian language:

```lua
Config.Lang = 'ge'
```

Add custom languages:

```lua
Config.Locale.fr = {
    drag_started = 'Vous traînez un joueur',
    drag_stopped = 'Vous avez arrêté de traîner',
    -- ... more translations
}
```

## Troubleshooting

### Resource Won't Start

**Error: Resource name mismatch**
- Ensure folder is named exactly `lxr-drag` (lowercase, hyphen)

**Error: Missing dependencies**
- Ensure your framework (if any) is started first
- Check `server.cfg` load order

### Command Not Working

**`/drag` does nothing**
- Check server console for errors
- Verify resource is started: `restart lxr-drag`
- Check permissions if enabled

### No Animations

**Players freeze instead of dragging**
- Animation dictionary may not be loaded
- Check Config.Performance.cacheAnimations is true
- Try increasing sync interval in config

### Players Desync

**Dragged player position jumps**
- Lower Config.Performance.syncInterval (default 100ms)
- Check server performance (TPS)
- Verify both players have good connection

### Permission Denied

**Error: Invalid permission**
- Check Config.Permissions settings
- Verify job name matches framework job
- Check ACE permissions if using ACE

## Performance Tuning

For high-population servers:

```lua
Config.Performance.syncInterval = 150    -- Higher = better performance
Config.Performance.nearbyPlayerCheck = 1000
Config.Security.maxDragsPerMinute = 5    -- Lower rate limit
```

For smooth experience:

```lua
Config.Performance.syncInterval = 50     -- Lower = smoother
Config.Performance.cacheAnimations = true
```

## Verification Checklist

- [ ] Folder named exactly `lxr-drag`
- [ ] Added to server.cfg
- [ ] Startup banner appears in console
- [ ] Framework detected (if applicable)
- [ ] `/drag` command works in-game
- [ ] Animations play correctly
- [ ] Self-release works (if enabled)
- [ ] Permissions work (if enabled)
- [ ] No errors in F8 console
- [ ] No errors in server console

## Next Steps

- [Configuration Guide](configuration.md) - Customize all settings
- [Framework Guide](frameworks.md) - Framework-specific details
- [Security Guide](security.md) - Security best practices

## Support

Need help?

- Discord: https://discord.gg/CrKcWdfd3A
- GitHub: https://github.com/iboss21/lxr-drag/issues
- Store: https://theluxempire.tebex.io

---

**🐺 wolves.land - The Land of Wolves**  
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
