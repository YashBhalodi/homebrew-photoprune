class Photoprune < Formula
  include Language::Python::Virtualenv

  desc "Find near-duplicate photos in a directory using CLIP embeddings"
  homepage "https://github.com/YashBhalodi/PhotoPrune"
  url "https://github.com/YashBhalodi/PhotoPrune/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5a44bbc626f15ef5597eb65fe178c00cd42fb648f12272b0e842e80d95c8b49c"
  license "MIT"

  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    # Single pip install pulls down the package plus all transitive deps
    # (torch, faiss-cpu, open-clip-torch, etc.) from PyPI. The `[heic]`
    # extra adds pillow-heif so iPhone HEIC files work out of the box.
    venv.pip_install_and_link "#{buildpath}[heic]"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/photoprune --version")
    # Exercise the CLI on an empty dir — should run without crashing.
    (testpath/"empty").mkpath
    output = shell_output("#{bin}/photoprune --no-open --no-wait #{testpath}/empty")
    assert_match "No supported image files found", output
  end
end
