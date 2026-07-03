class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.7.11"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.11/vigil-darwin-arm64.tar.gz"
      sha256 "57f0e25db52c11ce268875f3b94c594381d10305d4448b17581b68d70cb8e17c"
    else
      url "https://releases.r5n.dev/vigil/v0.7.11/vigil-darwin-x64.tar.gz"
      sha256 "c0540b901f17de42b704e764800430dd6aca495ebe4d4b932e5c1c572f72c76c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.11/vigil-linux-arm64.tar.gz"
      sha256 "41c65a2201596a22206261f8c63bdb38d336c6c21aa2d538a696f999afa8a762"
    else
      url "https://releases.r5n.dev/vigil/v0.7.11/vigil-linux-x64.tar.gz"
      sha256 "bd58d0402ce555cb084681f819da8b83b0cca411441d8c22432d3a5be57ab64f"
    end
  end

  def install
    # The archive's sole top-level entry is bin/, which Homebrew strips when
    # staging (it descends into a single root dir), so the binary stages as
    # ./vigil — NOT ./bin/vigil, so installing the "bin/vigil" path ENOENTs.
    bin.install "vigil"
  end

  test do
    assert_match "vigil #{version}", shell_output("#{bin}/vigil --version")
  end
end
