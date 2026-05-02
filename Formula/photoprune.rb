class Photoprune < Formula
  desc "Find near-duplicate photos in a directory using CLIP embeddings"
  homepage "https://github.com/YashBhalodi/PhotoPrune"
  url "https://github.com/YashBhalodi/PhotoPrune/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5a44bbc626f15ef5597eb65fe178c00cd42fb648f12272b0e842e80d95c8b49c"
  license "MIT"

  depends_on "python@3.11"

  def install
    # Create a plain venv (with pip bootstrapped). Brew's virtualenv_create
    # uses --without-pip and expects every transitive dep as a `resource`
    # block; we'd need ~70 of those for torch alone. Letting pip resolve
    # deps from PyPI at install time is fine for a custom tap.
    ENV.delete("PYTHONPATH")
    python = Formula["python@3.11"].opt_bin/"python3.12"
    system python, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--no-cache-dir", "--upgrade", "pip"
    # The [heic] extra adds pillow-heif so iPhone HEIC files work out of the box.
    system libexec/"bin/pip", "install", "--no-cache-dir", "#{buildpath}[heic]"
    bin.install_symlink libexec/"bin/photoprune"
    bin.install_symlink libexec/"bin/photodedupe"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/photoprune --version")
    # Exercise the CLI on an empty dir — should run without crashing.
    (testpath/"empty").mkpath
    output = shell_output("#{bin}/photoprune --no-open --no-wait #{testpath}/empty")
    assert_match "No supported image files found", output
  end
end
