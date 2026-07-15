# MinUI for TrimUI Smart Pro

A focused build of [MinUI](https://github.com/shauninman/MinUI) targeting the **TrimUI Smart Pro** and **TrimUI Brick** (tg5040 platform). Automatically built from source via GitHub Actions.

<img src="github/minui-main.png" width=320 /> <img src="github/minui-menu-gbc.png" width=320 />

## Features

- Simple launcher, simple SD card
- No settings or configuration
- No boxart, themes, or distractions
- Automatically hides hidden files
  and extension and region/version
  cruft in display names
- Consistent in-emulator menu with
  quick access to save states, disc
  changing, and emulator options
- Automatically sleeps after 30 seconds
  or press POWER to sleep (and wake)
- Automatically powers off while asleep
  after two minutes or hold POWER for
  one second
- Automatically resumes right where
  you left off if powered off while
  in-game, manually or while asleep
- Resume from manually created, last
  used save state by pressing X in
  the launcher instead of A
- Streamlined emulator frontend
  (minarch + libretro cores)
- Optional per-system gameplay overlays

### Gameplay overlays

Place transparent PNG overlays in `/Overlays/<TAG>/` on the SD card, where
`<TAG>` is the emulator tag used by the ROM folder (for example, `/Overlays/GB/`
or `/Overlays/GBA/`). For best results, use the device's native resolution:
1024x768 for Brick and 1280x720 for Smart Pro.

Launch a game, then select **Options > Frontend > Overlay** to choose one.
The selection can be saved for the console or only for the current game using
MinUI's existing **Save Changes** menu.

## What's different from upstream MinUI

This fork focuses exclusively on the tg5040 platform (TrimUI Smart Pro / Brick) with:

- **CI/CD pipeline** -- Automated builds via GitHub Actions. Push tags to create releases.
- **Dual-platform builds** -- Both trimuismart (Model S) and tg5040 (TSP/Brick) build in parallel from source.
- **FBNeo support** -- Final Burn Neo core cross-compiled from source for arcade emulation.
- **Gameplay overlays** -- Transparent PNG overlays for in-game HUD elements (minarch.elf compiled with `HAS_GAME_OVERLAYS=1`).
- **Pico-8 support** -- fake-08 core cross-compiled with tg5040 platform target.
- **Fresh binaries** -- All tg5040 cores, minarch.elf, and minui.elf rebuilt from source on every release.

## Why not NextUI?

[NextUI](https://github.com/LoveRetro/NextUI) is an active community fork of MinUI for TrimUI Brick and Smart Pro with a rebuilt emulation engine, GPU rendering, shaders, WiFi support, RetroAchievements, and many more features. If you're looking for a feature-rich experience, check it out.

This fork intentionally keeps it minimal. We want to stay close to upstream MinUI's philosophy: fast boots, no distractions, everything just works. NextUI already exists for users who want the full feature set. This fork is for users who specifically want the stock MinUI experience -- simple, reliable, and focused -- with CI/CD builds and TSP-specific fixes on top.

## Supported consoles

Base:

- Game Boy
- Game Boy Color
- Game Boy Advance
- Nintendo Entertainment System
- Super Nintendo Entertainment System
- Sega Genesis
- PlayStation

Extras:

- Final Burn Neo (arcade)
- Neo Geo Pocket (and Color)
- Pico-8
- Pokemon mini
- Sega Game Gear
- Sega Master System
- Super Game Boy
- TurboGrafx-16 (and TurboGrafx-CD)
- Virtual Boy

## Supported Devices

| Device           | Status |
| ---------------- | ------ |
| TrimUI Smart Pro | Active |
| TrimUI Brick     | Active |

## Installation

1. Download the latest `*-base.zip` from [Releases](https://github.com/jellydn/MinUITSP/releases)
2. Extract and copy `MinUI.zip` to your SD card root
3. Power on your device -- MinUI will install automatically

### Updating

Copy the new base zip to your SD card and power on. MinUI will update in place.

### Extras

Download the extras zip for additional emulators and tools not included in the base install.

## Building from source

### Prerequisites

- Docker (for toolchain builds)
- GNU make
- Git with submodules

### Quick build (single platform)

```bash
git clone --recursive https://github.com/jellydn/MinUITSP.git
cd MinUITSP
make PLATFORM=trimuismart
```

### CI/CD

The GitHub Actions workflow builds toolchains and cores for each platform automatically. Trigger manually from the Actions tab or push a tag to create a release.

## Credits

MinUI was created by [shauninman](https://github.com/shauninman/MinUI). This fork adds CI/CD automation and TSP-specific improvements on top of the excellent upstream work.

> Devices with a physical power switch
> use MENU to sleep and wake instead of
> POWER. Once asleep the device can safely
> be powered off manually with the switch.
