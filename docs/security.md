```
    ██╗     ██╗  ██╗██████╗        ██████╗ ██████╗  █████╗  ██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔══██╗██╔══██╗██╔════╝ 
    ██║      ╚███╔╝ ██████╔╝█████╗██║  ██║██████╔╝███████║██║  ███╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║  ██║██╔══██╗██╔══██║██║   ██║
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝██║  ██║██║  ██║╚██████╔╝
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
```

# 🐺 LXR Drag - Security Guide

**Version:** 1.0.0  
**Author:** iBoss21 / The Lux Empire

---

## Security Philosophy

**LXR Drag is built with a "server authority" security model:**

- **Never trust the client** - All critical validation happens server-side
- **Validate everything** - Distance, permissions, states, rates
- **Log suspicious activity** - Track potential exploits
- **Fail securely** - Deny on error, don't assume

---

## Security Features

### 1. Server-Side Validation

**All drag requests are validated by the server before execution.**

#### Distance Validation

**Problem:** Client could claim to be near a player when they're not.

**Solution:**
```lua
-- Server-side validation
local distance = GetDistance(source, target)
if distance > Config.Security.maxDragDistance then
    -- Deny request
    return
end
```

**Configuration:**
```lua
Config.Security.maxDragDistance = 5.0  -- Server enforces max distance
```

#### Player State Validation

**Problem:** Client could try to drag invalid targets.

**Solution:**
```lua
-- Server validates:
- Target player exists
- Target not already being dragged
- Source not already dragging someone
- Players are in valid states
```

---

### 2. Rate Limiting

**Prevents players from spamming drag commands.**

#### Per-Player Rate Limit

**Configuration:**
```lua
Config.Security.maxDragsPerMinute = 10  -- Max 10 drag attempts per minute
```

**Implementation:**
```lua
-- Server tracks attempts per player
dragAttempts[source] = {
    attempts = {timestamp1, timestamp2, ...},
    lastAttempt = os.time()
}

-- Remove attempts older than 60 seconds
-- Check if current attempts < max allowed
```

**Security Benefit:**
- Prevents exploit spam
- Reduces server load from abuse
- Makes griefing less effective

---

### 3. Anti-Spam Protection

**Prevents rapid command toggling.**

#### Command Cooldown

**Configuration:**
```lua
Config.Security.antiSpam = true
Config.Security.spamDelay = 2000  -- 2 second cooldown
```

**Implementation:**
```lua
-- Client-side
local lastDragTime = 0

RegisterCommand('drag', function()
    local currentTime = GetGameTimer()
    if (currentTime - lastDragTime) < Config.Security.spamDelay then
        Framework.Notify('Please wait', 'error')
        return
    end
    lastDragTime = currentTime
    -- Continue...
end)
```

---

### 4. Permission System

**Controls who can use drag.**

#### ACE Permissions

**Configuration:**
```lua
Config.Permissions.enabled = true
Config.Permissions.acePermission = 'drag.use'
```

**Server.cfg:**
```cfg
# Admin can drag
add_ace group.admin drag.use allow

# Police can drag
add_ace group.police drag.use allow

# Specific player can drag
add_ace identifier.license:abc123 drag.use allow
```

**Security Benefit:**
- Fine-grained access control
- Easy management via server.cfg
- No code changes needed

#### Job-Based Permissions

**Configuration:**
```lua
Config.Permissions.enabled = true
Config.Permissions.jobs = {'police', 'sheriff', 'medic'}
Config.Permissions.grades = {
    police = 2,   -- Rank 2+ only
    sheriff = 1,
    medic = 0     -- Any rank
}
```

**Security Benefit:**
- Roleplay-appropriate restrictions
- Grade-based access
- Framework-integrated

---

### 5. Suspicious Activity Logging

**Tracks potential exploits.**

#### What Gets Logged

1. **Rate limit violations**
```
[LXR-Drag SECURITY] Player 3 exceeded max drag attempts (10/min)
```

2. **Suspicious distances**
```
[LXR-Drag SECURITY] Suspicious distance detected: 3 dragging 5 (15.23m)
```

3. **Invalid state transitions**
```
[LXR-Drag Server] Invalid drag attempt from 3: already_dragging
```

**Configuration:**
```lua
Config.Security.logSuspiciousActivity = true  -- Enable logging
```

**Logging Locations:**
- Server console (real-time)
- Server log files (txAdmin)

---

### 6. Distance Monitoring

**Continuous monitoring during drag.**

#### Automatic Disconnect Detection

**Problem:** If dragger disconnects or teleports far away, victim should be released.

**Solution:**
```lua
-- Server monitors distance every 5 seconds
CreateThread(function()
    while true do
        Wait(5000)
        for dragger, state in pairs(dragStates) do
            if state.dragging then
                local distance = GetDistance(dragger, state.dragging)
                if distance > (Config.Security.maxDragDistance * 3) then
                    -- Suspicious distance, force stop
                    StopDrag(dragger)
                end
            end
        end
    end
end)
```

**Threshold:** 3x normal drag distance to account for lag.

---

### 7. State Management

**Prevents invalid states.**

#### Server Authority

**The server is the source of truth for drag states:**

```lua
dragStates = {
    [playerId] = {
        dragging = targetId,     -- Who this player is dragging
        draggedBy = draggerId    -- Who is dragging this player
    }
}
```

**Security Benefits:**
- Client cannot fake drag state
- Server validates all state changes
- Prevents duplication exploits

#### State Cleanup

**Automatic cleanup on:**
- Player disconnect
- Resource stop
- Drag end
- Invalid state detection

```lua
AddEventHandler('playerDropped', function()
    local source = source
    if IsDragging(source) then
        StopDrag(source)
    end
    dragStates[source] = nil
    dragAttempts[source] = nil
end)
```

---

## Threat Model

### Potential Threats

#### 1. Distance Spoofing

**Attack:** Client claims to be near target when far away.

**Mitigation:**
- ✅ Server-side distance check
- ✅ Continuous distance monitoring
- ✅ Auto-disconnect on suspicious distance

#### 2. Command Spam

**Attack:** Rapidly spam `/drag` to cause lag or grief.

**Mitigation:**
- ✅ Client-side cooldown
- ✅ Server-side rate limiting
- ✅ Activity logging

#### 3. Permission Bypass

**Attack:** Try to drag without permission.

**Mitigation:**
- ✅ Server-side permission check
- ✅ ACE integration
- ✅ Job/grade validation

#### 4. State Manipulation

**Attack:** Try to drag multiple people or be in invalid state.

**Mitigation:**
- ✅ Server maintains authoritative state
- ✅ State validation before changes
- ✅ Automatic state cleanup

#### 5. Resource Exhaustion

**Attack:** Create many drag attempts to overload server.

**Mitigation:**
- ✅ Per-player rate limiting
- ✅ Efficient state management
- ✅ Periodic cleanup thread

---

## Security Best Practices

### For Server Administrators

#### 1. Enable All Security Features

```lua
Config.Security.enabled = true
Config.Security.validatePlayerExists = true
Config.Security.antiSpam = true
Config.Security.logSuspiciousActivity = true
```

**Don't disable security for "convenience".**

#### 2. Set Appropriate Rate Limits

**Server Type Recommendations:**

**Serious RP:**
```lua
Config.Security.maxDragsPerMinute = 5
Config.Security.spamDelay = 3000  -- 3 seconds
```

**Casual RP:**
```lua
Config.Security.maxDragsPerMinute = 10
Config.Security.spamDelay = 2000  -- 2 seconds
```

**Action/PvP:**
```lua
Config.Security.maxDragsPerMinute = 15
Config.Security.spamDelay = 1000  -- 1 second
```

#### 3. Use Permissions

**For public servers:**
```lua
Config.Permissions.enabled = true
Config.Permissions.jobs = {'police', 'sheriff', 'medic'}
```

**For whitelisted/private servers:**
```lua
Config.Permissions.enabled = false  -- Trust your community
```

#### 4. Monitor Logs

**Check server console regularly for:**
- Rate limit violations
- Suspicious distances
- Permission denials
- Pattern of abuse from specific players

#### 5. Keep Distance Validation Strict

```lua
Config.Security.maxDragDistance = 5.0  -- Strict
-- Not 50.0 or 100.0 -- Too lenient
```

**Rule of thumb:** `maxDragDistance = dragDistance + 2.0`

---

### For Developers

#### 1. Always Use Adapter Functions

**Bad:**
```lua
-- Direct framework call
TriggerEvent('vorp:NotifyLeft', ...)
```

**Good:**
```lua
-- Unified adapter
Framework.Notify(...)
```

**Why:** Adapter handles validation and routing.

#### 2. Validate Before Server Events

**Bad:**
```lua
-- Send any player
TriggerServerEvent('lxr-drag:server:startDrag', somePlayer)
```

**Good:**
```lua
-- Validate first
if not targetPlayer then return end
if distance > Config.General.dragDistance then return end
if targetPlayer == localPlayer then return end

TriggerServerEvent('lxr-drag:server:startDrag', targetPlayer)
```

#### 3. Don't Trust Client Events

**All server handlers should validate:**

```lua
RegisterNetEvent('lxr-drag:server:startDrag', function(target)
    local source = source
    
    -- Always validate
    if not target then return end
    if source == target then return end
    
    local valid, error = ValidateDragStart(source, target)
    if not valid then
        return
    end
    
    -- Continue...
end)
```

---

## Incident Response

### Detecting Exploits

**Signs of exploit attempts:**
1. Multiple "suspicious distance" logs
2. Rate limit violations from same player
3. Permission denied logs (unauthorized access attempts)
4. Invalid state transition errors

### Response Actions

**1. Investigate:**
```
Check server console for player ID
Review timing and frequency
Check if multiple players involved
```

**2. Document:**
```
Screenshot logs
Note player identifiers
Record timestamps
```

**3. Action:**
```lua
-- Temporary: Kick player
DropPlayer(source, 'Exploit detected')

-- Permanent: Ban via framework/ACE
add_principal identifier.license:abc123 group.banned
```

**4. Fix:**
```lua
-- Adjust rate limits if needed
Config.Security.maxDragsPerMinute = 5  -- Lower

-- Enable stricter logging
Config.Security.logSuspiciousActivity = true
Config.Debug = true
```

---

## Security Checklist

### Pre-Production

- [ ] `Config.Security.enabled = true`
- [ ] `Config.Security.maxDragDistance` set appropriately
- [ ] `Config.Security.maxDragsPerMinute` set for server type
- [ ] `Config.Security.antiSpam = true`
- [ ] Permissions configured (if needed)
- [ ] Tested with multiple players
- [ ] Verified distance validation works
- [ ] Verified rate limiting works
- [ ] Reviewed logs for anomalies

### Post-Production

- [ ] Monitor logs regularly
- [ ] Check for suspicious activity patterns
- [ ] Update rate limits based on usage
- [ ] Review permission settings
- [ ] Test after updates
- [ ] Document incidents
- [ ] Keep resource updated

---

## Known Vulnerabilities

**None currently documented.**

If you discover a security issue:
1. **Do NOT** publicly disclose
2. Contact: GitHub Security Advisory or Discord DM
3. Provide detailed reproduction steps
4. We will credit you in fix notes (if desired)

---

## Next Steps

- [Performance Guide](performance.md) - Optimize without compromising security
- [Configuration Guide](configuration.md) - Tune security settings
- [Events Guide](events.md) - Understand event flow

---

**🐺 wolves.land - The Land of Wolves**  
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
