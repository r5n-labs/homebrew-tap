class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.10.1"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.10.1/vigil-darwin-arm64.tar.gz"
      sha256 "221f0ca96fcca2597c78dfa70bd4d05748121cecfa0942568a5edf4dd43c1023"
    else
      url "https://releases.r5n.dev/vigil/v0.10.1/vigil-darwin-x64.tar.gz"
      sha256 "82a33c94eb4a8f61b3d666cb8139628a630e54341b00730a6405b8dc44947c3b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.10.1/vigil-linux-arm64.tar.gz"
      sha256 "b5a378f2978b4db3f87668dac5053b3b20f0803a86f5eb58fd52a5d411f7fa04"
    else
      url "https://releases.r5n.dev/vigil/v0.10.1/vigil-linux-x64.tar.gz"
      sha256 "18f6997dcbb0a7af8583e7ee38337833aea88827245665bd688e606e28c7410d"
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
