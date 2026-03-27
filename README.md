# homebrew-tap

Homebrew tap for [pelagos](https://github.com/pelagos-containers/pelagos) container runtime tools.

## Install

```bash
brew tap pelagos-containers/tap
brew install pelagos-containers/tap/pelagos-mac
brew install --cask pelagos-containers/tap/pelagos-ui
```

## Packages

| Package | Type | Description |
|---|---|---|
| `pelagos-mac` | formula | macOS CLI + VM image. Installs `pelagos`, `pelagos-docker`, `pelagos-tui` |
| `pelagos-ui` | cask | Desktop GUI app (`pelagos-ui.app` → `/Applications`) |

## Status

> **Note:** GitHub release artifacts are not yet available. Formula and cask URLs are placeholders.
> Install from source in the meantime — see the individual repo READMEs.
> Tracked in [issue #1](https://github.com/pelagos-containers/homebrew-tap/issues/1).

## Development / local install

Both repos include a `scripts/build-release.sh` that builds local artifacts and
writes a `dist/` formula or cask with `file://` URLs for testing:

```bash
# pelagos-mac
cd ~/Projects/pelagos-mac
bash scripts/build-release.sh
HOMEBREW_DEVELOPER=1 brew reinstall dist/Formula/pelagos-mac.rb

# pelagos-ui
cd ~/Projects/pelagos-ui
bash scripts/build-release.sh
HOMEBREW_DEVELOPER=1 brew reinstall --cask dist/Casks/pelagos-ui.rb
```
