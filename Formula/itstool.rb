class Itstool < Formula
  desc "Make XML documents translatable through PO files"
  homepage "http://itstool.org/"
  url "https://github.com/itstool/itstool/archive/2.0.6.tar.gz"
  sha256 "bda0b08e9a1db885c9d7d1545535e9814dd8931d5b8dd5ab4a47bd769d0130c6"
  license "GPL-3.0"
  revision 2
  head "https://github.com/itstool/itstool.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f860a74756beaab039bffa02a4c8b8258f1a54a692532f4a1e57d0b4431c7ab9" => :catalina
    sha256 "d3b26ca21d37e4e0eb6e7318571a69aa021034bc69936749e8891213c16465c9" => :mojave
    sha256 "1ee274a6df78727bfcba1221ea16b5c2fa55819c66e2de9168c7915fd3238508" => :high_sierra
    sha256 "e8c0db995cc5df325eee5440818dfaaa83f10d4ab72a8ee8e94f09b2535e27c4" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libxml2"
  depends_on "python@3.9"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"

    system "./autogen.sh", "--prefix=#{libexec}",
                           "PYTHON=#{Formula["python@3.9"].opt_bin}/python3"
    system "make", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
    pkgshare.install_symlink libexec/"share/itstool/its"
    man1.install_symlink libexec/"share/man/man1/itstool.1"
  end

  test do
    (testpath/"test.xml").write <<~EOS
      <tag>Homebrew</tag>
    EOS
    system bin/"itstool", "-o", "test.pot", "test.xml"
    assert_match "msgid \"Homebrew\"", File.read("test.pot")
  end
end
