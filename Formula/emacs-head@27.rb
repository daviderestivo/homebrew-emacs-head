# coding: utf-8
class EmacsHeadAT27 < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://alpha.gnu.org/gnu/emacs/pretest/emacs-27.0.91.tar.xz"
  sha256 "96813dd385dec81ceb1868645939d49b81ca2c1feb42a58b4d38125ebd1345aa"
  version "27.0.91"
  revision 1

  bottle do
    rebuild 9
    root_url "https://dl.bintray.com/daviderestivo/homebrew-emacs-head"
    sha256 "6bb58d10953bd66568a60b1fbdd1e685410625089a02e912e7648630d1e3532f" => :high_sierra
    sha256 "92efec40a8060890302b4c01014130ab0edf0442e3a58d3473e89d9750ec7594" => :mojave
    sha256 "a591515e636c2853e40ab31b9e6fc15e0236082b8615e91aab1bb3d3c120d42a" => :catalina
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git", :branch => "emacs-27"
  end

  depends_on "pkg-config" => :build
  depends_on "giflib"
  depends_on "gnutls"
  depends_on "librsvg"
  depends_on "libxml2"
  depends_on "jansson"
  depends_on "dbus" => :optional
  depends_on "mailutils" => :optional
  depends_on "autoconf" => :build
  depends_on "gnu-sed"  => :build
  depends_on "texinfo"  => :build
  # GNU Emacs 27.x does support ImageMagick 7
  depends_on "imagemagick@7" => :recommended
  # Turn on harfbuzz support
  depends_on "harfbuzz" => :recommended

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
  option "with-jansson",
         "Enable jansson support"
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
  option "with-retro-icon-emacs-logo",
         "Use a retro style icon by Luis Fernandes"
  option "with-retro-icon-gnu-head",
         "Use a retro style icon by Aurélio A. Heckert (GNU Project)"
  option "with-retro-icon-sink-bw",
         "Use a retro style icon by Unknown"
  option "with-retro-icon-sink",
         "Use a retro style icon by Erik Mugele"

  def self.get_resource_url(resource)
    if ENV['HOMEBREW_TRAVIS_BRANCH']
      "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/" + ENV['HOMEBREW_TRAVIS_BRANCH'] +  "/" + resource
    else
      "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/" + "master" + "/" + resource
    end
  end

  # When closing a frame, GNU Emacs automatically focuses another frame.
  # This re-focus has an additional side-effect: when closing a frame
  # from one desktop/space, one gets automatically moved to another
  # desktop/space where the refocused frame lives. The below patch
  # disable this behaviour.
  # Reference: https://github.com/d12frosted/homebrew-emacs-plus/issues/119
  if build.with? "no-frame-refocus"
    patch do
      url EmacsHeadAT27.get_resource_url("patches/0001-No-frame-refocus-cocoa.patch")
      sha256 "f004e6e65b969bbe83f5d6d53e4ba0e020631959da9ef9682479f7eeb09becd1"
    end
  end

  if build.with? "pdumper"
    patch do
      url EmacsHeadAT27.get_resource_url("patches/0003-Pdumper-size-increase.patch")
      sha256 "38440720948f5144399cc700da5e40872cf0011cf2654fbb571684429d2162a1"
    end
  end

  if build.with? "xwidgets"
    unless build.with? "cocoa"
      odie "--with-xwidgets is supported only on cocoa via xwidget webkit"
    end
    patch do
      url EmacsHeadAT27.get_resource_url("patches/0004-Xwidgets-webkit-in-cocoa-27.patch")
      sha256 "56406c03cbcea0d6d4c893074935404937cdae03259b8120b1b913971a948476"
    end
  end

  patch do
    url EmacsHeadAT27.get_resource_url("patches/0005-System-appearance-27.patch")
    sha256 "82252e2858a0eba95148661264e390eaf37349fec9c30881d3c1299bfaee8b21"
  end

  # All the patches are now downloaded unconditionally even if they
  # are not used in order to overcome the reinstall issue mentioned
  # here:
  # https://github.com/daviderestivo/homebrew-emacs-head/issues/28

  # Patches
  resource "0001-No-frame-refocus-cocoa" do
    url EmacsHeadAT27.get_resource_url("patches/0001-No-frame-refocus-cocoa.patch")
    sha256 "f004e6e65b969bbe83f5d6d53e4ba0e020631959da9ef9682479f7eeb09becd1"
  end

  resource "0003-Pdumper-size-increase" do
    url EmacsHeadAT27.get_resource_url("patches/0003-Pdumper-size-increase.patch")
    sha256 "38440720948f5144399cc700da5e40872cf0011cf2654fbb571684429d2162a1"
  end

  resource "0004-Xwidgets-webkit-in-cocoa-27" do
    url EmacsHeadAT27.get_resource_url("patches/0004-Xwidgets-webkit-in-cocoa-27.patch")
    sha256 "56406c03cbcea0d6d4c893074935404937cdae03259b8120b1b913971a948476"
  end

  resource "0005-System-appearance-27" do
    url EmacsHeadAT27.get_resource_url("patches/0005-System-appearance-27.patch")
    sha256 "82252e2858a0eba95148661264e390eaf37349fec9c30881d3c1299bfaee8b21"
  end

  # Icons
  resource "modern-icon-cg433n" do
    url EmacsHeadAT27.get_resource_url("icons/modern-icon-cg433n.icns")
    sha256 "9a0b101faa6ab543337179024b41a6e9ea0ecaf837fc8b606a19c6a51d2be5dd"
  end

  resource "modern-icon-sjrmanning" do
    url EmacsHeadAT27.get_resource_url("icons/modern-icon-sjrmanning.icns")
    sha256 "fc267d801432da90de5c0d2254f6de16557193b6c062ccaae30d91b3ada01ab9"
  end

  resource "modern-icon-sexy-v1" do
    url EmacsHeadAT27.get_resource_url("icons/modern-icon-sexy-v1.icns")
    sha256 "1ea8515d1f6f225047be128009e53b9aa47a242e95823c07a67c6f8a26f8d820"
  end

  resource "modern-icon-sexy-v2" do
    url EmacsHeadAT27.get_resource_url("icons/modern-icon-sexy-v2.icns")
    sha256 "ecdc902435a8852d47e2c682810146e81f5ad72ee3d0c373c936eb4c1e0966e6"
  end

  resource "modern-icon-papirus" do
    url EmacsHeadAT27.get_resource_url("icons/modern-icon-papirus.icns")
    sha256 "50aef07397ab17073deb107e32a8c7b86a0e9dddf5a0f78c4fcff796099623f8"
  end

  resource "modern-icon-pen" do
    url EmacsHeadAT27.get_resource_url("icons/modern-icon-pen.icns")
    sha256 "4fda050447a9803d38dd6fd7d35386103735aec239151714e8bf60bf9d357d3b"
  end

  resource "modern-icon-black-variant" do
    url EmacsHeadAT27.get_resource_url("icons/modern-icon-black-variant.icns")
    sha256 "a56a19fb5195925c09f38708fd6a6c58c283a1725f7998e3574b0826c6d9ac7e"
  end

  resource "modern-icon-nuvola" do
    url EmacsHeadAT27.get_resource_url("icons/modern-icon-nuvola.icns")
    sha256 "c3701e25ff46116fd694bc37d8ccec7ad9ae58bb581063f0792ea3c50d84d997"
  end

  resource "retro-icon-emacs-logo" do
    url EmacsHead.get_resource_url("icons/retro-icon-emacs-logo.icns")
    sha256 "0d7100faa68c17d012fe9309f9496b8d530946c324cb7598c93a4c425326ff97"
  end

  resource "retro-icon-gnu-head" do
    url EmacsHeadAT27.get_resource_url("icons/retro-icon-gnu-head.icns")
    sha256 "cfca2ff0214cff47167f634a5b9f8c402b488796f79ded23f93ec505f78b2f2f"
  end

  resource "retro-icon-sink-bw" do
    url EmacsHeadAT27.get_resource_url("icons/retro-icon-sink-bw.icns")
    sha256 "5cd836f86c8f5e1688d6b59bea4b57c8948026a9640257a7d2ec153ea7200571"
  end

  resource "retro-icon-sink" do
    url EmacsHeadAT27.get_resource_url("icons/retro-icon-sink.icns")
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
      imagemagick_lib_path = Formula["imagemagick@7"].opt_lib/"pkgconfig"
      ohai "ImageMagick PKG_CONFIG_PATH: ", imagemagick_lib_path
      ENV.prepend_path "PKG_CONFIG_PATH", imagemagick_lib_path
    else
      args << "--without-imagemagick"
    end

    if build.with? "jansson"
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
      ohai "GNU Emacs crash debug enabled. Appending `-g3` to CFLAGS..."
      ENV.append_to_cflags "-g3"
    end

    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
    system "./autogen.sh"

    if build.with? "cocoa"
      args << "--with-ns" << "--disable-ns-self-contained"  << "--with-harfbuzz"

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
        retro-icon-emacs-logo retro-icon-gnu-head
        retro-icon-sink-bw retro-icon-sink]).each do |icon|
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
