class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.24.1.tar.gz"
  sha256 "35e8f57319d4b0ad3297251f4487b15203d288a081c1019d67f80758264b9d45"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c360ba853f221b1821997668797804bf92af2fabd15b2410487679c32f6c7463" => :catalina
    sha256 "26df1fe7e70b7debd910cb90cd72d247c67bca4678be30b0bc602b5942b54d4e" => :mojave
    sha256 "8df5d106e8e1f330b83655f86299280409351a544d86037ba43f0a7a67960558" => :high_sierra
    sha256 "c6ff7bb098a54de42822b3f816d8cdc1f1b260a3c739e6ec278d6e98edb18f4e" => :x86_64_linux
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    system "go", "build", "-o", bin/"fzf", "-ldflags", "-X main.version=#{version} -X main.revision=brew"

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats
    <<~EOS
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}/install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end
