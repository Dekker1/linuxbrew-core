class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.12.1.tar.gz"
  sha256 "d29e4250d437340b076350e910e69fd5539ef8b92528d0306745cec0e343cc17"
  license "MPL-2.0"

  bottle do
    cellar :any
    sha256 "09d81d6913f1df2baac52ff074f626cbad08abfe1a8a0c8c1139b26e170dc850" => :catalina
    sha256 "9e515914ebc32d9262f7d64ff59ed90fe0268d7068cf589d71abca2fed7d7df9" => :mojave
    sha256 "6028bf4f5150f6051373a0317466f476ba6fcb5855f1db45627b9fcb079aeffd" => :high_sierra
    sha256 "ebde644ce1bf30b70bd5509b38ae6d20e4f152067afa5e5447bb20f733b16117" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <jwt.h>

      int main() {
        jwt_t *jwt = NULL;
        if (jwt_new(&jwt) != 0) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", *("-Wl,-rpath=#{lib}" unless OS.mac?), "-o", "test"
    system "./test"
  end
end
