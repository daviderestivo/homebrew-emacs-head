# coding: utf-8
class EmacsHead < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-26.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-26.3.tar.xz"
  sha256 "4d90e6751ad8967822c6e092db07466b9d383ef1653feb2f95c93e7de66d3485"
  version "26.3"
  revision 1

  bottle do
    rebuild 9
    root_url "https://dl.bintray.com/daviderestivo/homebrew-emacs-head"
    sha256 "3437cca427a3204f5bd08eaf76792f459417a24597633b8500b911eaf555def5" => :high_sierra
    sha256 "c29dc5503d61b92af0d0b7e8eae0e92cf3e65d01eb8d653588a5f3d6be690f59" => :mojave
    sha256 "10c304f5dba3b25013140054320d5421e2e40eef8e5922603ba152a67975fa59" => :catalina
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "librsvg"
  depends_on "libxml2"
  depends_on "dbus" => :optional
  depends_on "mailutils" => :optional
  # GNU Emacs 26.x does not support ImageMagick 7:
  # Reported on 2017-03-04: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=25967
  depends_on "imagemagick@6" => :recommended

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
  option "with-multicolor-fonts",
         "Enable multicolor fonts on macOS"
  option "without-modules",
         "Disable dynamic modules support"
  option "with-no-frame-refocus",
         "Disables frame re-focus (i.e. closing one frame does not refocus another one)"
  option "without-libxml2",
         "Disable libxml2 support"
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

  def self.get_resource_url(resource)
    if ENV['HOMEBREW_TRAVIS_BRANCH']
      "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/" + ENV['HOMEBREW_TRAVIS_BRANCH'] +  "/" + resource
    else
      "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/" + "master" + "/" + resource
    end
  end

  # https://github.com/emacs-mirror/emacs/commit/888ffd960c06d56a409a7ff15b1d930d25c56089
  patch do
    url EmacsHead.get_resource_url("patches/0006-Fix-unexec.patch")
    sha256 "a1fcfe8020301733a3846cf85b072b461b66e26d15b0154b978afb7a4ec3346b"
  end

  # When closing a frame, GNU Emacs automatically focuses another frame.
  # This re-focus has an additional side-effect: when closing a frame
  # from one desktop/space, one gets automatically moved to another
  # desktop/space where the refocused frame lives. The below patch
  # disable this behaviour.
  # Reference: https://github.com/d12frosted/homebrew-emacs-plus/issues/119
  if build.with? "no-frame-refocus"
    patch do
      url EmacsHead.get_resource_url("patches/0001-No-frame-refocus-cocoa.patch")
      sha256 "f004e6e65b969bbe83f5d6d53e4ba0e020631959da9ef9682479f7eeb09becd1"
    end
  end

  # Enable multicolor-fonts support
  if  build.with? "multicolor-fonts"
    patch do
      url EmacsHead.get_resource_url("patches/0002-Patch-multicolor-font.patch")
      sha256 "5af2587e986db70999d1a791fca58df027ccbabd75f45e4a2af1602c75511a8c"
    end
  end

  # Patches
  resource "0001-No-frame-refocus-cocoa" do
    url EmacsHead.get_resource_url("patches/0001-No-frame-refocus-cocoa.patch")
    sha256 "f004e6e65b969bbe83f5d6d53e4ba0e020631959da9ef9682479f7eeb09becd1"
  end

  resource "0002-Patch-multicolor-font" do
    url EmacsHead.get_resource_url("patches/0002-Patch-multicolor-font.patch")
    sha256 "5af2587e986db70999d1a791fca58df027ccbabd75f45e4a2af1602c75511a8c"
  end

  resource "0006-Fix-unexec" do
    url EmacsHead.get_resource_url("patches/0006-Fix-unexec.patch")
    sha256 "a1fcfe8020301733a3846cf85b072b461b66e26d15b0154b978afb7a4ec3346b"
  end

  # Icons
  resource "modern-icon-cg433n" do
    url EmacsHead.get_resource_url("icons/modern-icon-cg433n.icns")
    sha256 "9a0b101faa6ab543337179024b41a6e9ea0ecaf837fc8b606a19c6a51d2be5dd"
  end

  resource "modern-icon-sjrmanning" do
    url EmacsHead.get_resource_url("icons/modern-icon-sjrmanning.icns")
    sha256 "fc267d801432da90de5c0d2254f6de16557193b6c062ccaae30d91b3ada01ab9"
  end

  resource "modern-icon-sexy-v1" do
    url EmacsHead.get_resource_url("icons/modern-icon-sexy-v1.icns")
    sha256 "1ea8515d1f6f225047be128009e53b9aa47a242e95823c07a67c6f8a26f8d820"
  end

  resource "modern-icon-sexy-v2" do
    url EmacsHead.get_resource_url("icons/modern-icon-sexy-v2.icns")
    sha256 "ecdc902435a8852d47e2c682810146e81f5ad72ee3d0c373c936eb4c1e0966e6"
  end

  resource "modern-icon-papirus" do
    url EmacsHead.get_resource_url("icons/modern-icon-papirus.icns")
    sha256 "50aef07397ab17073deb107e32a8c7b86a0e9dddf5a0f78c4fcff796099623f8"
  end

  resource "modern-icon-pen" do
    url EmacsHead.get_resource_url("icons/modern-icon-pen.icns")
    sha256 "4fda050447a9803d38dd6fd7d35386103735aec239151714e8bf60bf9d357d3b"
  end

  resource "modern-icon-nuvola" do
    url EmacsHead.get_resource_url("icons/modern-icon-nuvola.icns")
    sha256 "c3701e25ff46116fd694bc37d8ccec7ad9ae58bb581063f0792ea3c50d84d997"
  end

  resource "modern-icon-black-variant" do
    url EmacsHead.get_resource_url("icons/modern-icon-black-variant.icns")
    sha256 "a56a19fb5195925c09f38708fd6a6c58c283a1725f7998e3574b0826c6d9ac7e"
  end

  resource "retro-icon-gnu-head" do
    url EmacsHead.get_resource_url("icons/retro-icon-gnu-head.icns")
    sha256 "cfca2ff0214cff47167f634a5b9f8c402b488796f79ded23f93ec505f78b2f2f"
  end

  resource "retro-icon-sink-bw" do
    url EmacsHead.get_resource_url("icons/retro-icon-sink-bw.icns")
    sha256 "5cd836f86c8f5e1688d6b59bea4b57c8948026a9640257a7d2ec153ea7200571"
  end

  resource "retro-icon-sink" do
    url EmacsHead.get_resource_url("icons/retro-icon-sink.icns")
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
      imagemagick_lib_path = Formula["imagemagick@6"].opt_lib/"pkgconfig"
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

    # Read https://github.com/emacs-mirror/emacs/blob/master/etc/DEBUG
    # for more information
    if build.with? "crash-debug"
      args << "--disable-silent-rules"
      ohai "GNU Emacs crash debug enabled. Appending `-g3` to CFLAGS..."
      ENV.append_to_cflags "-g3"
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

      GNU Emacs 27 and GNU Emacs 28 now live in separate formulas.
      Please use emacs-head@27 or emacs-head@28 formulas if you wish
      to install them:

        $ brew install emacs-head@27 [options]

        or

        $ brew install emacs-head@28 [options]

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
