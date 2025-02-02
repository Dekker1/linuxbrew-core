require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.19.2.tgz"
  sha256 "89a5682ec1f46792f3c240a495959e6e9f4b4ececbd500ee717e593cc51948af"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4e1e9a38076784db8c2bf09493d4d068adc7ace4c7807084fee478850f86996b" => :catalina
    sha256 "729fcca11574056cda658b7c8a3ab7fc389a5a6c53c2edac7729daa12bf11cd9" => :mojave
    sha256 "9201f6ddd416b1a2c0bbf339218a8cfabedbbf7ae5444ed49772ccc6acd0a5bc" => :high_sierra
    sha256 "9b8a6658d4cc031b3689073a9cc47d2a3d97b3913e8c49bdd3a535fd5e8741a7" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
