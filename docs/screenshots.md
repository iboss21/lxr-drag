```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
```

# 🐺 LXR Drag - Screenshots Requirements

**Version:** 1.0.0  
**Author:** iBoss21 / The Lux Empire

---

## Purpose

This document outlines the required screenshots for documenting LXR Drag functionality. These screenshots serve as:

1. **Visual documentation** - Show features in action
2. **Quality assurance** - Verify proper installation
3. **Troubleshooting** - Compare against known-good state
4. **Marketing** - Showcase the resource

---

## Screenshot Storage

All screenshots should be stored in:

```
/docs/assets/screenshots/
```

**File naming convention:**
```
01_screenshot_name.png
02_another_screenshot.png
...
```

**Format:** PNG (lossless) or JPG (high quality)

**Resolution:** 1920x1080 minimum (Full HD)

---

## Required Screenshots

### 1. Startup Console Banner

**Filename:** `01_startup_console.png`

**What to capture:**
- Full ASCII art banner in server console
- Version number
- Framework detection
- All startup information

**How to capture:**
1. Start server fresh
2. Wait for resource to load
3. Screenshot server console showing full banner
4. Include timestamps if visible

**Should show:**
```
═══════════════════════════════════════════════
🐺 DRAG SYSTEM - SUCCESSFULLY LOADED
═══════════════════════════════════════════════
Version:     1.0.0
Server:      The Land of Wolves 🐺
Framework:   [detected framework]
...
```

**Purpose:** Verify resource loads correctly

---

### 2. Config File Sections

**Filename:** `02_config_sections.png`

**What to capture:**
- Open config.lua in editor
- Show branded header
- Show section banners with █████ formatting
- Show configuration structure

**How to capture:**
1. Open config.lua in code editor (VS Code recommended)
2. Scroll to show header and first few sections
3. Ensure branding is visible
4. Screenshot showing file structure

**Should show:**
- ASCII header at top
- Section banners (████████)
- Clean formatting
- Comments and structure

**Purpose:** Document configuration style and branding

---

### 3. In-Game Drag Interaction

**Filename:** `03_drag_interaction.png`

**What to capture:**
- Two players in-game
- One player dragging another
- Both players visible
- Drag animations active

**How to capture:**
1. Have two players join server
2. Use `/drag` command near another player
3. Capture moment during drag
4. Show both players in frame

**Should show:**
- Dragger player with attack animation
- Victim player with victim animation
- Close proximity
- Clear view of both characters

**Purpose:** Showcase main functionality

---

### 4. Framework Detection

**Filename:** `04_framework_detection.png`

**What to capture:**
- Server console or F8 client console
- Debug messages showing framework detection
- Framework adapter initialization

**How to capture:**
1. Enable debug mode: `Config.Debug = true`
2. Restart resource
3. Screenshot console output
4. Include framework detection message

**Should show:**
```
[LXR-Drag] Framework detected: lxr-core
[LXR-Drag] Framework Adapter Initialized | Active Framework: lxr-core
```

**Purpose:** Verify multi-framework support

---

### 5. Notifications System

**Filename:** `05_notifications.png`

**What to capture:**
- In-game notification shown to player
- Drag start/stop notification
- Clear notification text

**How to capture:**
1. Join server
2. Use `/drag` command
3. Capture notification popup
4. Try different notification types if possible

**Should show:**
- Notification UI element
- Text like "You are now dragging a player"
- Framework-specific notification style
- Clear and readable

**Purpose:** Show notification integration

---

### 6. txAdmin Performance

**Filename:** `06_txadmin_performance.png`

**What to capture:**
- txAdmin performance dashboard
- Script timing showing lxr-drag
- Performance metrics during drag

**How to capture:**
1. Access txAdmin interface
2. Go to Server → Performance
3. Have player(s) using drag
4. Screenshot performance view

**Should show:**
- lxr-drag in script list
- Low script time (green)
- Performance graphs
- Other metrics

**Purpose:** Document performance impact

---

### 7. Permission Denied (Optional)

**Filename:** `07_permission_denied.png`

**What to capture:**
- Player without permission trying to drag
- Error notification
- Permission check in action

**How to capture:**
1. Enable permissions in config
2. Join as player without permission
3. Try `/drag` command
4. Capture error notification

**Should show:**
- Error notification: "You do not have permission..."
- Player unable to drag
- Clear error message

**Purpose:** Document permission system

---

### 8. Self-Release Feature (Optional)

**Filename:** `08_self_release.png`

**What to capture:**
- Help text on screen: "Press X to break free"
- Player being dragged
- UI prompt visible

**How to capture:**
1. Be dragged by another player
2. Look for on-screen prompt
3. Capture moment showing prompt
4. Include player in frame

**Should show:**
- On-screen text
- Key prompt
- Player being dragged
- Clear instructions

**Purpose:** Show self-release feature

---

### 9. Debug Mode (Optional)

**Filename:** `09_debug_mode.png`

**What to capture:**
- F8 console with debug prints
- Debug messages during drag
- Detailed logging

**How to capture:**
1. Enable debug: `Config.Debug = true`
2. Use drag functionality
3. Open F8 console
4. Screenshot debug output

**Should show:**
```
[LXR-Drag Client] Started dragging player 5
[LXR-Drag Client] Playing enter animation for dragger
[LXR-Drag Client] Animation dictionary preloaded
```

**Purpose:** Document debug capabilities

---

### 10. Distance Validation (Optional)

**Filename:** `10_distance_validation.png`

**What to capture:**
- Error notification: "Player is too far away"
- Two players at distance
- Failed drag attempt

**How to capture:**
1. Stand far from another player
2. Try `/drag` command
3. Capture error message
4. Include both players in frame if possible

**Should show:**
- Error notification
- Clear distance between players
- Validation working

**Purpose:** Show security validation

---

## Screenshot Checklist

### Mandatory Screenshots

- [ ] 01_startup_console.png
- [ ] 02_config_sections.png
- [ ] 03_drag_interaction.png
- [ ] 04_framework_detection.png
- [ ] 06_txadmin_performance.png

### Optional Screenshots

- [ ] 05_notifications.png
- [ ] 07_permission_denied.png
- [ ] 08_self_release.png
- [ ] 09_debug_mode.png
- [ ] 10_distance_validation.png

---

## Screenshot Guidelines

### Quality Standards

**Resolution:**
- Minimum: 1920x1080 (Full HD)
- Recommended: 2560x1440 (2K)
- Format: PNG for UI, JPG for in-game

**Content:**
- Clear and in focus
- Good lighting (for in-game shots)
- No unnecessary UI clutter
- Relevant information visible
- No inappropriate content

**Framing:**
- Subject centered or well-composed
- Include context but avoid distractions
- Crop to relevant area
- No black bars or letterboxing

---

### In-Game Screenshot Settings

**Recommended Graphics Settings:**
- Resolution: 1920x1080 or higher
- Quality: High/Ultra
- Anti-aliasing: On
- HUD: Visible but minimal

**Camera:**
- Clear view of action
- Good angle showing both players
- Appropriate distance
- Stable (not during camera shake)

---

### Console Screenshot Tips

**For Windows:**
- Use Snipping Tool or Snip & Sketch
- Capture full window or relevant portion
- Save as PNG

**For Linux:**
- Use built-in screenshot tool
- Or: `gnome-screenshot` / `scrot`
- Save as PNG

**Ensure:**
- Text is readable
- No personal information visible
- Timestamps included
- Full relevant output captured

---

## Usage of Screenshots

### Documentation

Include in:
- README.md (showcase)
- Installation guide (verification)
- Troubleshooting guides (comparison)

### Marketing

Use for:
- Store listings (tebex)
- Forum posts
- Discord announcements
- GitHub releases

### Support

Helpful for:
- Bug reports (show issue)
- Feature requests (show context)
- Installation help (verify setup)
- Comparison (working vs broken)

---

## Copyright & Attribution

**All screenshots should:**
- Be original (taken by you)
- Not contain copyrighted content (except the resource itself)
- Include server name if showing Land of Wolves
- Be appropriate for public display

**Screenshot Credits:**
```
Screenshots © 2026 iBoss21 / The Lux Empire
Resource: LXR Drag v1.0.0
Server: The Land of Wolves (wolves.land)
```

---

## Submission

**If contributing screenshots:**

1. Name files correctly (01_name.png)
2. Place in `/docs/assets/screenshots/`
3. Verify quality and content
4. Create pull request or send to maintainer
5. Include brief description

**Checklist before submission:**
- [ ] Files named correctly
- [ ] Quality meets standards
- [ ] Content is appropriate
- [ ] No personal info visible
- [ ] All required shots included

---

## Example Screenshot Package

**Minimal Package (5 screenshots):**
```
/docs/assets/screenshots/
├── 01_startup_console.png
├── 02_config_sections.png
├── 03_drag_interaction.png
├── 04_framework_detection.png
└── 06_txadmin_performance.png
```

**Complete Package (10 screenshots):**
```
/docs/assets/screenshots/
├── 01_startup_console.png
├── 02_config_sections.png
├── 03_drag_interaction.png
├── 04_framework_detection.png
├── 05_notifications.png
├── 06_txadmin_performance.png
├── 07_permission_denied.png
├── 08_self_release.png
├── 09_debug_mode.png
└── 10_distance_validation.png
```

---

## Next Steps

- Capture all mandatory screenshots
- Review quality and content
- Store in correct location
- Reference in documentation
- Update as resource evolves

---

## Support

Need help with screenshots?

- Discord: https://discord.gg/CrKcWdfd3A
- GitHub: https://github.com/iboss21/lxr-drag/issues

---

**🐺 wolves.land - The Land of Wolves**  
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
