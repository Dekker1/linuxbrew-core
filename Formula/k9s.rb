class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.23.3",
      revision: "0fc7ea318341a0033d4639bb627bc359aed370b7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "930e36ac007f2d9551a0d98938a3048f7404748cd6c1dadd25e631319ee8ed4f" => :catalina
    sha256 "2fa38a2935c2bd0c5d218c47377e4969921777a7e4273c2f91ef6236c1700445" => :mojave
    sha256 "5dfaad3018036a2962f89da2e6a862288ce27a322b9ef4e65b4157d39b68f5a4" => :high_sierra
    sha256 "dd09d34e0e85d4009870a67a7239c915947fc487e14afde1b958d29dec6883ad" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{stable.specs[:revision]}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
