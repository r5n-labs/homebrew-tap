class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.8.0"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.8.0/vigil-darwin-arm64.tar.gz"
      sha256 "2bb221feb61a7a527f155569c0a581da984fca0e3dde1fbf130e981072dc316d"
    else
      url "https://releases.r5n.dev/vigil/v0.8.0/vigil-darwin-x64.tar.gz"
      sha256 "e095df79dfa8666665acac96b9b0fb5e3973289bfd2c417f1a0b0373f877e9b1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.8.0/vigil-linux-arm64.tar.gz"
      sha256 "9a77d129dc415a6b71f8b654e790977d8b190d65bce832d9567709a919cc3f36"
    else
      url "https://releases.r5n.dev/vigil/v0.8.0/vigil-linux-x64.tar.gz"
      sha256 "51aa60de1781d524ff65335e4c9a8ad4f20c1d676b592344cfe3cac56987bcf4"
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
