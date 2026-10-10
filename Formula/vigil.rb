class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.12.1"
  license "FSL-1.1-ALv2"

  depends_on "minisign" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.12.1/vigil-darwin-arm64.tar.gz", using: :nounzip
      sha256 "357d6a83044727beb9508e6b4e56afcfc5e405a4abf1e61c51ec05df1d282a1c"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.12.1/vigil-darwin-arm64.tar.gz.minisig", using: :nounzip
        sha256 "8529498bd8d684120d28c266c8556f7678b1d7a63d48d5a53638be79478dba79"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.12.1/vigil-darwin-x64.tar.gz", using: :nounzip
      sha256 "2d8d729c6de332cfff12d7627b46694df1935c195efd42a71c28a3883eba8869"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.12.1/vigil-darwin-x64.tar.gz.minisig", using: :nounzip
        sha256 "f2d6c1ff57197a56249a94b5fde2213ae745e6f51b13322712a963ecf0d650f1"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.12.1/vigil-linux-arm64.tar.gz", using: :nounzip
      sha256 "e247a90c6960a47e97c9ec49cedbec4407e43703350fe0b8a317462795aa8efe"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.12.1/vigil-linux-arm64.tar.gz.minisig", using: :nounzip
        sha256 "c7076d57a94bdd94a6f9a5f5d24917acbf072e3fa0750121bc81a63a193cf418"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.12.1/vigil-linux-x64.tar.gz", using: :nounzip
      sha256 "32e4d59c550704dc8107f6094af7b3f1e2badcbff586d667e6bde930ada96ded"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.12.1/vigil-linux-x64.tar.gz.minisig", using: :nounzip
        sha256 "a7fd80a491a03301d3fb9555cee00ae4b9cb712bb920b1cdfdc1822b3bd5b2fa"
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
