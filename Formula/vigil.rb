class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.7.10"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.10/vigil-darwin-arm64.tar.gz"
      sha256 "b832cc8b4145323fd4ee7c55ca49caf5f3ef9b2fcdb4756ea03d41a7c5979e18"
    else
      url "https://releases.r5n.dev/vigil/v0.7.10/vigil-darwin-x64.tar.gz"
      sha256 "f9418a56a9be5deceb851714f78df66f7a7e84d7bfd8517c39c3adb063e0782e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.10/vigil-linux-arm64.tar.gz"
      sha256 "d23eb1a6fb53e6e2b869354f78c64409699f728b219c96fa92847043a3b4a4c2"
    else
      url "https://releases.r5n.dev/vigil/v0.7.10/vigil-linux-x64.tar.gz"
      sha256 "eebcfca637969e71dbe862361e9c6d70076f79556d8a7838dd1b03a06ba135a2"
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
