class I386ElfGcc < Formula
  desc "GNU Compiler Collection targetting i386-elf"
  homepage "https://gcc.gnu.org"
  url "https://github.com/Kyle-Ye/homebrew-i386-elf-toolchain/blob/master/gcc-11.2.0.tar.xz"
  version "11.2.0"
  sha256 "24c2861c9a0a4f1800349c75679d46bc0f571c015f672ae4f95b52e8b6b59e20"
  revision 1

  depends_on "gmp" => :build
  depends_on "mpfr" => :build
  depends_on "libmpc"
  depends_on "Kyle-Ye/i386-elf-toolchain/i386-elf-binutils"

  def install
    mkdir "gcc-build" do
      system "../configure", "--prefix=#{prefix}",
                             "--target=i386-elf",
                             "--disable-multilib",
                             "--disable-nls",
                             "--disable-werror",
                             "--without-headers",
                             "--without-isl",
                             "--enable-languages=c,c++"

      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # GCC needs this folder in #{prefix} in order to see the binutils.
      # It doesn't look for i386-elf-as on $PREFIX/bin. Rather, it looks
      # for as on $PREFIX/$TARGET/bin/ ($PREFIX/i386-elf/bin/as).
      binutils = Formula["i386-elf-binutils"].prefix
      ln_sf "#{binutils}/i386-elf", "#{prefix}/i386-elf"
    end
  end

  test do
    system "i386-elf-gcc", "--version"
  end
end
