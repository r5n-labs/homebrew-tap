class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.10.9"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.10.9/vigil-darwin-arm64.tar.gz"
      sha256 "3ecafd5dd12e5ffb93ead4be03b8cb411198e22ea6adfd81066b874c542a0a38"
    else
      url "https://releases.r5n.dev/vigil/v0.10.9/vigil-darwin-x64.tar.gz"
      sha256 "02f6a228cd9b00d9f8b39824271dbedc61f482b062ab16f4e61037bf22265731"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.10.9/vigil-linux-arm64.tar.gz"
      sha256 "7767c29ce68ea22f9bfe0eb19e26e4c530bfda2f6c8bac4718fff6c62f5bcfb2"
    else
      url "https://releases.r5n.dev/vigil/v0.10.9/vigil-linux-x64.tar.gz"
      sha256 "ca71bc4199c4b993446e005e4f1f2fc031a66aed52a56ba6d7a4d32e932154ca"
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
