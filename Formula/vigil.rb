class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.7.6"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.6/vigil-darwin-arm64.tar.gz"
      sha256 "a0479c1fdccfcd0e114894906060c8816e1c7fe26962ccc9a0fe446c50b6b24d"
    else
      url "https://releases.r5n.dev/vigil/v0.7.6/vigil-darwin-x64.tar.gz"
      sha256 "a6f7cc90d134a6d8ae8b06bd8e2f18e3be25e8907de3996c9107ac01b10ac555"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.6/vigil-linux-arm64.tar.gz"
      sha256 "251d70ee28fe88de4dd2de3145ef702fe3f522bad5937cc67f0c64c8796b60d2"
    else
      url "https://releases.r5n.dev/vigil/v0.7.6/vigil-linux-x64.tar.gz"
      sha256 "74f9c2cdf61427653fe0369c5a8bff04c615ff20a6b9e3fc0ccd5d77d3bb4002"
    end
  end

  def install
    # The archive's sole top-level entry is bin/, which Homebrew strips when
    # staging (it descends into a single root dir), so the binary stages as
    # ./vigil — NOT ./bin/vigil, so installing the "bin/vigil" path ENOENTs.
    bin.install "vigil"
  end

  test do
    assert_match "vigil #{version}", shell_output("#{bin}/vigil --version")
  end
end
