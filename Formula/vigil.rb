class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.10.10"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.10.10/vigil-darwin-arm64.tar.gz"
      sha256 "7e8fac75366cb3ce8b07710791f77c49c344fe9e1410c71ed161d20656bc714b"
    else
      url "https://releases.r5n.dev/vigil/v0.10.10/vigil-darwin-x64.tar.gz"
      sha256 "9de8bb2e430321c6a8d8374ce476af20446bbca056ef3bcfc216e688ab80615f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.10.10/vigil-linux-arm64.tar.gz"
      sha256 "14b983327f6e641ede44b907c7b9424f947abf2b3af66ee3547beb70fc2664f7"
    else
      url "https://releases.r5n.dev/vigil/v0.10.10/vigil-linux-x64.tar.gz"
      sha256 "7c094a517ced6db351bda8b8dd76a84cca5f24c0a3acf4e95c7be45c933dc192"
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
