class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v4.4.2.tar.gz"
  sha256 "7b2171ff891e5b0dbd459bce8c15659d5f4d203bbbca5150102c12de4480e144"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git"

  livecheck do
    url "https://github.com/gravitational/teleport/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9d436ad28e7a297de3ac86653a8ec7a64e97ad8a0f77818ed42c6e888c40ec90" => :catalina
    sha256 "88fb0cfa9eeb4a6984392efcbad5632d68a367cde99478363158fc23d46e2000" => :mojave
    sha256 "36e285dd1623bf3238cb4efe456eea87054c47131ee8e2067c10c8e733332542" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "zip"

  on_linux do
    depends_on "netcat" => :test
  end

  conflicts_with "etsh", because: "both install `tsh` binaries"

  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/72412062d6d55ec7faa9707abf500d703e7d09da.tar.gz"
    sha256 "c84767bea0a723f406e3b6566a0a48892758b2e5f3a9e9b453d22171315fd29d"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOROOT"] = Formula["go"].opt_libexec

    (buildpath/"webassets").install resource("webassets")
    (buildpath/"src/github.com/gravitational/teleport").install buildpath.children
    cd "src/github.com/gravitational/teleport" do
      ENV.deparallelize { system "make", "full" }
      bin.install Dir["build/*"]
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    (testpath/"config.yml").write shell_output("#{bin}/teleport configure")
      .gsub("0.0.0.0", "127.0.0.1")
      .gsub("/var/lib/teleport", testpath)
      .gsub("/var/run", testpath)
      .gsub(/https_(.*)/, "")
    unless OS.mac?
      inreplace testpath/"config.yml", "/usr/bin/hostname", "/bin/hostname"
      inreplace testpath/"config.yml", "/usr/bin/uname", "/bin/uname"
    end
    begin
      debug = OS.mac? ? "" : "DEBUG=1 "
      pid = spawn("#{debug}#{bin}/teleport start -c #{testpath}/config.yml")
      if OS.mac?
        sleep 5
        path = OS.mac? ? "/usr/bin/" : ""
        system "#{path}curl", "--insecure", "https://localhost:3080"
        # Fails on Linux:
        # Failed to update cache: \nERROR REPORT:\nOriginal Error:
        # *trace.NotFoundError open /tmp/teleport-test-20190120-15973-1hx2ui3/cache/auth/localCluster:
        # no such file or directory
        system "#{path}nc", "-z", "localhost", "3022"
        system "#{path}nc", "-z", "localhost", "3023"
        system "#{path}nc", "-z", "localhost", "3025"
      end
    ensure
      Process.kill(9, pid)
    end
  end
end
