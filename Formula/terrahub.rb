require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.38.tgz"
  sha256 "10a5ad822c1377ec268447b0c5c2982e8fb4980174567f1f13e4119dd614f2a3"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "48881969f99f6a47cd556fe4b1117d63a667aa412de842de00e9ca991cc3b780" => :catalina
    sha256 "21c260b9e1496872d8f0e4d9c5af0a6578531306c241b6790d2e9b389781cba2" => :mojave
    sha256 "207a0183058ecf52b751de6fdcbf416fe966738b90a1369f110c2bf936b0fa2c" => :high_sierra
    sha256 "8bda7fdd2d18a14c992ff900ad3e2f391b41f5e2fb8acf1a34ec10ac6dcd322c" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".terrahub.yml").write <<~EOF
      project:
        name: terrahub-demo
        code: abcd1234
      vpc_component:
        name: vpc
        root: ./vpc
      subnet_component:
        name: subnet
        root: ./subnet
    EOF
    output = shell_output("#{bin}/terrahub graph")
    assert_match "Project: terrahub-demo", output
  end
end
