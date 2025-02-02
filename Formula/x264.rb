class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  license "GPL-2.0"
  head "https://code.videolan.org/videolan/x264.git"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        revision: "db0d417728460c647ed4a847222a535b00d3dbcb"
    version "r3018"
  end

  # There's no guarantee that the versions we find on the `release-macos` index
  # page are stable but there didn't appear to be a different way of getting
  # the version information at the time of writing.
  livecheck do
    url "https://artifacts.videolan.org/x264/release-macos/"
    regex(%r{href=.*?x264[._-](r\d+)[._-][\da-z]+/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "836247c07b572ec7820680cbeecd6b908a7083d74819696bf41f7af11fcef3be" => :catalina
    sha256 "fee48981609b1f3d59cbd018150d97fa009288a48995c2c6d02cadefea57c072" => :mojave
    sha256 "777443f6d8b1f693ece28fbfed1f4f99835e5583a8949488425caf4d1110d8e1" => :high_sierra
    sha256 "c8edbd4c612e1bd66ee281024d7b6b1610c28a520475690029536fd5038f4175" => :x86_64_linux
  end

  depends_on "nasm" => :build

  if MacOS.version <= :high_sierra
    # Stack realignment requires newer Clang
    # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
    depends_on "gcc"
    fails_with :clang
  end

  # update config.* and configure: add Apple Silicon support.
  # upstream PR https://code.videolan.org/videolan/x264/-/merge_requests/35
  # Can be removed once it gets merged into stable branch
  patch do
    url "https://code.videolan.org/videolan/x264/-/commit/eb95c2965299ba5b8598e2388d71b02e23c9fba7.diff?full_index=1"
    sha256 "7cdc60cffa8f3004837ba0c63c8422fbadaf96ccedb41e505607ead2691d49b9"
  end

  def install
    # Work around Xcode 11 clang bug
    # https://bitbucket.org/multicoreware/x265/issues/514/wrong-code-generated-on-macos-1015
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --disable-swscale
      --disable-ffms
      --enable-shared
      --enable-static
      --enable-strip
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <x264.h>

      int main()
      {
          x264_picture_t pic;
          x264_picture_init(&pic);
          x264_picture_alloc(&pic, 1, 1, 1);
          x264_picture_clean(&pic);
          return 0;
      }
    EOS
    system ENV.cc, "-L{lib}", "test.c", "-lx264", "-o", "test"
    system "./test"
  end
end
