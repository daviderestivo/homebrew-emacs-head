require_relative "../Library/ResourcesResolver"
require_relative "../Library/Icons"

class EmacsBase < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"

  def self.load_icons
    ICONS.each do |icon, data|
      sha = data[0]
      comment = data[1]
      option "with-#{icon}", comment
      if build.with? "#{icon}"
        resource "#{icon}" do
          url ResourcesResolver.get_resource_url("icons/" + icon + ".icns")
          sha256 sha
        end
      end
    end
  end
end
