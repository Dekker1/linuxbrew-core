class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.2.10.tar.gz"
  sha256 "6a99eeb73433f76a3bb17cb17a084ea56b40cd9a6ce858811ba25c7120b4a5e3"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "30f13a5aa494f69ebc027f3d83f0856ca9b13b445ce5e1ed00742b0c5b155e3b" => :catalina
    sha256 "f191c7b2e3911f57e54d008fee940ead2ca6d325f86619cf78bca05692b3d617" => :mojave
    sha256 "81f15b3680b53ac2a53e7c9bdcd378c5380af4c44170ca70a935ddb1efd425df" => :high_sierra
    sha256 "7927b423d7a53541b1163c9b4d242795601ea9818fe6fb25e9712ad8b5e46374" => :x86_64_linux
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  on_linux do
    depends_on "readline"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
