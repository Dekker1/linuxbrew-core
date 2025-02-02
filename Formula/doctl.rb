class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.50.0.tar.gz"
  sha256 "7791240ce24be1fc72c6eeefcb41fca68a939cf54b9f52a476076d4b7ad7a01f"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33452988bba4b8bbb94cc288d98b5773cff6376865ab92c720ad1c443d1368ee" => :catalina
    sha256 "1f289202a4a279c6b7f9da4e69667bac40ff23b494e4ba1a475cc0d17e0aa7d6" => :mojave
    sha256 "01811d257f86d3375ab38c375573986f8d299b664976b8e20dead0d2e3821686" => :high_sierra
    sha256 "52de90ec60283c05ec55a61823edd47105136ee31d0d1ce3aa93122d51c4b00c" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ].join(" ")

    system "go", "build", "-ldflags", ldflags, *std_go_args, "github.com/digitalocean/doctl/cmd/doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
