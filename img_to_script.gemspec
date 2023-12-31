# frozen_string_literal: true

require_relative "lib/img_to_script/version"

Gem::Specification.new do |spec|
  spec.name = "img_to_script"
  spec.version = ImgToScript::VERSION
  spec.authors = ["8bit-mate"]
  spec.email = ["you@example.com"]

  spec.summary = "Converts images to executable scripts."
  spec.homepage = "https://github.com/8bit-mate/img_to_script.rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.files -= ["data/lain-mk90.jpg"]

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-system", "~> 1.0", ">= 1.0.1"
  spec.add_dependency "run_length_encoding_rb", "~> 1.0", ">= 1.0.0"
  spec.add_dependency "zeitwerk", "~> 2.6", ">= 2.6.12"

  spec.add_development_dependency "rmagick-bin_magick", "~> 0.2", ">= 0.2.0"
end
