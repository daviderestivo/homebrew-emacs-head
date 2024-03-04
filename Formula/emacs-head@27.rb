# coding: utf-8
require_relative "../Library/EmacsBase"

class EmacsHeadAT27 < EmacsBase
  url "https://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-27.2.tar.xz"
  sha256 "b4a7cc4e78e63f378624e0919215b910af5bb2a0afc819fad298272e9f40c1b9"
  version "27.2"
  revision 1

  head do
    url "https://github.com/emacs-mirror/emacs.git", :branch => "emacs-27"
  end

  depends_on "autoconf"   => :build
  depends_on "gnu-sed"    => :build
  depends_on "texinfo"    => :build
  depends_on "automake"   => :build
  depends_on "cmake"      => :build
  depends_on "pkg-config" => :build
  depends_on "giflib"
  depends_on "gnutls"     => :recommended
  depends_on "librsvg"    => :recommended
  depends_on "libxml2"    => :recommended
  depends_on "jansson"
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

  if build.with? "imagemagick"
    depends_on "imagemagick" => :recommended
  end

  # All the patches and the icons have been declared as resources.
  # They are downloaded unconditionally even if not used in order to
  # overcome the reinstall issue mentioned here:
  # https://github.com/daviderestivo/homebrew-emacs-head/issues/28

  # Patches
  resource "0001-No-frame-refocus-cocoa" do
    url ResourcesResolver.get_resource_url("patches/0001-No-frame-refocus-cocoa.patch")
    sha256 "f004e6e65b969bbe83f5d6d53e4ba0e020631959da9ef9682479f7eeb09becd1"
  end

  resource "0003-Pdumper-size-increase" do
    url ResourcesResolver.get_resource_url("patches/0003-Pdumper-size-increase.patch")
    sha256 "38440720948f5144399cc700da5e40872cf0011cf2654fbb571684429d2162a1"
  end

  resource "0004-Xwidgets-webkit-in-cocoa-27" do
    url ResourcesResolver.get_resource_url("patches/0004-Xwidgets-webkit-in-cocoa-27.patch")
    sha256 "56406c03cbcea0d6d4c893074935404937cdae03259b8120b1b913971a948476"
  end

  resource "0005-System-appearance-27" do
    url ResourcesResolver.get_resource_url("patches/0005-System-appearance-27.patch")
    sha256 "d774e9da082352999fe3e9d2daa1065ea9bdaa670267caeebf86e01a77dc1d40"
  end

  # Link: https://www.reddit.com/r/emacs/comments/icem4s/emacs_271_freezes_when_using_font_ligatures/
  resource "0007-Ligatures-freeze-fix-27" do
    url ResourcesResolver.get_resource_url("patches/0007-Ligatures-freeze-fix-27.patch")
    sha256 "9f81669cba1dedb2733e95d49b8ebe82df3455bf258f130749665cc6adf2afa9"
  end

  resource "0008-Fix-window-role.patch" do
    url ResourcesResolver.get_resource_url("patches/0008-Fix-window-role.patch")
    sha256 "1f8423ea7e6e66c9ac6dd8e37b119972daa1264de00172a24a79a710efcb8130"
  end

  resource "0010-Arm.patch" do
    url ResourcesResolver.get_resource_url("patches/0010-Arm.patch")
    sha256 "344fee330fec4071e29c900093fdf1e2d8a7328df1c75b17e6e9d9a954835741"
  end

  # Icons
  load_icons

  # When closing a frame, GNU Emacs automatically focuses another frame.
  # This re-focus has an additional side-effect: when closing a frame
  # from one desktop/space, one gets automatically moved to another
  # desktop/space where the refocused frame lives. The below patch
  # disable this behaviour.
  # Reference: https://github.com/d12frosted/homebrew-emacs-plus/issues/119
  if build.with? "no-frame-refocus"
    patch do
      url ResourcesResolver.get_resource_url("patches/0001-No-frame-refocus-cocoa.patch")
      sha256 "f004e6e65b969bbe83f5d6d53e4ba0e020631959da9ef9682479f7eeb09becd1"
    end
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
    patch do
      url ResourcesResolver.get_resource_url("patches/0004-Xwidgets-webkit-in-cocoa-27.patch")
      sha256 "56406c03cbcea0d6d4c893074935404937cdae03259b8120b1b913971a948476"
    end
  end

  patch do
    url ResourcesResolver.get_resource_url("patches/0005-System-appearance-27.patch")
    sha256 "d774e9da082352999fe3e9d2daa1065ea9bdaa670267caeebf86e01a77dc1d40"
  end

  patch do
    url ResourcesResolver.get_resource_url("patches/0007-Ligatures-freeze-fix-27.patch")
    sha256 "9f81669cba1dedb2733e95d49b8ebe82df3455bf258f130749665cc6adf2afa9"
  end

  patch do
    url ResourcesResolver.get_resource_url("patches/0008-Fix-window-role.patch")
    sha256 "1f8423ea7e6e66c9ac6dd8e37b119972daa1264de00172a24a79a710efcb8130"
  end

  stable do
    # Back-ported patch for configure and configure.guess to allow
    # configure to complete for aarch64-apple-darwin targets.
    patch do
      url ResourcesResolver.get_resource_url("patches/0010-Arm.patch")
      sha256 "344fee330fec4071e29c900093fdf1e2d8a7328df1c75b17e6e9d9a954835741"
    end
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

    # Read https://github.com/emacs-mirror/emacs/blob/master/etc/DEBUG
    # for more information
    if build.with? "crash-debug"
      args << "--disable-silent-rules"
      ohai "GNU Emacs crash debug enabled. Appending `-g3` to CFLAGS..."
      ENV.append_to_cflags "-g3"
    end
    # Increase macOS max open files to 10000 (default is 1024)
    ENV.append "CFLAGS", "-DFD_SETSIZE=10000 -DDARWIN_UNLIMITED_SELECT"

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

      system "make"
      system "make", "install"

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

    # Follow MacPorts and don't install ctags from GNU Emacs. This
    # allows Vim and GNU Emacs and ctags to play together without
    # violence.
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

                               ----------
                               Important:
                               ----------

      GNU Emacs 26 and GNU Emacs 28 now live in separate formulas.
      Please use emacs-head@26 or emacs-head@28 formulas if you wish
      to install them:

        $ brew install emacs-head@26 [options]

        or

        $ brew install emacs-head@28 [options]

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
