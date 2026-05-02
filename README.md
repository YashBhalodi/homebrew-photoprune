# homebrew-photoprune

Homebrew tap for [PhotoPrune](https://github.com/YashBhalodi/PhotoPrune) — a local, offline CLI for finding near-duplicate photos.

## Install

```bash
brew install YashBhalodi/photoprune/photoprune
```

This pulls in Python and all of PhotoPrune's heavy dependencies (PyTorch, faiss, CLIP, etc.) into an isolated install. The first install downloads ~700 MB of dependencies and may take a few minutes; subsequent updates are quick.

## Usage

```bash
cd ~/Pictures/My-Trip
photoprune
```

See the [main repo](https://github.com/YashBhalodi/PhotoPrune) for full documentation.

## Updating

```bash
brew update
brew upgrade photoprune
```

## Uninstall

```bash
brew uninstall photoprune
brew untap YashBhalodi/photoprune
```
