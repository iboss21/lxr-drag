# 🐺 Client Scripts

This folder contains client-side scripts for the LXR Drag system.

## Files

- **main.lua** - Core client-side drag functionality
  - Command registration (`/drag`)
  - Player detection and targeting
  - Animation playback and synchronization
  - Drag state management
  - Self-release key handler
  - Server event handlers

## Architecture

The client handles:
- User input and commands
- Visual representation (animations)
- Position synchronization when being dragged
- Local validation before server requests
- Notification display

All critical logic and validation happens server-side for security.

---

**🐺 wolves.land - The Land of Wolves**
