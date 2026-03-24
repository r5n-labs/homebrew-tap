class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://github.com/r5n-labs/vigil"
  version "0.1.0"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/r5n-labs/vigil/releases/download/v#{version}/vigil-darwin-arm64.zip"
      sha256 "cd9a08687795b2f9a0ddd42a399ffc0b368f6aaf5dc85ef7f5f229b259856825"
    else
      url "https://github.com/r5n-labs/vigil/releases/download/v#{version}/vigil-darwin-x64.zip"
      sha256 "454f162cfbaea15e3b08143267e4eb5df55db5df3de5a21d0d738b38fdcdaa67"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/r5n-labs/vigil/releases/download/v#{version}/vigil-linux-arm64.tar.gz"
      sha256 "2bc71b89339aa79e3d90c46b3732a4e851fdcf86bc4ddb24e84d3da522330d37"
    else
      url "https://github.com/r5n-labs/vigil/releases/download/v#{version}/vigil-linux-x64.tar.gz"
      sha256 "ffdab458b374d2c551ebd1a6cf64d2bd2f3614f133fb54597f87d4e74ac2c233"
    end
  end

  def install
    bin.install "vigil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vigil --version", 1)
  end
end
