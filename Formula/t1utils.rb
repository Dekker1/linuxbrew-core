class T1utils < Formula
  desc "Command-line tools for dealing with Type 1 fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/t1utils-1.42.tar.gz"
  sha256 "61877935b1987044ddff4bb90a05200ca7164678a355e170bf5f1a5556cc9f29"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfaaef0c838273e5c4cee7d6d2eb515e91c77c3226913b4c4486ca0086c2e6bc" => :catalina
    sha256 "1b511df389dee041c0cdadae94e38e987ea978024730d687b8642623cb054e09" => :mojave
    sha256 "c17de51c95690f3133933cd508873e21734a8e4f8ed80ec6546ab3c7fb82edd2" => :high_sierra
    sha256 "e45e52834f4776643c0b19d5008436c1afb57ffa32c6250784d3fc3038d676ae" => :x86_64_linux
  end

  head do
    url "https://github.com/kohler/t1utils.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/t1mac", "--version"
  end
end
