class Photoprune < Formula
  desc "Find near-duplicate photos in a directory using CLIP embeddings"
  homepage "https://github.com/YashBhalodi/PhotoPrune"
  url "https://github.com/YashBhalodi/PhotoPrune/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "1375da0fbfb1a6b80a3d0d10f6f8c53d0a171d301e965d8051c4903b9f1a4858"
  license "MIT"

  depends_on "python@3.11"

  def caveats
    <<~EOS
      Model weights (CLIP ~340 MB, MobileNetV2 ~14 MB) download on first run
      into:
        #{libexec}/.cache/photoprune

      `brew uninstall photoprune` removes everything above (~880 MB total)
      cleanly. Per-album review reports / embedding caches / `_trash/`
      folders under `<album>/.photoprune/` are NOT touched — that's your
      data. See the project README for how to clean those up too.
    EOS
  end

  # Skip brew's post-install Mach-O processing for our venv. Brew rewrites
  # adhoc-signed dylibs in installed prefixes, which breaks torch's
  # operator registration ("operator torchvision::nms does not exist").
  skip_clean "libexec"

  def install
    # Create a plain venv (with pip bootstrapped). Brew's virtualenv_create
    # uses --without-pip and expects every transitive dep as a `resource`
    # block; we'd need ~70 of those for torch alone. Letting pip resolve
    # deps from PyPI at install time is fine for a custom tap.
    ENV.delete("PYTHONPATH")
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system python, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--no-cache-dir", "--upgrade", "pip"
    # The [heic] extra adds pillow-heif so iPhone HEIC files work out of the box.
    system libexec/"bin/pip", "install", "--no-cache-dir", "#{buildpath}[heic]"
    bin.install_symlink libexec/"bin/photoprune"
    bin.install_symlink libexec/"bin/photodedupe"
  end

  def post_install
    # Belt-and-suspenders: reinstall torch + torchvision fresh after brew's
    # install-time binary processing has finished, so their adhoc-signed
    # Mach-O bundles are pristine.
    system libexec/"bin/pip", "install", "--no-cache-dir",
           "--force-reinstall", "--no-deps",
           "torch==2.11.0", "torchvision==0.26.0"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/photoprune --version")
    # Exercise the CLI on an empty dir — should run without crashing.
    (testpath/"empty").mkpath
    output = shell_output("#{bin}/photoprune --no-open --no-wait #{testpath}/empty")
    assert_match "No supported image files found", output
  end
end
