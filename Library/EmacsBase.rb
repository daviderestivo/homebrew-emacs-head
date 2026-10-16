require_relative "../Library/ResourcesResolver"
require_relative "../Library/Icons"

class EmacsBase < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"

  # Install Assets.car sidecar file for macOS Tahoe icon support
  # This enables custom icons to work properly with macOS 26+ Tahoe system
  # which requires Assets.car files instead of traditional .icns files
  def install_tahoe_assets_car(icons_dir, selected_icon)
    return if selected_icon.nil?

    # Check if running on macOS 26+ (Tahoe)
    system_version = `sw_vers -productVersion`.strip
    major_version = system_version.split('.').first.to_i

    if major_version < 26
      # Use traditional .icns for macOS < 26 (pre-Tahoe)
      ohai "Installing traditional .icns icon for macOS #{system_version}"
      return
    end

    ohai "Installing Assets.car for macOS 26+ Tahoe support"

    car_file = "#{HOMEBREW_REPOSITORY}/Library/Taps/daviderestivo/homebrew-emacs-head/icons/macos-26+/#{selected_icon}.car"

    if File.exist?(car_file)
      # Install the pre-compiled Assets.car file
      system "cp", car_file, "#{icons_dir}/Assets.car"
      ohai "Installed Assets.car for '#{selected_icon}' icon"

      # Update Info.plist for Tahoe compatibility
      plist = "#{prefix}/Emacs.app/Contents/Info.plist"
      system "/usr/libexec/PlistBuddy -c 'Delete :CFBundleIconFile' '#{plist}' 2>/dev/null || true"
      system "/usr/libexec/PlistBuddy -c 'Delete :CFBundleIconName' '#{plist}' 2>/dev/null || true"
      system "/usr/libexec/PlistBuddy -c 'Add :CFBundleIconName string #{selected_icon}' '#{plist}'"
      system "touch '#{prefix}/Emacs.app'"

      ohai "Updated Info.plist (CFBundleIconName=#{selected_icon}, removed CFBundleIconFile)"
    else
      opoo "Assets.car not found for '#{selected_icon}' at: #{car_file}"
      opoo "Icon will use fallback .icns format (may appear in 'icon jail' on macOS 26+)"
      opoo "Run 'python3 Library/generate_tahoe_assets_car.py' to generate Assets.car files"
    end
  end

  def self.load_icons
    ICONS.each do |icon, data|
      sha = data[0]
      comment = data[1]
      option "with-#{icon}", comment
      if build.with? "#{icon}"
        resource "#{icon}" do
          url ResourcesResolver.get_resource_url("icons/macos-legacy/" + icon + ".icns")
          sha256 sha
        end
      end
    end
  end

  # post_install_steps can only run a literal command and knows nothing about
  # the tap checkout. The launcher must be self-contained because in CI or
  # when installing from a bottle, the tap checkout may not exist.
  #
  # We embed a minimal Ruby script directly in the launcher that handles
  # the install-info task without external dependencies.
  def install_postinstall_launcher
    libexec.mkpath
    launcher = libexec/"emacs-head-postinstall"
    launcher.write <<~'LAUNCHER'
      #!/bin/bash
      # Self-contained post-install script for emacs-head formulas.
      # Embedded at install time to work without tap checkout (bottles, CI).
      set -euo pipefail

      # Find a Ruby interpreter
      ruby=""
      for candidate in \
          "${HOMEBREW_RUBY_PATH:-}" \
          "${HOMEBREW_PREFIX:-/opt/homebrew}/Library/Homebrew/vendor/portable-ruby/current/bin/ruby" \
          /usr/local/Homebrew/Library/Homebrew/vendor/portable-ruby/current/bin/ruby \
          /usr/bin/ruby; do
        if [[ -n "$candidate" && -x "$candidate" ]]; then
          ruby="$candidate"
          break
        fi
      done

      if [[ -z "$ruby" ]]; then
        echo "Warning: no ruby found for emacs-head post-install, skipping info registration" >&2
        exit 0
      fi

      exec "$ruby" - "$@" <<'RUBY'
      require "optparse"

      options = {}
      OptionParser.new do |opts|
        opts.on("--prefix PREFIX") { |v| options[:prefix] = v }
        opts.on("--install-info") { options[:install_info] = true }
      end.parse!

      if options[:install_info] && options[:prefix]
        info_dir = File.join(options[:prefix], "share", "info", "emacs")
        if Dir.exist?(info_dir)
          Dir.glob(File.join(info_dir, "*.info{,.gz}")).each do |f|
            puts "Installing info: #{File.basename(f)}"
            system("install-info", "--info-dir=#{info_dir}", f)
          end
        end
      end
      RUBY
    LAUNCHER
    launcher.chmod 0755
  end
end
