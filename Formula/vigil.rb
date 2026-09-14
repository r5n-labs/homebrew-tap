class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.11.6"
  license "FSL-1.1-ALv2"

  depends_on "minisign" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.6/vigil-darwin-arm64.tar.gz", using: :nounzip
      sha256 "24d666307b0d76616049c8524db1f618dac5b4fc673f335fb496d94392db487e"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.6/vigil-darwin-arm64.tar.gz.minisig", using: :nounzip
        sha256 "858599a18e5dd0901bc6188420db2fce25a0ed0a9dbea6a93682e1847e7767b4"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.11.6/vigil-darwin-x64.tar.gz", using: :nounzip
      sha256 "a7c58b4c145d8c04ab2a4c1512347179dae859f74bdcb81f0d78652cf8738584"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.6/vigil-darwin-x64.tar.gz.minisig", using: :nounzip
        sha256 "f8d24fda8e6bb6d7a127c92615d9b61498106bdbbea5e96f11b8abb02bd7bf8a"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.6/vigil-linux-arm64.tar.gz", using: :nounzip
      sha256 "fc33c20f65b4d2f913662124c2a366d56589703b6bee317c1b05541a0b2da06d"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.6/vigil-linux-arm64.tar.gz.minisig", using: :nounzip
        sha256 "c959552cb399d3da496124249f2032d5a703edcf95b5c78168e9dfa1293a3814"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.11.6/vigil-linux-x64.tar.gz", using: :nounzip
      sha256 "466db37752b4ce703964a9d197aadbef7bb2fa30f7208415045e380456813ae1"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.6/vigil-linux-x64.tar.gz.minisig", using: :nounzip
        sha256 "b2319fec39ed8dd381d9477fa16016e59847e7f0a91dc5a1467511a73e24709a"
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
