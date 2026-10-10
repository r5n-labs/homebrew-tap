class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.12.0"
  license "FSL-1.1-ALv2"

  depends_on "minisign" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.12.0/vigil-darwin-arm64.tar.gz", using: :nounzip
      sha256 "486accf0c6323241925a1bda76f5b28e718eb0279e6ce02a7589c8d2c753b9bf"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.12.0/vigil-darwin-arm64.tar.gz.minisig", using: :nounzip
        sha256 "e34317964def64defe32b1b80b9c30cd8b6ae42b536c749391b79492ce19b6bb"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.12.0/vigil-darwin-x64.tar.gz", using: :nounzip
      sha256 "b092d4e1200c43fcc35f6b55db916afab41af03513d1c9dabcf4e7115f2a44e3"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.12.0/vigil-darwin-x64.tar.gz.minisig", using: :nounzip
        sha256 "0d55cbcc16b1c14e9d34ef64f3efe2b09d18a8a95be9d9e5d447f35c700efa3f"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.12.0/vigil-linux-arm64.tar.gz", using: :nounzip
      sha256 "1389b34745eaa24722061f55b542d89481fde448d4f47eb785692591a3f5c314"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.12.0/vigil-linux-arm64.tar.gz.minisig", using: :nounzip
        sha256 "44f8ff633db3ee320c41fc19ee74504c8fdd8860c784872bb30d0c4615bb5670"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.12.0/vigil-linux-x64.tar.gz", using: :nounzip
      sha256 "c05d7cfc2386b1fe70c47ffa994f601912790cbf2f04b0dc59d9a3b009b95e99"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.12.0/vigil-linux-x64.tar.gz.minisig", using: :nounzip
        sha256 "c6725646777c63d5700357d329124e270d00b7525c8fad0ce19925c732763a9b"
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
