class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.11.3"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.3/vigil-darwin-arm64.tar.gz"
      sha256 "0b65dfcf6d445c463cc8ff969e8f8f65e438b95862ff40f8677bfa9072400d4c"
    else
      url "https://releases.r5n.dev/vigil/v0.11.3/vigil-darwin-x64.tar.gz"
      sha256 "809a758da64212b962a95589fbdf86316798343e49e73f5c43024c23cfb0969b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.3/vigil-linux-arm64.tar.gz"
      sha256 "15d69dcff4e7e08a5a38dbc28e35c7f39e872859f2de89032d60f4578c99586f"
    else
      url "https://releases.r5n.dev/vigil/v0.11.3/vigil-linux-x64.tar.gz"
      sha256 "aa433692bbf30cc26e77ad6292f1a1750541999ea7c990feef20bbf6f864f39a"
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
