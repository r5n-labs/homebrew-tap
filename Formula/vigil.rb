class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.7.5"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.5/vigil-darwin-arm64.tar.gz"
      sha256 "309b3ade39c196b836bd2e560779426f1d66a2d9446de15654a4ee93a22a4448"
    else
      url "https://releases.r5n.dev/vigil/v0.7.5/vigil-darwin-x64.tar.gz"
      sha256 "828d9de8f2770d758d5690882902d854f73d8ad6ef0c4a99ccbc4ec9f0256438"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.5/vigil-linux-arm64.tar.gz"
      sha256 "e545a8253cd7b3c367c898c3e53b3b617919dd7a8a01bc500c6790acae4bb59c"
    else
      url "https://releases.r5n.dev/vigil/v0.7.5/vigil-linux-x64.tar.gz"
      sha256 "e4410ced3bdb94a2d957b2ef9431c3eb7fad8d858d76fe00c5d3591b56f9d1b7"
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
