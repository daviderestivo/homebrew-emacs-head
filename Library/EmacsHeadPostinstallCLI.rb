# frozen_string_literal: true

# CLI for emacs-head post-install steps.
# Called from scripts/emacs-head-postinstall via the libexec launcher.
module EmacsHeadPostinstallCLI
  module_function

  def run(argv)
    require "optparse"

    options = {}
    parser = OptionParser.new do |opts|
      opts.banner = "Usage: emacs-head-postinstall [options]"

      opts.on("--prefix PREFIX", "Formula prefix path") do |v|
        options[:prefix] = v
      end

      opts.on("--version VERSION", "Emacs major version") do |v|
        options[:version] = v
      end

      opts.on("--install-info", "Run install-info for info manuals") do
        options[:install_info] = true
      end

      opts.on("-h", "--help", "Show this help") do
        puts opts
        return 0
      end
    end

    begin
      parser.parse!(argv)
    rescue OptionParser::InvalidOption => e
      warn e.message
      warn parser
      return 1
    end

    unless options[:prefix]
      warn "Error: --prefix is required"
      warn parser
      return 1
    end

    prefix = options[:prefix]

    # Run install-info for all .info files in the emacs info directory
    if options[:install_info]
      run_install_info(prefix)
    end

    0
  end

  def run_install_info(prefix)
    info_dir = File.join(prefix, "share", "info", "emacs")
    return unless Dir.exist?(info_dir)

    # Match both .info and .info.gz files (Emacs installs gzipped info files)
    Dir.glob(File.join(info_dir, "*.info{,.gz}")) do |info_file|
      puts "Installing info: #{File.basename(info_file)}"
      system("install-info", "--info-dir=#{info_dir}", info_file)
    end
  end
end
