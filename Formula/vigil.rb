class Vigil < Formula
  desc "Self-custody crypto wallet for the terminal"
  homepage "https://vigil.r5n.dev"
  version "0.15.0"
  license "FSL-1.1-ALv2"

  depends_on "minisign" => :build

  # Preserve the release app through Homebrew's post-install cleaner too.
  skip_clean "bin/VigilTouchID.app"

  on_macos do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.15.0/vigil-darwin-arm64.tar.gz", using: :nounzip
      sha256 "b7e12bfa958d173d1690802b832c55cf309a7dec552bd36687ef5d0b8a668714"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.15.0/vigil-darwin-arm64.tar.gz.minisig", using: :nounzip
        sha256 "1c527f17fc504fa1ed7c59151c43c3a40f4477cac758bdbc86491420f1238df4"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.15.0/vigil-darwin-x64.tar.gz", using: :nounzip
      sha256 "cd59d660e2d44a0d93b60bce49883a8b96502da5727ebb2149be78bb76939142"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.15.0/vigil-darwin-x64.tar.gz.minisig", using: :nounzip
        sha256 "b7ebf6a774c739038330057aa5cfe041a874c5ae44a16d034228e05ff87590a5"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://releases.r5n.dev/vigil/v0.15.0/vigil-linux-arm64.tar.gz", using: :nounzip
      sha256 "a64ee6721b863776c1d4c0346b43accbcd0336af11fdd902f00aa733f438d821"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.15.0/vigil-linux-arm64.tar.gz.minisig", using: :nounzip
        sha256 "79d246ea532ecef734b33023a0ae37320d4caaa6492d3d9eff49ce136aefa945"
      end
    else
      url "https://releases.r5n.dev/vigil/v0.15.0/vigil-linux-x64.tar.gz", using: :nounzip
      sha256 "339d39fcbf2dca4454892cc54d487fbd857c94400b7c1a7dee81c88a11ddf34c"

      resource "release-signature" do
        url "https://releases.r5n.dev/vigil/v0.15.0/vigil-linux-x64.tar.gz.minisig", using: :nounzip
        sha256 "957a6a4da42acd8511d32c36c299f1cfbf33b72349513fda6328739e34ced70a"
      end
    end
  end

  def install
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    archive = buildpath/"vigil-#{platform}.tar.gz"
    # The release keys install.sh pins: a signature by any one of them
    # verifies, and minisign refuses a key whose id the signature does not name.
    release_keys = %w[
      RWS2NEa30Rmk0m4rvEJRhcel7J/TZhybn4Zof9yM3HGHqdpDR8c7sm+g
    ]
    # Homebrew checks both fixed SHA-256 pins before staging. nounzip keeps
    # the archive intact until its signature has also been verified.
    resource("release-signature").stage do
      verified = release_keys.any? do |key|
        quiet_system Formula["minisign"].opt_bin/"minisign", "-Vm", archive,
                     "-x", "vigil-#{platform}.tar.gz.minisig", "-P", key
      end
      odie "vigil-#{platform}.tar.gz is not signed by a pinned Vigil release key" unless verified
    end
    # Refuse links, special entries, escaping/duplicate paths and writable
    # metadata before tar can materialise any archive member.
    names = IO.popen(["tar", "-tzf", archive.to_s], &:read).lines.map(&:chomp).map { |name| name.sub(%r{/$}, "") }
    odie "unsafe release archive paths" unless $?.success? && names.length.between?(1, 4096) &&
      names.uniq.length == names.length && names.all? { |name|
        name.match?(%r{\A[A-Za-z0-9_+./-]+\z}) && !name.start_with?("/") &&
          name.split("/", -1).none? { |part| ["", ".", ".."].include?(part) }
      }
    entries = IO.popen(["tar", "-tvzf", archive.to_s], &:read).lines
    odie "unsafe release archive metadata" unless $?.success? && entries.length == names.length && entries.all? { |line|
      mode = line[0, 10]
      mode.match?(%r{\A[-d][rwx-]{9}\z}) && mode[5] != "w" && mode[8] != "w"
    }
    system "tar", "-xzpf", archive

    safe_entry = lambda do |path|
      stat = File.lstat(path)
      odie "unsafe installation entry: #{path}" unless (stat.file? || stat.directory?) &&
        [0, Process.uid].include?(stat.uid) && (stat.mode & 07022).zero? &&
        (!stat.file? || stat.nlink == 1)
    end
    safe_directory_path = lambda do |path, boundary = nil|
      path = Pathname.new(File.expand_path(path))
      boundary = Pathname.new(File.expand_path(boundary)) unless boundary.nil?
      odie "installation path outside Cellar prefix" unless boundary.nil? || path.ascend.include?(boundary)
      # Homebrew owns the Cellar ancestry, which may deliberately be writable by
      # its admin group. Our strict custody begins at this version's prefix.
      starts = boundary.nil? ? [path, path.exist? ? path.realpath : path] : [path]
      starts.each do |start|
        cursor = start
        loop do
          if cursor.symlink?
            odie "symlinked installation directory: #{cursor}" unless
              ["/var", "/tmp", "/etc"].include?(cursor.to_s) && cursor.lstat.uid.zero?
          elsif cursor.exist?
            stat = cursor.lstat
            odie "unsafe installation directory: #{cursor}" unless stat.directory? &&
              [0, Process.uid].include?(stat.uid) && ((stat.mode & 022).zero? ||
                (cursor != start && stat.uid.zero? && (stat.mode & 01000) != 0))
          end
          break if cursor.root? || cursor == boundary
          cursor = cursor.parent
        end
      end
    end
    safe_directory_path.call(buildpath/"bin")
    safe_directory_path.call(bin, prefix)
    safe_directory_path.call(pkgshare, prefix)
    %w[bin/vigil bin/vigil-api LICENSE RELEASE-IDENTITY.json].each do |path|
      safe_entry.call(path)
      odie "release member is not a regular file: #{path}" unless File.file?(path)
    end
    require "find"
    odie "release notices are not a directory" unless File.directory?("THIRD-PARTY-NOTICES")
    Find.find("THIRD-PARTY-NOTICES") { |path| safe_entry.call(path) }
    bundle = "bin/VigilTouchID.app"
    raw = "bin/vigil-touchid"
    if File.exist?(bundle)
      odie "conflicting Touch ID helper layouts" if File.exist?(raw)
      odie "Touch ID bundle is only supported on macOS" unless OS.mac?
      count = 0
      Find.find(bundle) do |path|
        count += 1
        odie "Touch ID bundle is too large" if count > 32
        safe_entry.call(path)
      end
      %w[Contents/Info.plist Contents/embedded.provisionprofile Contents/MacOS/vigil-touchid].each do |name|
        odie "Touch ID bundle is incomplete" unless File.file?("#{bundle}/#{name}") && File.size?("#{bundle}/#{name}")
      end
      odie "Touch ID helper is not executable" unless File.executable?("#{bundle}/Contents/MacOS/vigil-touchid")
    elsif File.exist?(raw)
      safe_entry.call(raw)
      odie "raw Touch ID helper is not a file" unless File.file?(raw)
    end
    # Homebrew owns the fresh versioned Cellar prefix and its upgrade rollback.
    # Refuse pre-existing targets; never write through an entry from another layout.
    [bin/"vigil", bin/"vigil-api", bin/"vigil-touchid", bin/"VigilTouchID.app",
     pkgshare/"LICENSE", pkgshare/"RELEASE-IDENTITY.json", pkgshare/"THIRD-PARTY-NOTICES"].each do |path|
      odie "installation target already exists: #{path}" if path.exist? || path.symlink?
    end
    bin.install "bin/vigil"
    bin.install "bin/vigil-api"
    if File.exist?(bundle)
      # Move the complete signed app next to the real Cellar executable. Do not
      # re-sign, flatten or chmod its resources or embedded provisioning profile.
      bin.install "bin/VigilTouchID.app"
    elsif File.exist?(raw)
      bin.install "bin/vigil-touchid"
    end
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
