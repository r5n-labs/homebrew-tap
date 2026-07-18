class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.7.13"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.13/vigil-darwin-arm64.tar.gz"
      sha256 "d3a396ababf7c710ac6b97825af69f856eba64fb46fb08b309c78cfd92ecc55e"
    else
      url "https://releases.r5n.dev/vigil/v0.7.13/vigil-darwin-x64.tar.gz"
      sha256 "fdac0351995d5d226be3ac483c5242976087a0d3aff79587756f64ab82dbe966"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.13/vigil-linux-arm64.tar.gz"
      sha256 "aed37075940538aaef4f190cef5c14260954babe06c9f2b4dac3063b777dc7b4"
    else
      url "https://releases.r5n.dev/vigil/v0.7.13/vigil-linux-x64.tar.gz"
      sha256 "07572a7dcdeb1afed474557c558850917fdc552fa6eeb62674042e2c857f5841"
    end
  end

  def install
    # The archive's sole top-level entry is bin/, which Homebrew strips when
    # staging (it descends into a single root dir), so the binary stages as
    # ./vigil — NOT ./bin/vigil, so installing the "bin/vigil" path ENOENTs.
    bin.install "vigil"
    # darwin tarballs ship the Touch ID helper as a SIBLING of vigil, and the
    # runtime resolves it via dirname(process.execPath) — installing only
    # "vigil" silently ships brew installs WITHOUT biometric unlock. Linux
    # tarballs have no helper, hence the existence guard.
    bin.install "vigil-touchid" if File.exist?("vigil-touchid")
  end

  test do
    assert_match "vigil #{version}", shell_output("#{bin}/vigil --version")
  end
end
