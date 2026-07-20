class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.7.14"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.14/vigil-darwin-arm64.tar.gz"
      sha256 "53c4013886083411d4aa73cb5f39a4b0323583700051c1e5b46c50b1953b7759"
    else
      url "https://releases.r5n.dev/vigil/v0.7.14/vigil-darwin-x64.tar.gz"
      sha256 "88ee1dd7596e4d364c93b108ddbc7e07c7b34a795086036db3b2fdffc0749002"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.14/vigil-linux-arm64.tar.gz"
      sha256 "1b0d9d4b7b4e4b31bde8d6082360d2588c77cd0bb73826a1cb245197368b6782"
    else
      url "https://releases.r5n.dev/vigil/v0.7.14/vigil-linux-x64.tar.gz"
      sha256 "d9d6c19453db0dbc3961d37db00e44d86d6507a2cad3cfe57c7b0cfb5e97c162"
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
