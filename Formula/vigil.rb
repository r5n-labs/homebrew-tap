class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.10.8"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.10.8/vigil-darwin-arm64.tar.gz"
      sha256 "0e6f121a512f4ece600534fa55d3274a14ed01f80b95c03073b25839ec3698c8"
    else
      url "https://releases.r5n.dev/vigil/v0.10.8/vigil-darwin-x64.tar.gz"
      sha256 "b0d26ebeb1238130b702e31942443405a377c3c0a36c56edcf4b762183d54333"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.10.8/vigil-linux-arm64.tar.gz"
      sha256 "d6f4486d0b1ba1d946d63f2b476ce1cbacdaa4f44cbe2189b0a1d004722f084e"
    else
      url "https://releases.r5n.dev/vigil/v0.10.8/vigil-linux-x64.tar.gz"
      sha256 "91d8ce8bb35b15e8c3dc8e6d9ff0a1c714356efd7442b997514afb8dd3df9325"
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
