# homebrew-photoprune

Homebrew tap for [PhotoPrune](https://github.com/YashBhalodi/PhotoPrune) — a local, offline CLI for finding near-duplicate photos.

## Install

```bash
brew tap YashBhalodi/photoprune
brew install photoprune
```

The formula brings in Python and the full ML stack (PyTorch, faiss, CLIP, etc.) into a sandboxed install — you don't need Python on your system. First install downloads ~880 MB of dependencies and takes a few minutes.

The explicit equivalent without tapping is `brew install YashBhalodi/photoprune/photoprune`.

## Usage

```bash
cd ~/Pictures/My-Trip
photoprune
```

See the [main repo](https://github.com/YashBhalodi/PhotoPrune) for full documentation, screenshots, and `--help` output.

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

## License

[MIT](https://github.com/YashBhalodi/PhotoPrune/blob/main/LICENSE) — same as PhotoPrune itself.
