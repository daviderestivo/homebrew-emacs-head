# coding: utf-8
require_relative "../Library/EmacsBase"

class EmacsHeadAT31 < EmacsBase
  if build.with? "mps"
    url "https://github.com/emacs-mirror/emacs.git", :branch => "scratch/igc"
  else
    url "https://github.com/emacs-mirror/emacs.git"
  version "31.0.50"
  revision 1

  depends_on "autoconf"   => :build
  depends_on "coreutils"  => :build
  depends_on "gnu-sed"    => :build
  depends_on "texinfo"    => :build
  depends_on "automake"   => :build
  depends_on "cmake"      => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"        => :build
  depends_on "giflib"
  depends_on "gnutls"     => :recommended
  depends_on "librsvg"    => :recommended
  depends_on "libxml2"    => :recommended
  depends_on "jansson"
  depends_on "webp"
  depends_on "dbus"        => :optional
  depends_on "mailutils"   => :optional
  depends_on "imagemagick" => :optional

  option "with-crash-debug",
         "Append `-g3` to CFLAGS to enable crash debugging"
  option "with-cocoa",
         "Build a Cocoa version of GNU Emacs"
  option "with-ctags",
         "Don't remove the ctags executable that GNU Emacs provides"
  option "with-dbus",
         "Build with dbus support"
  option "without-gnutls",
         "Disable gnutls support"
  option "with-imagemagick",
         "Build with imagemagick support"
  option "without-librsvg",
         "Disable librsvg support"
  option "with-mailutils",
         "Build with mailutils support"
  option "without-modules",
         "Disable dynamic modules support"
  option "with-no-frame-refocus",
         "Disables frame re-focus (i.e. closing one frame does not refocus another one)"
  option "without-libxml2",
         "Disable libxml2 support"
  option "with-pdumper",
         "Enable pdumper support"
  option "with-xwidgets",
         "Enable xwidgets support"
  option "with-native-comp",
         "Enable Elisp native compilation support"
  option "with-native-full-aot",
         "Enable Elisp Ahead-of-Time native compilation support"
  option "with-tree-sitter",
         "Enable Tree-sitter support"
  option "with-poll",
         "Experimental: use poll() instead of select() to support > 1024 file descriptors"
  option "with-mps"

  if build.with? "imagemagick"
    depends_on "imagemagick" => :recommended
  end

  if build.with? "native-comp"
    depends_on "gmp"       => :build
    depends_on "libjpeg"   => :build
    depends_on "zlib"      => :build
    depends_on "libgccjit" => :recommended
  end

  if build.with? "tree-sitter"
    depends_on "tree-sitter" => :optional
  end

  # All the patches and the icons have been declared as resources.
  # They are downloaded unconditionally even if not used in order to
  # overcome the reinstall issue mentioned here:
  # https://github.com/daviderestivo/homebrew-emacs-head/issues/28

  # Patches
  resource "0003-Pdumper-size-increase" do
    url ResourcesResolver.get_resource_url("patches/0003-Pdumper-size-increase.patch")
    sha256 "38440720948f5144399cc700da5e40872cf0011cf2654fbb571684429d2162a1"
  end

  resource "0005-System-appearance" do
    url  ResourcesResolver.get_resource_url("patches/0005-System-appearance.patch")
    sha256 "9eb3ce80640025bff96ebaeb5893430116368d6349f4eb0cb4ef8b3d58477db6"
  end

  resource "0008-Fix-window-role.patch" do
    url ResourcesResolver.get_resource_url("patches/0008-Fix-window-role.patch")
    sha256 "1f8423ea7e6e66c9ac6dd8e37b119972daa1264de00172a24a79a710efcb8130"
  end

  resource "0011-Poll-30.patch" do
    url ResourcesResolver.get_resource_url("patches/0011-Poll-30.patch")
    sha256 "59e876f82e6fd8e4583bc2456339eda4f989c86b1e16a02b0726702e95f60825"
  end

  resource "0012-BLOCK_ALIGN.patch" do
    url ResourcesResolver.get_resource_url("patches/0012-BLOCK_ALIGN.patch")
    sha256 "20867fec025e1c571635512fb790af0fbafc089b0b656dc8ece9d0ed8d3e6a6b"
  end

  # Icons
  load_icons

  # When closing a frame, GNU Emacs automatically focuses another frame.
  # This re-focus has an additional side-effect: when closing a frame
  # from one desktop/space, one gets automatically moved to another
  # desktop/space where the refocused frame lives. The below patch
  # disable this behaviour.
  # Reference: https://github.com/d12frosted/homebrew-emacs-plus/issues/119
  #
  # Update: this fix is now directly available in emacs master branch.
  # See commit:
  # https://github.com/emacs-mirror/emacs/commit/5427ef23b8b3ef52faf4ab1e8401303220c2d1d1
  if build.with? "no-frame-refocus"
    # Show a warning to the user
    opoo "The option --with-no-frame-refocus is not required anymore in emacs-head@30."
  end

  if build.with? "pdumper"
    patch do
      url ResourcesResolver.get_resource_url("patches/0003-Pdumper-size-increase.patch")
      sha256 "38440720948f5144399cc700da5e40872cf0011cf2654fbb571684429d2162a1"
    end
  end

  if build.with? "xwidgets"
    unless build.with? "cocoa"
      odie "--with-xwidgets is supported only on cocoa via xwidget webkit"
    end
  end

  if build.with? "poll"
    patch do
      url ResourcesResolver.get_resource_url("patches/0011-Poll-30.patch")
      sha256 "59e876f82e6fd8e4583bc2456339eda4f989c86b1e16a02b0726702e95f60825"
    end
  end

  patch do
    url ResourcesResolver.get_resource_url("patches/0005-System-appearance.patch")
    sha256 "9eb3ce80640025bff96ebaeb5893430116368d6349f4eb0cb4ef8b3d58477db6"
  end

  patch do
    url ResourcesResolver.get_resource_url("patches/0008-Fix-window-role.patch")
    sha256 "1f8423ea7e6e66c9ac6dd8e37b119972daa1264de00172a24a79a710efcb8130"
  end

  patch do
    url ResourcesResolver.get_resource_url("patches/0012-BLOCK_ALIGN.patch")
    sha256 "20867fec025e1c571635512fb790af0fbafc089b0b656dc8ece9d0ed8d3e6a6b"
  end

  def install
    args = %W[
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --without-x
    ]

    make_flags = []

    if build.with? "dbus"
      args << "--with-dbus"
    else
      args << "--without-dbus"
    end

    if build.with? "native-comp"

      if build.with? "native-full-aot"
        ohai "Force full Ahead-of-Time compilation"
        make_flags << "NATIVE_FULL_AOT=1"
      end

      gcc_version = Formula["gcc"].any_installed_version
      gcc_version_major = gcc_version.major
      gcc_lib="#{HOMEBREW_PREFIX}/lib/gcc/#{gcc_version_major}"

      ENV.append "LDFLAGS", "-L#{gcc_lib}"
      ENV.append "LDFLAGS", "-I#{Formula["gcc"].include}"
      ENV.append "LDFLAGS", "-I#{Formula["libgccjit"].include}"
      ENV.append "LDFLAGS", "-I#{Formula["gmp"].include}"
      ENV.append "LDFLAGS", "-I#{Formula["libjpeg"].include}"

      args << "--with-native-compilation"
      make_flags << "BYTE_COMPILE_EXTRA_FLAGS=--eval '(setq comp-speed 2)'"
    end

    # Note that if ./configure is passed --with-imagemagick but can't find the
    # library it does not fail but imagemagick support will not be available.
    # See: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=24455
    if build.with? "imagemagick"
      args << "--with-imagemagick"
      imagemagick_lib_path = Formula["imagemagick"].opt_lib/"pkgconfig"
      ohai "ImageMagick PKG_CONFIG_PATH: ", imagemagick_lib_path
      ENV.prepend_path "PKG_CONFIG_PATH", imagemagick_lib_path
    else
      args << "--without-imagemagick"
    end

    args << "--with-modules"  unless build.without? "modules"
    args << "--without-pop"   if     build.with?    "mailutils"
    args << "--with-gnutls"   unless build.without? "gnutls"
    args << "--with-rsvg"     unless build.without? "librsvg"
    args << "--with-xml2"     unless build.without? "libxml2"
    args << "--with-xwidgets" if     build.with?    "xwidgets"
    args << "--with-poll"     if     build.with?    "poll"
    args << "--with-webp"

    # Read https://github.com/emacs-mirror/emacs/blob/master/etc/DEBUG
    # for more information
    if build.with? "crash-debug"
      args << "--disable-silent-rules"
      ohai "GNU Emacs crash debug enabled. Appending `-g3` to CFLAGS..."
      ENV.append_to_cflags "-g3"
    end
    # Optimize emacs executable and increase macOS max open files to
    # 10000 (default is 1024)
    ENV.append "CFLAGS", "-O2 -march=native -pipe -DFD_SETSIZE=10000 -DDARWIN_UNLIMITED_SELECT"

    # Use GNU install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    # Use GNU sed
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
    system "./autogen.sh"

    if build.with? "cocoa"
      args << "--with-ns" << "--disable-ns-self-contained"

      system "./configure", *args

      # Disable aligned_alloc on Mojave. See issue: https://github.com/daviderestivo/homebrew-emacs-head/issues/15
      if MacOS.version <= :mojave
        ohai "Force disabling of aligned_alloc on macOS <= Mojave"
        configure_h_filtered = File.read("src/config.h")
                                 .gsub("#define HAVE_ALIGNED_ALLOC 1", "#undef HAVE_ALIGNED_ALLOC")
                                 .gsub("#define HAVE_DECL_ALIGNED_ALLOC 1", "#undef HAVE_DECL_ALIGNED_ALLOC")
                                 .gsub("#define HAVE_ALLOCA 1", "#undef HAVE_ALLOCA")
                                 .gsub("#define HAVE_ALLOCA_H 1", "#undef HAVE_ALLOCA_H")
        File.open("src/config.h", "w") do |f|
          f.write(configure_h_filtered)
        end
      end

      system "make", *make_flags

      icons_dir = buildpath/"nextstep/Emacs.app/Contents/Resources"

      ICONS.each_key do |icon|
        if build.with? icon
          rm "#{icons_dir}/Emacs.icns"
          resource(icon).stage do
            icons_dir.install Dir["*.icns*"].first => "Emacs.icns"
            ohai "Installing " + icon + " icon"
          end
        end
      end

      system "make", "install"

      # Install the (separate) debug symbol data that is generated
      # for the application
      if build.with? "crash-debug"
        system "dsymutil", "nextstep/Emacs.app/Contents/MacOS/Emacs"
      end

      prefix.install "nextstep/Emacs.app"
      (prefix/"Emacs.app/Contents").install "native-lisp" if build.with? "native-comp"

      # Replace the symlink with one that avoids starting Cocoa.
      (bin/"emacs").unlink # Kill the existing symlink
      (bin/"emacs").write <<~EOS
        #!/bin/bash
        exec #{prefix}/Emacs.app/Contents/MacOS/Emacs "$@"
      EOS
    else
      args << "--without-ns"

      system "./configure", *args

      # Disable aligned_alloc on Mojave. See issue: https://github.com/daviderestivo/homebrew-emacs-head/issues/15
      if MacOS.version <= :mojave
        ohai "Force disabling of aligned_alloc on macOS <= Mojave"
        configure_h_filtered = File.read("src/config.h")
                                 .gsub("#define HAVE_ALIGNED_ALLOC 1", "#undef HAVE_ALIGNED_ALLOC")
                                 .gsub("#define HAVE_DECL_ALIGNED_ALLOC 1", "#undef HAVE_DECL_ALIGNED_ALLOC")
                                 .gsub("#define HAVE_ALLOCA 1", "#undef HAVE_ALLOCA")
                                 .gsub("#define HAVE_ALLOCA_H 1", "#undef HAVE_ALLOCA_H")
        File.open("src/config.h", "w") do |f|
          f.write(configure_h_filtered)
        end
      end

      system "make", *make_flags
      system "make", "install"
    end

    # Follow MacPorts and don't install ctags from GNU Emacs. This
    # allows Vim and GNU Emacs and ctags to play together without
    # violence.
    if build.without? "ctags"
      (bin/"ctags").unlink
      (man1/"ctags.1.gz").unlink
    end
  end

  def post_install
    emacs_info_dir = info/"emacs"
    Dir.glob(emacs_info_dir/"*.info") do |info_filename|
      system "install-info", "--info-dir=#{emacs_info_dir}", info_filename
    end
  end

  def caveats
    <<~EOS
      Emacs.app was installed to:
        #{prefix}
      To link the application:
        ln -s #{prefix}/Emacs.app /Applications

    EOS
  end

  service do
    run [opt_bin/"emacs", "--fg-daemon"]
    keep_alive true
    log_path "/tmp/homebrew.mxcl.emacs-head.stdout.log"
    error_log_path "/tmp/homebrew.mxcl.emacs-head.stderr.log"
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
