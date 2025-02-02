class Simh < Formula
  desc "Portable, multi-system simulator"
  homepage "http://simh.trailing-edge.com/"
  url "https://github.com/simh/simh/archive/v3.11-1.tar.gz"
  version "3.11.1"
  sha256 "c8a2fc62bfa9369f75935950512a4cac204fd813ce6a9a222b2c6a76503befdb"
  license "MIT"
  head "https://github.com/simh/simh.git"

  # At the time this check was added, the "latest" release on GitHub was several
  # versions behind the actual latest version, so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-\d+)?)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "790feb234cf193ae6de2c076ad10024e5d9bd6d301020392a79cffc7ff6ccb15" => :catalina
    sha256 "76246ba12f6771a031a092ccbc67f0f6fbe8dacda0e5c1e41bbaa8d4a7918680" => :mojave
    sha256 "77ac8e9ea8a1589d4caa38f2cc9f21de2f4e66a836d316117926378080d09124" => :high_sierra
    sha256 "5185bca77b3670df8694607967c35d30b42d1e87edd4ebd5f1181b7e4ab47173" => :x86_64_linux
  end

  def install
    ENV.deparallelize unless build.head?
    inreplace "makefile", "GCC = gcc", "GCC = #{ENV.cc}"
    inreplace "makefile", "CFLAGS_O = -O2", "CFLAGS_O = #{ENV.cflags}"
    system "make", "USE_NETWORK=1", "all"
    bin.install Dir["BIN/*"]
    Dir["**/*.txt"].each do |f|
      (doc/File.dirname(f)).install f
    end
    (pkgshare/"vax").install Dir["VAX/*.{bin,exe}"]
  end

  test do
    assert_match(/Goodbye/, pipe_output("#{bin}/altair", "exit\n", 0))
  end
end
