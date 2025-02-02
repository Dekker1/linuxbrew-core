class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.77.0.tar.gz"
  sha256 "e6053b20359b02233354930085318c8c729e3765e46e640ff7838de7e93fc51d"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82d1caf94f7017b27d0479447c1d33624134e2e765c52aba69e0675f9b5f2cf5" => :catalina
    sha256 "8eb0862a3a6634adf855b73f029de713107fb6f429ecf6babcc0dadc653cdffb" => :mojave
    sha256 "7142118d3e88fd8a0c3fef3ac8039f85ff0d13763bcee2dfd4ebe64ed65cb50d" => :high_sierra
    sha256 "94ebfb79b923079d7f75a8dbe82d657b3698349e70d565158e1602d1a5bd4b64" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
