class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.11.0"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.0/vigil-darwin-arm64.tar.gz"
      sha256 "cc9bbdb1fcbce106c54a3fd773542356311f2958a4b131670b54c0e7445aa999"
    else
      url "https://releases.r5n.dev/vigil/v0.11.0/vigil-darwin-x64.tar.gz"
      sha256 "ab6d76c7f602214ab5427d1133e0c4e855ec66a74c3274192996813362e91acc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.0/vigil-linux-arm64.tar.gz"
      sha256 "8eb3c4bfc1a53acd4de0a45c9483cce4d96a988be4f0ad99f7d14fabbaf88a05"
    else
      url "https://releases.r5n.dev/vigil/v0.11.0/vigil-linux-x64.tar.gz"
      sha256 "2cccf5b45a34bd26f424fc09f021593c77390519155c8f56dcba1f1ca149f5da"
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
