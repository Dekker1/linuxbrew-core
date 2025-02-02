class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.108.zip"
  sha256 "745b63d02eb49d6cf3d47fedaa344187fe532fb80bbd39c0ceee4cca285fa874"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 "5f12a8bebb946fa4dce4cb45a527234bbb8df08a7b9c59c0a2c3d2b0bcb06703" => :catalina
    sha256 "c46221dc8ba576838765c1bac00842da66522d1f8d1c2bee9ceefd7ff30b8c93" => :mojave
    sha256 "e179ecd3f4b21a71e25f614211f3bc9476bc8f127d8d034c98075e0b01e884db" => :high_sierra
    sha256 "5aa661aef033e1a081eaa4e960c125286a838a356970601bc01d447aa7392808" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end
