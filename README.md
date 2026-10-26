# Keshav's Homebrew tap

Homebrew packages for [SpeedSentry](https://github.com/keshavbhardwaz/speedsentry), a native macOS menu bar download-speed monitor.

## Install SpeedSentry

```sh
brew install keshavbhardwaz/tap/speedsentry
speedsentry
```

The formula compiles the app locally using Swift 5.9+ from Apple's current Command Line Tools or Xcode. The app requires macOS 13 or later; Homebrew has separate [supported-platform requirements](https://docs.brew.sh/Installation). No Developer ID certificate is needed for a local source build.

SpeedSentry checks every 10 minutes by default, alerts below 20 Mbps, and retains local incident history with India Standard Time timestamps. Accurate mode starts with 8 MiB and confirms fast results with a separate 64 MiB download. This uses at most 72 MiB/check, about 10.9 GB/day while continuously awake. Enable **Low Data Mode** for one 8 MiB sample per check (about 1.2 GB/day), with less protection against short bursts. This is a short throughput estimate to Cloudflare. Very slow or failed requests are recorded as unavailable, and brief drops between checks can be missed.

## Update and remove

Disable **Launch at Login** and quit SpeedSentry before upgrading or removing it. After an upgrade, run `speedsentry` again and re-enable login launch if desired.

```sh
brew update
brew upgrade keshavbhardwaz/tap/speedsentry
brew uninstall keshavbhardwaz/tap/speedsentry
```

Uninstalling retains history in `~/Library/Application Support/SpeedSentry/` and the app's preferences. Export history from the app before deliberately deleting it. This source formula does not use cask `--zap`.

The app stays in Homebrew's Cellar; the `speedsentry` command opens it through Homebrew's stable `opt` path. Allow SpeedSentry in macOS notification settings to receive alerts.

## Maintainer

Generate `Formula/speedsentry.rb` only after the corresponding source tag exists, using the checksum of that exact archive. The project's [release guide](https://github.com/keshavbhardwaz/speedsentry/blob/main/docs/RELEASING.md) documents generation, verification, and future signed cask distribution.

MIT licensed. See [LICENSE](LICENSE).
