class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/a2/54/da10f9a0235681179144a5ca02147428f955745e9393f859dec8d0d05b41/sqlparse-0.4.1.tar.gz"
  sha256 "0f91fd2e829c44362cbcfab3e9ae12e22badaa8a29ad5ff599f9ec109f0454e8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "474e731b38baa47c6db75bf1ca957e6814148dd166941c70967836eeb3be844e" => :catalina
    sha256 "fe9331f9ef485b2b110cf72fb36a9344d5744efb79b4652b4f8e37c1c43facc6" => :mojave
    sha256 "743a16f18f46d93b073e9dcf01164c1347314fbbbced824d86906a345324e29a" => :high_sierra
    sha256 "c4f2e744d07f95d824de4260ab9e67d29ed9afc3be0918266af7663f49c45229" => :x86_64_linux
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
