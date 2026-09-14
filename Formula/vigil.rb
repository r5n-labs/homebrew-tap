class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.11.2"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.2/vigil-darwin-arm64.tar.gz"
      sha256 "295329fe220c90f7343eb68a1b90c78fadc23c1c88245028b9eb6decfd324196"
    else
      url "https://releases.r5n.dev/vigil/v0.11.2/vigil-darwin-x64.tar.gz"
      sha256 "b6f2bf09ab65886228d808dbc645cf7610b8c649832400f7594828608eced33a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.2/vigil-linux-arm64.tar.gz"
      sha256 "3fabddadf01e1abd927380786cd461c4999d60da441ff5fd2005168b3f5bd1fc"
    else
      url "https://releases.r5n.dev/vigil/v0.11.2/vigil-linux-x64.tar.gz"
      sha256 "914fcab4ba069cb866681588451965d79a34d8b0612e0e1d28e9094c0f365bf9"
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
