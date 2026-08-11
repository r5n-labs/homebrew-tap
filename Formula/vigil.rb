class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.9.0"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.9.0/vigil-darwin-arm64.tar.gz"
      sha256 "dc29a4918d457fe342d1ce84438b82d6a89b154a22e632ee91ff43a2e6ecda26"
    else
      url "https://releases.r5n.dev/vigil/v0.9.0/vigil-darwin-x64.tar.gz"
      sha256 "ebe4fcc55c61d278ea87b7c9bfd79a3f4a0195255501acb1439c5500d783964b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.9.0/vigil-linux-arm64.tar.gz"
      sha256 "b4ee792eb2cd58ae1a939bd410b4c4a1ff8028dd660aa63005fb740abc030b68"
    else
      url "https://releases.r5n.dev/vigil/v0.9.0/vigil-linux-x64.tar.gz"
      sha256 "281a9f7c573fea4832f2df5b614d86479f51ce03ae814ca482876dc2b5bc584d"
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
