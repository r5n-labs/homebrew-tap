class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.7.4"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.4/vigil-darwin-arm64.tar.gz"
      sha256 "1880e3a2a4314635938233a506cca3f241cd2457e4b4c28a39c6040e1aaf012d"
    else
      url "https://releases.r5n.dev/vigil/v0.7.4/vigil-darwin-x64.tar.gz"
      sha256 "bfd2d2af8fe0933ecb30d8f11daccdebb990ec8c126fccc1f28b3ee998f1f1a3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.4/vigil-linux-arm64.tar.gz"
      sha256 "6dd4177a8ccb585cba5b214fa29b4685fe7f33bbf51be67b4e66d252d8b0c15c"
    else
      url "https://releases.r5n.dev/vigil/v0.7.4/vigil-linux-x64.tar.gz"
      sha256 "cde5d9d864110bae3f2a9674352699df7a3809e8144eedd27962885393129554"
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
