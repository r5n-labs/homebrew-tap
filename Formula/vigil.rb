class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.7.2"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.2/vigil-darwin-arm64.tar.gz"
      sha256 "351e3d46f2eeb02d96f18de9aee8ab31cf65d22abf3401a103b3d62dc1fa21da"
    else
      url "https://releases.r5n.dev/vigil/v0.7.2/vigil-darwin-x64.tar.gz"
      sha256 "ef0c2e91535608acee08b18ef6de15922d9ca0c816cc8df8a6fb6a077378cda2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.2/vigil-linux-arm64.tar.gz"
      sha256 "e55ee0c511fe8ad5a841bc8dd2a2a6b24e4ae41ef24b8b6e0f58459538ddc9f3"
    else
      url "https://releases.r5n.dev/vigil/v0.7.2/vigil-linux-x64.tar.gz"
      sha256 "93ba5e9bece4f7b72f5e0a118da42cab2a624ea50b03bf09a3a809ec42c66ac0"
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
