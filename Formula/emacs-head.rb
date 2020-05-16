# coding: utf-8
class EmacsHead < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-26.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-26.3.tar.xz"
  sha256 "4d90e6751ad8967822c6e092db07466b9d383ef1653feb2f95c93e7de66d3485"
  revision 1

  bottle do
    rebuild 8
    root_url "https://dl.bintray.com/daviderestivo/homebrew-emacs-head"
    sha256 "3da2bf583edc127dbdde59cb9b01de4940aedb3ccb3c01273e76d110f869c4ea" => :high_sierra
    sha256 "514626098894254ce009b6b1f9a90bdb6679a3e3a005b6bdd5c36d610cae4583" => :mojave
    sha256 "a31d1c6acb0e5eab9253acd5455320d9640dd10d42705fbee0ab7f3ae83a9ab5" => :catalina
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git"

    depends_on "autoconf" => :build
    depends_on "gnu-sed"  => :build
    depends_on "texinfo"  => :build
  end

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
  option "with-modern-icon-cg433n",
         "Use a modern style icon by @cg433n"
  option "with-modern-icon-sjrmanning",
         "Use a modern style icon by @sjrmanning"
  option "with-modern-icon-sexy-v1",
         "Use a modern style icon by Emacs is Sexy (v1)"
  option "with-modern-icon-sexy-v2",
         "Use a modern style icon by Emacs is Sexy (v2)"
  option "with-modern-icon-papirus",
         "Use a modern style icon by Papirus Development Team"
  option "with-modern-icon-pen",
         "Use a modern style icon by Kentaro Ohkouchi"
  option "with-modern-icon-black-variant",
         "Use a modern style icon by BlackVariant"
  option "with-modern-icon-nuvola",
         "Use a modern style icon by David Vignoni (Nuvola Icon Theme)"
  option "with-retro-icon-gnu-head",
         "Use a retro style icon by Aurélio A. Heckert (GNU Project)"
  option "with-retro-icon-sink-bw",
         "Use a retro style icon by Unknown"
  option "with-retro-icon-sink",
         "Use a retro style icon by Erik Mugele"

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
    # Turn on harfbuzz support on HEAD
    depends_on "harfbuzz" => :recommended
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
        sha256 "7580569c1574169c6281a33eb2867c4f32c8332d5ffe33c8ca84d4502238601d"
      end
    else
      patch do
        url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/patches/0004-Xwidgets-webkit-in-cocoa.patch"
        sha256 "40fb5d6f703838fe90688e35f66f93c46dc5e3451fdcd41dc01950dc8c7c0d9c"
      end
    end
  end

  if build.head?
    patch do
      url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/patches/0006-System-appearance.patch"
      sha256 "2a0ce452b164eee3689ee0c58e1f47db368cb21b724cda56c33f6fe57d95e9b7"
    end
  end

  resource "modern-icon-cg433n" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/modern-icon-cg433n.icns"
    sha256 "9a0b101faa6ab543337179024b41a6e9ea0ecaf837fc8b606a19c6a51d2be5dd"
  end

  resource "modern-icon-sjrmanning" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/modern-icon-sjrmanning.icns"
    sha256 "fc267d801432da90de5c0d2254f6de16557193b6c062ccaae30d91b3ada01ab9"
  end

  resource "modern-icon-sexy-v1" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/modern-icon-sexy-v1.icns"
    sha256 "1ea8515d1f6f225047be128009e53b9aa47a242e95823c07a67c6f8a26f8d820"
  end

  resource "modern-icon-sexy-v2" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/modern-icon-sexy-v2.icns"
    sha256 "ecdc902435a8852d47e2c682810146e81f5ad72ee3d0c373c936eb4c1e0966e6"
  end

  resource "modern-icon-papirus" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/modern-icon-papirus.icns"
    sha256 "50aef07397ab17073deb107e32a8c7b86a0e9dddf5a0f78c4fcff796099623f8"
  end

  resource "modern-icon-pen" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/modern-icon-pen.icns"
    sha256 "4fda050447a9803d38dd6fd7d35386103735aec239151714e8bf60bf9d357d3b"
  end

  resource "modern-icon-nuvola" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/modern-icon-nuvola.icns"
    sha256 "c3701e25ff46116fd694bc37d8ccec7ad9ae58bb581063f0792ea3c50d84d997"
  end

  resource "modern-icon-black-variant" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/modern-icon-black-variant.icns"
    sha256 "a56a19fb5195925c09f38708fd6a6c58c283a1725f7998e3574b0826c6d9ac7e"
  end

  resource "retro-icon-gnu-head" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/retro-icon-gnu-head.icns"
    sha256 "cfca2ff0214cff47167f634a5b9f8c402b488796f79ded23f93ec505f78b2f2f"
  end

  resource "retro-icon-sink-bw" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/retro-icon-sink-bw.icns"
    sha256 "5cd836f86c8f5e1688d6b59bea4b57c8948026a9640257a7d2ec153ea7200571"
  end

  resource "retro-icon-sink" do
    url "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/master/icons/retro-icon-sink.icns"
    sha256 "be0ee790589a3e49345e1894050678eab2c75272a8d927db46e240a2466c6abc"
  end

  def install
    args = %W[
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

    # Read https://github.com/emacs-mirror/emacs/blob/master/etc/DEBUG
    # for more information
    if build.with? "crash-debug"
      args << "--disable-silent-rules"
      ohai "Emacs crash debug enabled. Appending `-g3` to CFLAGS..."
      ENV.append_to_cflags "-g3"
    end

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      if build.with? "cocoa"
        args << "--with-harfbuzz"
      end
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

      icons_dir = buildpath/"nextstep/Emacs.app/Contents/Resources"

      (%w[modern-icon-cg433n modern-icon-sjrmanning
        modern-icon-sexy-v1 modern-icon-sexy-v2
        modern-icon-papirus modern-icon-pen
        modern-icon-black-variant modern-icon-nuvola
        retro-icon-gnu-head retro-icon-sink-bw retro-icon-sink]).each do |icon|
        if build.with? icon
          rm "#{icons_dir}/Emacs.icns"
          resource(icon).stage do
            icons_dir.install Dir["*.icns*"].first => "Emacs.icns"
            ohai "Installing " + icon + " icon"
          end
        end
      end

      # Install the (separate) debug symbol data that is generated
      # for the application
      if build.with? "crash-debug"
        system "dsymutil", "nextstep/Emacs.app/Contents/MacOS/Emacs"
      end

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
