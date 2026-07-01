class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.7.1"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.1/vigil-darwin-arm64.tar.gz"
      sha256 "bb398fa0d2745d0d1f15bbc297ce3fa08a0edbfe0806aa46e2268adbbf73dc1a"
    else
      url "https://releases.r5n.dev/vigil/v0.7.1/vigil-darwin-x64.tar.gz"
      sha256 "0496519a1db533a8c1fb3084294f644fcdb3d578d24b2287f256cb11a6ce9896"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.1/vigil-linux-arm64.tar.gz"
      sha256 "74ea334b071ff966de030396adc570f9aa17483fed12ea998946d973611de619"
    else
      url "https://releases.r5n.dev/vigil/v0.7.1/vigil-linux-x64.tar.gz"
      sha256 "eeae7167281d0942a3694a94ec3ffd944b48591b7d4c6bb2b5eee7b02561e1fb"
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
