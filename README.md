```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
```

# 🐺 LXR Drag - Player Dragging System

**Version:** 1.0.0  
**Author:** iBoss21 / The Lux Empire  
**Server:** The Land of Wolves 🐺 (wolves.land)

## Overview

LXR Drag is a production-grade player dragging system for RedM with full multi-framework support, synchronized animations, and comprehensive security measures. Players can drag other players using the `/drag` command with proper state management and anti-abuse protections.

## ✨ Features

- **Multi-Framework Support**: Auto-detects LXR-Core, RSG-Core, VORP Core, RedEM:RP, QBR, QR, and Standalone
- **Synchronized Animations**: Uses native RedM drag animations for realistic player interactions
- **Security First**: Server-side validation, distance checks, rate limiting, and anti-abuse measures
- **Configurable**: Extensive configuration options for distance, permissions, cooldowns, and behavior
- **Performance Optimized**: Minimal server overhead and client FPS impact
- **Fully Branded**: Land of Wolves / LXR styling throughout

## 🎮 Usage

### Commands

- `/drag` - Toggle dragging the nearest player

### Controls

- **X Key** - Release yourself when being dragged (if `allowSelfRelease` is enabled)

## 📦 Installation

See [Installation Guide](docs/installation.md) for detailed setup instructions.

Quick Start:
1. Download and extract to your resources folder
2. Rename folder to `lxr-drag` (exactly)
3. Add `ensure lxr-drag` to your server.cfg
4. Configure `config.lua` as needed
5. Restart server

## 📚 Documentation

- [Overview](docs/overview.md) - System overview and features
- [Installation](docs/installation.md) - Step-by-step installation
- [Configuration](docs/configuration.md) - All configuration options
- [Frameworks](docs/frameworks.md) - Multi-framework support details
- [Events](docs/events.md) - Event and adapter documentation
- [Security](docs/security.md) - Security features and best practices
- [Performance](docs/performance.md) - Optimization guidelines
- [Screenshots](docs/screenshots.md) - Required screenshots checklist

## 🔧 Configuration Highlights

```lua
Config.General.dragDistance = 3.0        -- Max distance to drag
Config.General.requireDeadPlayer = false -- Only drag dead/downed players
Config.Security.enabled = true           -- Enable security checks
Config.Permissions.enabled = false       -- Enable job/ACE permissions
```

See [Configuration Guide](docs/configuration.md) for all options.

## 🎨 Framework Support

This resource automatically detects and supports:

- **LXR-Core** (Primary)
- **RSG-Core** (Primary)
- **VORP Core** (Compatible)
- **RedEM:RP** (Compatible)
- **QBR-Core** (Compatible)
- **QR-Core** (Compatible)
- **Standalone** (Fallback)

See [Framework Documentation](docs/frameworks.md) for details.

## 🔒 Security Features

- Server-side validation of all drag requests
- Distance validation to prevent exploits
- Rate limiting (max drags per minute)
- Anti-spam protection
- Player state validation
- Suspicious activity logging

See [Security Documentation](docs/security.md) for details.

## 🐺 Land of Wolves

This resource is part of the Land of Wolves / LXR ecosystem:

- **Server:** The Land of Wolves 🐺
- **Tagline:** Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
- **Type:** Serious Hardcore Roleplay
- **Website:** https://www.wolves.land
- **Discord:** https://discord.gg/CrKcWdfd3A
- **Store:** https://theluxempire.tebex.io
- **GitHub:** https://github.com/iBoss21

## 📄 License

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

## 🤝 Support

- Discord: https://discord.gg/CrKcWdfd3A
- GitHub Issues: https://github.com/iboss21/lxr-drag/issues

---

**Crafted with 🐺 by iBoss21 for The Land of Wolves**
