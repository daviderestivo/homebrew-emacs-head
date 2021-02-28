# coding: utf-8
class EmacsHeadAT28 < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  version "28.0.50"
  revision 1

  depends_on "autoconf"   => :build
  depends_on "coreutils" => :build
  depends_on "gnu-sed"    => :build
  depends_on "texinfo"    => :build
  depends_on "automake"   => :build
  depends_on "cmake"      => :build
  depends_on "pkg-config" => :build
  depends_on "gcc"        => :build
  depends_on "giflib"
  depends_on "gnutls"
  depends_on "librsvg"
  depends_on "libxml2"
  depends_on "jansson"
  depends_on "dbus"      => :optional
  depends_on "mailutils" => :optional
  # GNU Emacs 28.x does support ImageMagick 7
  depends_on "imagemagick@7" => :recommended

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
  option "with-modern-icon-sjrmanning",
         "Use a modern style icon by @Sjrmanning"
  option "with-modern-icon-asingh4242",
         "Use a modern style icon by Asingh4242"
  option "with-modern-icon-paper-icons",
         "Use a modern style icon by Sam Hewitt"
  option "with-modern-icon-azhilin",
         "Use a modern style icon by Andrew Zhilin"
  option "with-modern-icon-mzaplotnik",
         "Use a modern style icon by Matjaz Zaplotnik"
  option "with-modern-icon-bananxan",
         "Use a modern style icon by BananXan"
  option "with-modern-icon-vscode",
         "Use a modern style icon by @Vdegenne"
  option "with-modern-icon-sexy-v1",
         "Use a modern style icon by Emacs is Sexy (v1)"
  option "with-modern-icon-sexy-v2",
         "Use a modern style icon by Emacs is Sexy (v2)"
  option "with-modern-icon-cg433n",
         "Use a modern style icon by @Cg433n"
  option "with-modern-icon-purple",
         "Use a modern style icon by Nicolas Petton"
  option "with-modern-icon-yellow",
         "Use a modern style icon by Unknown"
  option "with-modern-icon-orange",
         "Use a modern style icon by Omar Jair Purata Funes"
  option "with-modern-icon-papirus",
         "Use a modern style icon by Papirus Development Team"
  option "with-modern-icon-pen",
         "Use a modern style icon by Kentaro Ohkouchi"
  option "with-modern-icon-pen-3d",
         "Use a modern style icon by Unknown"
  option "with-modern-icon-pen-lds56",
         "Use a modern style icon by Lds56"
  option "with-modern-icon-pen-black",
         "Use a modern style icon by Cayetano Santos"
  option "with-modern-icon-black-variant",
         "Use a modern style icon by BlackVariant"
  option "with-modern-icon-purple-flat",
         "Use a modern style icon by Jeremiah Foster"
  option "with-modern-icon-spacemacs",
         "Use a modern style icon by Nasser Alshammari (Spacemacs Logo)"
  option "with-modern-icon-alecive-flatwoken",
         "Use a modern style icon by Alessandro Roncone"
  option "with-modern-icon-elrumo1",
         "Use a modern style icon by Elias Ruiz Monserrat"
  option "with-modern-icon-elrumo2",
         "Use a modern style icon by Elias Ruiz Monserrat"
  option "with-modern-icon-bokehlicia-captiva",
         "Use a modern style icon by Bokehlicia"
  option "with-modern-icon-nuvola",
         "Use a modern style icon by David Vignoni (Nuvola Icon Theme)"
  option "with-modern-icon-black-gnu-head",
         "Use a modern style icon by Aha-Soft"
  option "with-modern-icon-black-dragon",
         "Use a modern style icon by Osike"
  option "with-modern-emacs-icon1",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-icon2",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-icon3",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-icon4",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-icon5",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-icon6",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-icon7",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-icon8",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-icon9",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-card-blue-deep",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-card-british-racing-green",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-card-carmine",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-emacs-card-green",
         "Use a modern style icon by Jasonm23 (Emacs Fodder)"
  option "with-modern-icon-doom",
         "Use a modern style icon by Jay Zawrotny"
  option "with-modern-icon-doom3",
         "Use a modern style icon by Jay Zawrotny"
  option "with-modern-icon-doom-cacodemon",
         "Use a modern style icon by Christian Westrom"
  option "with-retro-icon-emacs-logo",
         "Use a retro style icon by Luis Fernandes"
  option "with-retro-icon-gnu-head",
         "Use a retro style icon by Aurélio A. Heckert (GNU Project)"
  option "with-retro-icon-gnu-meditate-levitate",
         "Use a retro style icon by Nevrax Design Team"
  option "with-retro-icon-sink-bw",
         "Use a retro style icon by Unknown"
  option "with-retro-icon-sink",
         "Use a retro style icon by Erik Mugele"

  if build.with? "native-comp"
    url "https://github.com/emacs-mirror/emacs.git", :branch => "feature/native-comp"
    depends_on "gmp"       => :build
    depends_on "libjpeg"   => :build
    depends_on "libgccjit" => :reccomended
  else
    url "https://github.com/emacs-mirror/emacs.git"
  end

  def self.get_resource_url(resource)
    if ENV['HOMEBREW_GITHUB_REF']
      branch = ENV['HOMEBREW_GITHUB_REF'].sub("refs/heads/", "")
      "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/" + branch +  "/" + resource
    else
      "https://raw.githubusercontent.com/daviderestivo/homebrew-emacs-head/" + "master" + "/" + resource
    end
  end

  # All the patches and the icons have been declared as resources.
  # They are downloaded unconditionally even if not used in order to
  # overcome the reinstall issue mentioned here:
  # https://github.com/daviderestivo/homebrew-emacs-head/issues/28

  # Patches
  resource "0001-No-frame-refocus-cocoa" do
    url EmacsHeadAT28.get_resource_url("patches/0001-No-frame-refocus-cocoa.patch")
    sha256 "f004e6e65b969bbe83f5d6d53e4ba0e020631959da9ef9682479f7eeb09becd1"
  end

  resource "0003-Pdumper-size-increase" do
    url EmacsHeadAT28.get_resource_url("patches/0003-Pdumper-size-increase.patch")
    sha256 "38440720948f5144399cc700da5e40872cf0011cf2654fbb571684429d2162a1"
  end

  resource "0005-System-appearance" do
    url  EmacsHeadAT28.get_resource_url("patches/0005-System-appearance.patch")
    sha256 "22b541e2893171e45b54593f82a0f5d2c4e62b0e4497fc0351fc89108d6f0084"
  end

  resource "0008-Fix-window-role.patch" do
    url EmacsHeadAT28.get_resource_url("patches/0008-Fix-window-role.patch")
    sha256 "1f8423ea7e6e66c9ac6dd8e37b119972daa1264de00172a24a79a710efcb8130"
  end

  # Icons
  resource "modern-icon-sjrmanning" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-sjrmanning.icns")
    sha256 "fc267d801432da90de5c0d2254f6de16557193b6c062ccaae30d91b3ada01ab9"
  end

  resource "modern-icon-asingh4242" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-asingh4242.icns")
    sha256 "ff37bd9447550da54d90bfe5cb2173c93799d4c4d64f5a018cc6bfe6537517e4"
  end

  resource "modern-icon-paper-icons" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-paper-icons.icns")
    sha256 "209f7ea9e3b04d9b152e0580642e926d7e875bd1e33242616d266dd596f74c7a"
  end

  resource "modern-icon-azhilin" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-azhilin.icns")
    sha256 "ee803f2d7a9ddd4d73ebb0561014b60d65f96947aa33633846aa2addace7a97a"
  end

  resource "modern-icon-mzaplotnik" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-mzaplotnik.icns")
    sha256 "1f77c52d3dbcdb0b869f47264ff3c2ac9f411e92ec71061a09771b7feac2ecc6"
  end

  resource "modern-icon-bananxan" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-bananxan.icns")
    sha256 "d7b4396fe667e2792c8755f85455635908091b812921890c4b0076488c880afc"
  end

  resource "modern-icon-vscode" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-vscode.icns")
    sha256 "5cfe371a1bbfd30c8c0bd9dba525a0625036a4c699996fb302cde294d35d0057"
  end

  resource "modern-icon-sexy-v1" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-sexy-v1.icns")
    sha256 "1ea8515d1f6f225047be128009e53b9aa47a242e95823c07a67c6f8a26f8d820"
  end

  resource "modern-icon-sexy-v2" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-sexy-v2.icns")
    sha256 "ecdc902435a8852d47e2c682810146e81f5ad72ee3d0c373c936eb4c1e0966e6"
  end

  resource "modern-icon-cg433n" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-cg433n.icns")
    sha256 "9a0b101faa6ab543337179024b41a6e9ea0ecaf837fc8b606a19c6a51d2be5dd"
  end

  resource "modern-icon-purple" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-purple.icns")
    sha256 "249e0b9f5c4abba008c34bec4e787b9df114229ee91d2724865e2c4da5790e3b"
  end

  resource "modern-icon-yellow" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-yellow.icns")
    sha256 "b7c39da6494ee20d41ec11f473dec8ebcab5406a4adbf8e74b601c2325b5eb7d"
  end

  resource "modern-icon-orange" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-orange.icns")
    sha256 "e2f5d733f97b0a92a84b5fe0bcd4239937d8cb9de440d96e298b38d052e21b43"
  end

  resource "modern-icon-papirus" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-papirus.icns")
    sha256 "1ec7c6ddcec97e6182e4ffce6220796ee1cb0b5e00da40848713ce333337222b"
  end

  resource "modern-icon-pen" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-pen.icns")
    sha256 "4fda050447a9803d38dd6fd7d35386103735aec239151714e8bf60bf9d357d3b"
  end

  resource "modern-icon-pen-3d" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-pen-3d.icns")
    sha256 "ece20b691c8d61bb56e3a057345c1340c6c29f58f7798bcdc929c91d64e5599b"
  end

  resource "modern-icon-pen-lds56" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-pen-lds56.icns")
    sha256 "dd88972e2dd2d4dfd462825212967b33af3ec1cb38f2054a23db2ea657baa8a0"
  end

  resource "modern-icon-pen-black" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-pen-black.icns")
    sha256 "c4bf4de8aaf075d82fc363afbc480a1b8855776d0b61c3fc3a75e8063d7b5c27"
  end

  resource "modern-icon-black-variant" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-black-variant.icns")
    sha256 "a56a19fb5195925c09f38708fd6a6c58c283a1725f7998e3574b0826c6d9ac7e"
  end

  resource "modern-icon-purple-flat" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-purple-flat.icns")
    sha256 "8468f0690efe308a4fe85c66bc3ed4902f8f984cf506318d5ef5759aa20d8bc6"
  end

  resource "modern-icon-spacemacs" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-spacemacs.icns")
    sha256 "9ee9464fcd436b6db676977143a306a572d0459dc882742e9bbc55a18f8940b9"
  end

  resource "modern-icon-alecive-flatwoken" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-alecive-flatwoken.icns")
    sha256 "779373dd240aa532248ac2918da3db0207afaa004f157fa790110eef2e216ccd"
  end

  resource "modern-icon-elrumo1" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-elrumo1.icns")
    sha256 "f0900babe3d36b4660a4757ac1fa8abbb6e2978f4a4f2d18fa3c7ab1613e9d42"
  end

  resource "modern-icon-elrumo2" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-elrumo2.icns")
    sha256 "0fbdab5172421d8235d9c53518dc294efbb207a4903b42a1e9a18212e6bae4f4"
  end

  resource "modern-icon-bokehlicia-captiva" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-bokehlicia-captiva.icns")
    sha256 "8534f309b72812ba99375ebe2eb1d814bd68aec8898add2896594f4eecb10238"
  end

  resource "modern-icon-nuvola" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-nuvola.icns")
    sha256 "c3701e25ff46116fd694bc37d8ccec7ad9ae58bb581063f0792ea3c50d84d997"
  end

  resource "modern-icon-black-gnu-head" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-black-gnu-head.icns")
    sha256 "9ac25aaa986b53d268e94d24bb878689c290b237a7810790dead9162e6ddf54b"
  end

  resource "modern-icon-black-dragon" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-black-dragon.icns")
    sha256 "2844b2e57f87d9bd183c572d24c8e5a5eb8ecfc238a8714d2c6e3ea51659c92a"
  end

  resource "modern-icon-emacs-icon1" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-EmacsIcon1.icns")
    sha256 "50dbaf2f6d67d7050d63d987fe3743156b44556ab42e6d9eee92248c56011bd0"
  end

  resource "modern-icon-emacs-icon2" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-EmacsIcon2.icns")
    sha256 "8d63589b0302a67f13ab94b91683a8ad7c2b9e880eabe008056a246a22592963"
  end

  resource "modern-icon-emacs-icon3" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-EmacsIcon3.icns")
    sha256 "80dd2a4776739a081e0a42008e8444c729d41ba876b19fa9d33fde98ee3e0ebf"
  end

  resource "modern-icon-emacs-icon4" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-EmacsIcon4.icns")
    sha256 "8ce646ca895abe7f45029f8ff8f5eac7ab76713203e246b70dea1b8a21a6c135"
  end

  resource "modern-icon-emacs-icon5" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-EmacsIcon5.icns")
    sha256 "ca415df7ad60b0dc495626b0593d3e975b5f24397ad0f3d802455c3f8a3bd778"
  end

  resource "modern-icon-emacs-icon6" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-EmacsIcon6.icns")
    sha256 "12a1999eb006abac11535b7fe4299ebb3c8e468360faf074eb8f0e5dec1ac6b0"
  end

  resource "modern-icon-emacs-icon7" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-EmacsIcon7.icns")
    sha256 "f5067132ea12b253fb4a3ea924c75352af28793dcf40b3063bea01af9b2bd78c"
  end

  resource "modern-icon-emacs-icon8" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-EmacsIcon8.icns")
    sha256 "d330b15cec1bcdfb8a1e8f8913d8680f5328d59486596fc0a9439b54eba340a0"
  end

  resource "modern-icon-emacs-icon9" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-EmacsIcon9.icns")
    sha256 "f58f46e5ef109fff8adb963a97aea4d1b99ca09265597f07ee95bf9d1ed4472e"
  end

  resource "modern-icon-emacs-card-blue-deep" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-emacs-card-blue-deep.icns")
    sha256 "6bdb17418d2c620cf4132835cfa18dcc459a7df6ce51c922cece3c7782b3b0f9"
  end

  resource "modern-icon-emacs-card-british-racing-green" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-emacs-card-british-racing-green.icns")
    sha256 "ddf0dff6a958e3b6b74e6371f1a68c2223b21e75200be6b4ac6f0bd94b83e1a5"
  end

  resource "modern-icon-emacs-card-carmine" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-emacs-card-carmine.icns")
    sha256 "4d34f2f1ce397d899c2c302f2ada917badde049c36123579dd6bb99b73ebd7f9"
  end

  resource "emacs-icon-card-green" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-emacs-card-green.icns")
    sha256 "f94ade7686418073f04b73937f34a1108786400527ed109af822d61b303048f7"
  end

  resource "emacs-icon-doom" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-doom.icns")
    sha256 "39378a10b3d7e804461eec8bb9967de0cec7b8f1151150bbe2ba16f21001722b"
  end

  resource "emacs-icon-doom3" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-doom3.icns")
    sha256 "3ac398d8d691687320d3a88cd8e634c8cfb7ca358bfe6c30108667f2486438b3"
  end

  resource "emacs-icon-doom-cacodemon" do
    url EmacsHeadAT28.get_resource_url("icons/modern-icon-doom-cacodemon.icns")
    sha256 "5a8d53896f72992bc7158aaaa47665df4009be646deee39af6f8e76893568728"
  end

  resource "retro-icon-emacs-logo" do
    url EmacsHeadAT28.get_resource_url("icons/retro-icon-emacs-logo.icns")
    sha256 "0d7100faa68c17d012fe9309f9496b8d530946c324cb7598c93a4c425326ff97"
  end

  resource "retro-icon-gnu-head" do
    url EmacsHeadAT28.get_resource_url("icons/retro-icon-gnu-head.icns")
    sha256 "cfca2ff0214cff47167f634a5b9f8c402b488796f79ded23f93ec505f78b2f2f"
  end

  resource "retro-icon-gnu-meditate-levitate" do
    url EmacsHeadAT28.get_resource_url("icons/retro-icon-gnu-meditate-levitate.icns")
    sha256 "5424582f0a4c1998aa91eb8185e1d41961cbc9605dbcea8a037c602587b14998"
  end

  resource "retro-icon-sink-bw" do
    url EmacsHeadAT28.get_resource_url("icons/retro-icon-sink-bw.icns")
    sha256 "5cd836f86c8f5e1688d6b59bea4b57c8948026a9640257a7d2ec153ea7200571"
  end

  resource "retro-icon-sink" do
    url EmacsHeadAT28.get_resource_url("icons/retro-icon-sink.icns")
    sha256 "be0ee790589a3e49345e1894050678eab2c75272a8d927db46e240a2466c6abc"
  end

  # When closing a frame, GNU Emacs automatically focuses another frame.
  # This re-focus has an additional side-effect: when closing a frame
  # from one desktop/space, one gets automatically moved to another
  # desktop/space where the refocused frame lives. The below patch
  # disable this behaviour.
  # Reference: https://github.com/d12frosted/homebrew-emacs-plus/issues/119
  if build.with? "no-frame-refocus"
    patch do
      url EmacsHeadAT28.get_resource_url("patches/0001-No-frame-refocus-cocoa.patch")
      sha256 "f004e6e65b969bbe83f5d6d53e4ba0e020631959da9ef9682479f7eeb09becd1"
    end
  end

  if build.with? "pdumper"
    patch do
      url EmacsHeadAT28.get_resource_url("patches/0003-Pdumper-size-increase.patch")
      sha256 "38440720948f5144399cc700da5e40872cf0011cf2654fbb571684429d2162a1"
    end
  end

  if build.with? "xwidgets"
    unless build.with? "cocoa"
      odie "--with-xwidgets is supported only on cocoa via xwidget webkit"
    end
  end

  patch do
    url EmacsHeadAT28.get_resource_url("patches/0005-System-appearance.patch")
    sha256 "22b541e2893171e45b54593f82a0f5d2c4e62b0e4497fc0351fc89108d6f0084"
  end

  patch do
    url EmacsHeadAT28.get_resource_url("patches/0008-Fix-window-role.patch")
    sha256 "1f8423ea7e6e66c9ac6dd8e37b119972daa1264de00172a24a79a710efcb8130"
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

      ENV['CFLAGS'] = [
        '-O2',
        '-march=native'
      ].compact.join(' ')

      ENV.append "CFLAGS", "-I#{Formula["gcc"].include}"

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
      imagemagick_lib_path = Formula["imagemagick@7"].opt_lib/"pkgconfig"
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
      system "make", "install"

      icons_dir = buildpath/"nextstep/Emacs.app/Contents/Resources"

      (%w[modern-icon-sjrmanning modern-icon-asingh4242
        modern-icon-paper-icons modern-icon-azhilin
        modern-icon-mzaplotnik modern-icon-bananxan modern-icon-vscode
        modern-icon-sexy-v1 modern-icon-sexy-v2 modern-icon-cg433n
        modern-icon-purple modern-icon-yellow modern-icon-orange
        modern-icon-papirus modern-icon-pen modern-icon-pen-3d
        modern-icon-pen-lds56 with-modern-icon-pen-black
        modern-icon-black-variant modern-icon-purple-flat
        modern-icon-spacemacs modern-icon-alecive-flatwoken
        modern-icon-elrumo1 modern-icon-elrumo2
        modern-icon-bokehlicia-captiva modern-icon-nuvola
        modern-icon-black-gnu-head modern-icon-black-dragon
        modern-icon-emacs-icon1 modern-icon-emacs-icon2
        modern-icon-emacs-icon3 modern-icon-emacs-icon4
        modern-icon-emacs-icon5 modern-icon-emacs-icon6
        modern-icon-emacs-icon7 modern-icon-emacs-icon8
        modern-icon-emacs-icon9 modern-icon-emacs-card-blue-deep
        modern-icon-emacs-card-british-racing-green
        modern-icon-emacs-card-carmine modern-icon-emacs-card-green
        modern-icon-doom modern-icon-doom3 modern-icon-doom-cacodemon
        retro-icon-emacs-logo retro-icon-gnu-head
        retro-icon-gnu-meditate-levitate retro-icon-sink-bw
        retro-icon-sink]).each do |icon|

        if build.with? icon
          rm "#{icons_dir}/Emacs.icns"
          resource(icon).stage do
            icons_dir.install Dir["*.icns*"].first => "Emacs.icns"
            ohai "Installing " + icon + " icon"
          end
        end
      end

      if build.with? "native-comp"
        contents_dir = buildpath/"nextstep/Emacs.app/Contents"
        contents_dir.install "native-lisp"
        contents_dir.install "lisp"

        # Change .eln files dylib ID to avoid that after the
        # post-install phase all of the *.eln files end up with the
        # same ID. See: https://github.com/Homebrew/brew/issues/9526
        # and https://github.com/Homebrew/brew/pull/10075
        Dir.glob(contents_dir/"native-lisp/*/*.eln").each do |f|
          fo = MachO::MachOFile.new(f)
          ohai "Change dylib_id of ELN files before post_install phase"
          fo.dylib_id = "#{contents_dir}/" + f
          fo.write!
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
