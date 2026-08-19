class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.10.1"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.10.1/vigil-darwin-arm64.tar.gz"
      sha256 "09f37f63af5598f9fa2d9b40db494ecf756dd44c4ca1f702e931aeb27c1bf0cf"
    else
      url "https://releases.r5n.dev/vigil/v0.10.1/vigil-darwin-x64.tar.gz"
      sha256 "fe202ab6cc0130db918ff99fa2d1d273c47c62d2fb572b4014ba036064d7b113"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.10.1/vigil-linux-arm64.tar.gz"
      sha256 "15baa64f98143e350e2af195135550d5603d44dcf44812736010671d743f19e9"
    else
      url "https://releases.r5n.dev/vigil/v0.10.1/vigil-linux-x64.tar.gz"
      sha256 "6ea4cf6f565375bc87a7f61f40e498405b74a6b33cc223308a6e212ba1078cd3"
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
