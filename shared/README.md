# 🐺 Shared Scripts

This folder contains scripts loaded on both client and server.

## Files

- **framework.lua** - Multi-framework adapter/bridge
  - Framework auto-detection
  - Unified adapter functions
  - Per-framework implementations
  - Notification system
  - Player data functions
  - Permission checks

## Architecture

The framework adapter provides a unified interface that works across all supported frameworks. Core gameplay logic calls unified functions like `Framework.Notify()` instead of framework-specific calls.

This enables:
- Single codebase for all frameworks
- Easy framework switching
- Consistent behavior across servers
- Simplified maintenance

---

**🐺 wolves.land - The Land of Wolves**
