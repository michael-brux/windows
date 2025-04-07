# VBScript disabled

If you're encountering errors related to VBScript on newer Windows systems, you're maybe experiencing the effects of its deprecation. Starting with Windows 11 24H2, VBScript has become an optional "Feature on Demand," meaning it's disabled by default. This document serves as a guide to understanding this change, identifying common error messages associated with a disabled VBScript engine, and providing clear instructions on how to check its status and re-enable it if needed.

**VBScript Deprecation:** Microsoft is phasing out VBScript due to security concerns and the availability of more modern scripting languages like PowerShell and JavaScript.

**Feature on Demand (FoD):** Starting with Windows 11 version 24H2 (and potentially present in earlier optional updates or insider builds), VBScript is no longer enabled by default. It has become an optional "Feature on Demand" (FoD).

**Disabled by Default:** This means on newer installations or systems that have received specific updates aligning with this deprecation schedule, the VBScript engine is intentionally **disabled**, even if the `vbscript.dll` file might technically exist as part of the FoD package.

## Error Messages

Possible errors you encountered:

- **"No script engine for file extension '.vbs'":** Because the VBScript FoD is disabled/inactive.
- **`regsvr32` "failed to load" / "does not exist":** Because even if the DLL is present in the FoD package, it's not active or registered for use until the feature is enabled.
- **`.wsf` error "language attribute not valid":** Because the system couldn't recognize "VBScript" as a valid, *enabled* language engine.

## Check for VBScript Feature

```powershell
Get-WindowsCapability -online | Where-Object { $_.Name -like '*VBSCRIPT*' }
```

Should return "State: Installed" when VBScript is enabled. Returns "State : NotPresent" when VBScript is missing.

## How to Enable VBScript

In Settings search for Add optional feature and in block Add an optional feature push "View features" and search for "VBSCRIPT".

When enabled VBSCRIPT should be listed under Added features.

To enable via Command Line:

```bat
DISM /Online /Add-Capability /CapabilityName:VBSCRIPT~~~~
```

Or with Powershell:

```powershell
Get-WindowsCapability -online | Where-Object { $_.Name -like '*VBSCRIPT*' } | add-WindowsCapability -online
```

# References

https://techcommunity.microsoft.com/blog/windows-itpro-blog/vbscript-deprecation-timelines-and-next-steps/4148301  

https://answers.microsoft.com/en-us/windows/forum/all/windows-11-24h2-vbscript-disabled-and-is-cauing/eceb6a27-dcf4-446a-8c12-67b84b7bb7b0

[PENDING - VBScript deprecation in W11 24H2, enable using SCCM | SCCM | Intune | Windows 365 | Windows 11 Forums](https://forums.prajwaldesai.com/threads/vbscript-deprecation-in-w11-24h2-enable-using-sccm.7250/) 