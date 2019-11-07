class EmacsHead < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-26.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-26.3.tar.xz"
  sha256 "4d90e6751ad8967822c6e092db07466b9d383ef1653feb2f95c93e7de66d3485"
  revision 1

  bottle do
    rebuild 7
    root_url "https://dl.bintray.com/daviderestivo/homebrew-emacs-head"
    sha256 "c53c1c5b4dadf0ce48155f3091057d5c89ee2468213a9e034d97721435c8dfec" => :sierra
    sha256 "74f9c49dee8d67aaaa251dbce94904d1a10a069ab478ca3d15983629aa8220e8" => :high_sierra
    sha256 "808665e2e9a397dfc71303fb11618d42ed60bbc484f864b36b9413741a526f76" => :mojave
    sha256 "4fd950d4e9c21d3834f85ef45167da79ba48620477f9eab440093ea3d95f230d" => :catalina
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git"

    depends_on "autoconf" => :build
    depends_on "gnu-sed"  => :build
    depends_on "texinfo"  => :build
  end

  option "with-cocoa",
         "Build a Cocoa version of GNU Emacs"
  option "with-ctags",
         "Don't remove the ctags executable that GNU Emacs provides"
  option "with-dbus",
         "Build with dbus support"
  option "without-gnutls",
         "Disable gnutls support"
  option "with-imagemagick",
         "Build with imagemagick support. Imagemagick@6 is used for GNU Emacs 26.x and imagemagick@7 for GNU Emacs 27.x"
  option "with-jansson",
         "Enable jansson support (only HEAD)"
  option "without-librsvg",
         "Disable librsvg support"
  option "with-mailutils",
         "Build with mailutils support"
  option "with-multicolor-fonts",
         "Enable multicolor fonts on macOS"
  option "without-modules",
         "Disable dynamic modules support"
  option "with-no-frame-refocus",
         "Disables frame re-focus (i.e. closing one frame does not refocus another one)"
  option "without-libxml2",
         "Disable libxml2 support"
  option "with-pdumper",
         "Enable pdumper support (only HEAD)"
  option "with-xwidgets",
         "Enable xwidgets support (only HEAD)"

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "librsvg"
  depends_on "libxml2"
  depends_on "dbus" => :optional
  depends_on "jansson" => :optional
  depends_on "mailutils" => :optional

  stable do
    # Emacs 26.x does not support ImageMagick 7:
    # Reported on 2017-03-04: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=25967
    depends_on "imagemagick@6" => :recommended
  end

  head do
    # Emacs 27.x (current HEAD) does support ImageMagick 7
    depends_on "imagemagick@7" => :recommended
  end

  # When closing a frame, Emacs automatically focuses another frame.
  # This re-focus has an additional side-effect: when closing a frame
  # from one desktop/space, one gets automatically moved to another
  # desktop/space where the refocused frame lives. The below patch
  # disable this behaviour.
  # Reference: https://github.com/d12frosted/homebrew-emacs-plus/issues/119
  if build.with? "no-frame-refocus"
    patch do
      url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/patches/0001-No-frame-refocus-cocoa.patch"
      sha256 "f004e6e65b969bbe83f5d6d53e4ba0e020631959da9ef9682479f7eeb09becd1"
    end
  end

  # Multicolor font support for macoOS has been re-enable on GNU Emacs
  # master branch:
  # https://github.com/emacs-mirror/emacs/commit/28220664714c50996d8318788289e1c69d69b8ab
  if build.head? && build.with?("multicolor-fonts")
    odie "Multicolor font support has been re-enabled on GNU Emacs HEAD. Please remove --with-multicolor-fonts."
  end

  # The multicolor-fonts patch is only needed on GNU Emacs 26.x
  if !build.head? && build.with?("multicolor-fonts")
    patch do
      url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/patches/0002-Patch-multicolor-font.patch"
      sha256 "5af2587e986db70999d1a791fca58df027ccbabd75f45e4a2af1602c75511a8c"
    end
  end

  if build.with? "pdumper"
    unless build.head?
      odie "--with-pdumper is supported only on --HEAD"
    end
    patch do
      url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/patches/0003-Pdumper-size-increase.patch"
      sha256 "38440720948f5144399cc700da5e40872cf0011cf2654fbb571684429d2162a1"
    end
  end

  if build.with? "xwidgets"
    unless build.head?
      odie "--with-xwidgets is supported only on --HEAD"
    end
    unless build.with? "cocoa"
      odie "--with-xwidgets is supported only on cocoa via xwidget webkit"
    end
    if build.with? "pdumper"
      patch do
        url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/patches/0005-Xwidgets-webkit-in-cocoa-pdumper.patch"
        sha256 "b472f8dcb6fd988f8dd7e21747f1252ddb305d0bae686ebe72597e715cbe24bc"
      end
    else
      patch do
        url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/patches/0004-Xwidgets-webkit-in-cocoa.patch"
        sha256 "a678810cc3f9d3c07a4550254b2b84e05c0a1e503917e291a6fc09b06b492f85"
      end
    end
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --without-x
    ]

    if build.with? "dbus"
      args << "--with-dbus"
    else
      args << "--without-dbus"
    end

    # Note that if ./configure is passed --with-imagemagick but can't find the
    # library it does not fail but imagemagick support will not be available.
    # See: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=24455
    if build.with? "imagemagick"
      args << "--with-imagemagick"
      if build.head?
        imagemagick_lib_path = Formula["imagemagick@7"].opt_lib/"pkgconfig"
        ohai "ImageMagick PKG_CONFIG_PATH: ", imagemagick_lib_path
        ENV.prepend_path "PKG_CONFIG_PATH", imagemagick_lib_path
      else
        imagemagick_lib_path = Formula["imagemagick@6"].opt_lib/"pkgconfig"
        ohai "ImageMagick PKG_CONFIG_PATH: ", imagemagick_lib_path
        ENV.prepend_path "PKG_CONFIG_PATH", imagemagick_lib_path
      end
    else
      args << "--without-imagemagick"
    end

    if build.with? "jansson"
      unless build.head?
        odie "--with-jansson is supported only on --HEAD"
      end
      args << "--with-json"
    end

    args << "--with-modules"  unless build.without? "modules"
    args << "--without-pop"   if     build.with?    "mailutils"
    args << "--with-gnutls"   unless build.without? "gnutls"
    args << "--with-rsvg"     unless build.without? "librsvg"
    args << "--with-xml2"     unless build.without? "libxml2"
    args << "--with-xwidgets" if     build.with?    "xwidgets"

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./autogen.sh"
    end

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

      system "make"
      system "make", "install"

      prefix.install "nextstep/Emacs.app"

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

      system "make"
      system "make", "install"
    end

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    if build.without? "ctags"
      (bin/"ctags").unlink
      (man1/"ctags.1.gz").unlink
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

  plist_options :manual => "emacs"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/emacs</string>
        <string>--fg-daemon</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
