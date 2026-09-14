class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.11.3"
  revision 1
  license "FSL-1.1-ALv2"

  depends_on "minisign" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.3/vigil-darwin-arm64.tar.gz", using: :nounzip
      sha256 "0b65dfcf6d445c463cc8ff969e8f8f65e438b95862ff40f8677bfa9072400d4c"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.3/vigil-darwin-arm64.tar.gz.minisig", using: :nounzip
        sha256 "752849ed8823191b3b8b0acb51d5253a376c97cd4de40c6a60539c0b21b6bad0"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.11.3/vigil-darwin-x64.tar.gz", using: :nounzip
      sha256 "809a758da64212b962a95589fbdf86316798343e49e73f5c43024c23cfb0969b"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.3/vigil-darwin-x64.tar.gz.minisig", using: :nounzip
        sha256 "cfb3aa0d86369408b1fbbbb0d559796c295b5ec1a4b6ee2f785f0abb419f34e2"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.3/vigil-linux-arm64.tar.gz", using: :nounzip
      sha256 "15d69dcff4e7e08a5a38dbc28e35c7f39e872859f2de89032d60f4578c99586f"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.3/vigil-linux-arm64.tar.gz.minisig", using: :nounzip
        sha256 "c272fd59bb53b337952fe34ef54362b3c7783ee8b60e7702e6db50a067761088"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.11.3/vigil-linux-x64.tar.gz", using: :nounzip
      sha256 "aa433692bbf30cc26e77ad6292f1a1750541999ea7c990feef20bbf6f864f39a"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.3/vigil-linux-x64.tar.gz.minisig", using: :nounzip
        sha256 "5b2448c261572980110d07356149722edc5cc3a3fe9ee09a710d7db888121301"
      end
    end
  end

  def install
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    archive = buildpath/"vigil-#{platform}.tar.gz"
    # Homebrew checks both fixed SHA-256 pins before staging. nounzip keeps
    # the archive intact until its signature has also been verified.
    resource("release-signature").stage do
      system Formula["minisign"].opt_bin/"minisign", "-Vm", archive,
             "-x", "vigil-#{platform}.tar.gz.minisig", "-P", "RWS2NEa30Rmk0m4rvEJRhcel7J/TZhybn4Zof9yM3HGHqdpDR8c7sm+g"
    end
    system "tar", "-xzf", archive

    bin.install "bin/vigil"
    bin.install "bin/vigil-api"
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
