class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.9.4.tar.gz"
  sha256 "197380be127971defb5b9fed9316de9a3de88ef955b16f7f365beffe18f76b54"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "30a4c5387930bcdf4c16091d3ed8e714c0223e0566501390564236e44c50ed2a" => :catalina
    sha256 "4f64ed6133e285e29919ca26ae309f2a58966ddb4784e12295b41512b91d494b" => :mojave
    sha256 "330d4fc0e555543b4b45bfce0394520d981d03a8c6a920a510409a9e51793155" => :high_sierra
    sha256 "dfb847c2cbfa730032dfaeb31dfba58b6e4fbaaaf07f504a35e68a9352dc542b" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", "-o", "#{bin}/#{name}", "-trimpath", "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command: bash
      sync:
      - .:/usr/src/app
      forward:
      - 1234:1234
      - 8080:8080
      persistentVolume: {}
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
