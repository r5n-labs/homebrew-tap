class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.7.3"
  license "FSL-1.1-ALv2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.3/vigil-darwin-arm64.tar.gz"
      sha256 "543d23be0fda49a54445a63f81c187009667f25dc89f762bc9d98e69a307fe52"
    else
      url "https://releases.r5n.dev/vigil/v0.7.3/vigil-darwin-x64.tar.gz"
      sha256 "d61e3c83108d6eea65722edbe15c68aa86de50b8aceba640e766db2c1109fb2b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.7.3/vigil-linux-arm64.tar.gz"
      sha256 "9ed0d7efcee2c053681ee02ada6fa39a485e7b1b6ad1483c85b1e35afb8cadd4"
    else
      url "https://releases.r5n.dev/vigil/v0.7.3/vigil-linux-x64.tar.gz"
      sha256 "b9ebc8b4e77873864cf78580a464e1832e88a5929850d15dcf8ce7f6122886fc"
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
