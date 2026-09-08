class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.11.1"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.1/vigil-darwin-arm64.tar.gz"
      sha256 "109bec29994f58f4c0360bf0f8d74f4982ec26d27f57e6f12c732a24cf0a662b"
    else
      url "https://releases.r5n.dev/vigil/v0.11.1/vigil-darwin-x64.tar.gz"
      sha256 "95eb02c2b29532c1d1aa20784c4eea3a732bec9d87b077246194bd95f6550caf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.1/vigil-linux-arm64.tar.gz"
      sha256 "6891b11f13566233ac6cc4dd9ed4225fadc568c15ecc3395105314a21f9b53f0"
    else
      url "https://releases.r5n.dev/vigil/v0.11.1/vigil-linux-x64.tar.gz"
      sha256 "38dc736abde169788fdbb98a49186dc028dc97342fe4322da78ed41b09084ca6"
    end
  end

  def install
    bin.install "bin/vigil"
    bin.install "bin/vigil-api"
    # darwin tarballs ship the Touch ID helper as a SIBLING of vigil, and the
    # runtime resolves it via dirname(process.execPath) — installing only
    # "vigil" silently ships brew installs WITHOUT biometric unlock. Linux
    # tarballs have no helper, hence the existence guard.
    bin.install "bin/vigil-touchid" if File.exist?("bin/vigil-touchid")
    pkgshare.install "LICENSE"
    pkgshare.install "RELEASE-IDENTITY.json"
    pkgshare.install "THIRD-PARTY-NOTICES"
  end

  service do
    run [opt_bin/"vigil-api"]
    keep_alive true
    log_path var/"log/vigil-api.log"
    error_log_path var/"log/vigil-api.log"
  end

  test do
    assert_match "vigil #{version}", shell_output("#{bin}/vigil --version")
    assert_match "vigil-api #{version}", shell_output("#{bin}/vigil-api --version")
  end
end
