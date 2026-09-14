class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.11.4"
  license "FSL-1.1-ALv2"

  depends_on "minisign" => :build

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.4/vigil-darwin-arm64.tar.gz", using: :nounzip
      sha256 "e1009bc4f7bb9be5e2e4902fb82306d7ef7ed1f3fb000e6760615a3e0b049735"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.4/vigil-darwin-arm64.tar.gz.minisig", using: :nounzip
        sha256 "4e8012ce861d7f08922b6300430931e6d5495f1c9b89af38f55af3d1510185a1"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.11.4/vigil-darwin-x64.tar.gz", using: :nounzip
      sha256 "bb8777c4965c1b86e9d1d9fed8dfe072b1e0a8fc82e9fdecbae3fff1b691c89e"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.4/vigil-darwin-x64.tar.gz.minisig", using: :nounzip
        sha256 "e5a26b46324688354383f4d79582d17f84c8595e02e6f1e387623dfa30422d0b"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.11.4/vigil-linux-arm64.tar.gz", using: :nounzip
      sha256 "859566fad9b6832d23add41732b744fb12156fc0b3c1429f1638af5b08527909"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.4/vigil-linux-arm64.tar.gz.minisig", using: :nounzip
        sha256 "e75c39eb500866e19adf6de3f1f2a22a91d09541b4df9627e86c76ccdcbf3a7d"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.11.4/vigil-linux-x64.tar.gz", using: :nounzip
      sha256 "eb98390de8b1b69ccc4f72d074fd03534be2ec2de97e8e033af03993979ea935"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.11.4/vigil-linux-x64.tar.gz.minisig", using: :nounzip
        sha256 "e49ad0dc3fda469274acb7b181a57fce622d929f6b050f1814df86b6dbac9f12"
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
