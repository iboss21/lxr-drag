```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
```

# 🐺 LXR Drag - System Overview

**Version:** 1.0.0  
**Author:** iBoss21 / The Lux Empire  
**Purpose:** Production-grade player dragging system for RedM

---

## What is LXR Drag?

LXR Drag is a fully synchronized player dragging system that allows players to drag other players in RedM using the `/drag` command. The system uses native RedM animations, includes comprehensive security measures, and supports multiple frameworks through an auto-detection adapter.

## Core Features

### 🎮 Gameplay Features

- **Simple Command Interface**: `/drag` to toggle dragging nearest player
- **Synchronized Animations**: Uses mech_grapple animation dictionary for realistic dragging
- **Position Synchronization**: Dragged player follows dragger smoothly
- **Self-Release Option**: Dragged player can press X to break free (configurable)
- **Distance-Based**: Only drag players within configured range

### 🔧 Technical Features

- **Multi-Framework Support**: Auto-detects and works with 7+ frameworks
- **Framework Adapter Pattern**: Unified interface for all frameworks
- **Server Authority**: All validation happens server-side
- **State Management**: Tracks drag states across all players
- **Performance Optimized**: Configurable sync intervals and cleanup

### 🔒 Security Features

- **Distance Validation**: Server-side distance checks
- **Permission System**: Optional job/ACE permission requirements
- **Rate Limiting**: Max drags per minute per player
- **Anti-Spam**: Cooldown between drag toggles
- **Suspicious Activity Logging**: Tracks potential exploits
- **Player State Validation**: Ensures valid drag scenarios

### 🎨 Presentation Features

- **Full Branding**: Land of Wolves / LXR styling throughout
- **Resource Name Protection**: Enforces correct folder name
- **Startup Banner**: Beautiful ASCII art boot message
- **Localization Support**: English and Georgian (expandable)
- **Comprehensive Documentation**: Copy-paste ready docs

## Architecture

### File Structure

```
lxr-drag/
├── fxmanifest.lua          # Resource manifest with branding
├── config.lua              # Central configuration with all settings
├── client/
│   ├── README.md
│   └── main.lua            # Client-side drag mechanics
├── server/
│   ├── README.md
│   └── main.lua            # Server-side validation & state
├── shared/
│   ├── README.md
│   └── framework.lua       # Multi-framework adapter
└── docs/
    ├── overview.md         # This file
    ├── installation.md     # Setup instructions
    ├── configuration.md    # Config options
    ├── frameworks.md       # Framework details
    ├── events.md           # Event documentation
    ├── security.md         # Security features
    ├── performance.md      # Optimization guide
    └── screenshots.md      # Screenshot requirements
```

### Component Responsibilities

**config.lua**
- Centralized settings
- Framework detection settings
- Animation configuration
- Security parameters
- Localization strings

**shared/framework.lua**
- Framework auto-detection
- Unified adapter functions
- Per-framework implementations
- Notification routing

**client/main.lua**
- Command registration
- Player detection
- Animation playback
- Position synchronization
- UI/notification display

**server/main.lua**
- Drag authorization
- Permission checks
- Distance validation
- State management
- Anti-abuse enforcement

## How It Works

### Drag Flow

1. **Player uses `/drag` command**
   - Client finds nearest player
   - Client validates basic requirements
   - Client sends request to server

2. **Server validates request**
   - Checks permissions (if enabled)
   - Validates distance
   - Checks rate limits
   - Validates player states

3. **Server authorizes drag**
   - Updates drag states for both players
   - Sends events to both clients
   - Monitors distance ongoing

4. **Clients synchronize**
   - Dragger plays attacker animation
   - Victim plays victim animation
   - Victim position follows dragger

5. **Drag ends**
   - Either player can stop (dragger uses `/drag` again, victim presses X)
   - Server clears states
   - Clients play release animations

## Animation System

The system uses the `mech_grapple@unarmed@_male@ind1@_healthy@drag@_streamed` animation dictionary:

- **enter_drag_front_onass_att** - Dragger enters drag
- **enter_drag_front_onass_vic** - Victim enters drag
- **release_att** - Dragger releases
- **release_vic** - Victim is released

Animations are preloaded on client startup for smooth playback.

## State Management

The server maintains drag states:

```lua
dragStates = {
    [playerId] = {
        dragging = targetId,     -- Who this player is dragging
        draggedBy = draggerId    -- Who is dragging this player
    }
}
```

On player disconnect or resource stop, states are cleaned up automatically.

## Use Cases

### Roleplay Scenarios

- **Medical**: Medics drag injured players to safety
- **Law Enforcement**: Officers drag suspects or move bodies
- **Rescue**: Players help each other in dangerous situations
- **Combat**: Tactical player movement during firefights

### Server Types

- **Serious RP**: With `requireDeadPlayer = true` and permissions
- **Casual RP**: Open drag for all players
- **PvP**: Quick player movement mechanics
- **Survival**: Help injured teammates

## Comparison to Alternatives

### Why LXR Drag?

- **Production Grade**: Built for Land of Wolves, a serious RP server
- **Security First**: Comprehensive validation and anti-abuse
- **Multi-Framework**: Works across all major RedM frameworks
- **Maintained**: Active development and support
- **Documented**: Extensive, copy-paste ready documentation
- **Branded**: Professional presentation matching server identity

### vs Basic Drag Scripts

- ✓ Server-side validation (not just client)
- ✓ Rate limiting and anti-abuse
- ✓ Multi-framework support
- ✓ State management with cleanup
- ✓ Permission system
- ✓ Professional documentation

## Next Steps

- [Installation Guide](installation.md) - Get started
- [Configuration Guide](configuration.md) - Customize behavior
- [Framework Guide](frameworks.md) - Framework-specific info
- [Security Guide](security.md) - Security best practices

---

**🐺 wolves.land - The Land of Wolves**  
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
