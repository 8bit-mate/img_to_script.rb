# frozen_string_literal: true

require "dry/system"
require "logger"
require "run_length_encoding_rb"
require "zeitwerk"

require_relative "img_to_script/container"
require_relative "img_to_script/version"

# loader = Zeitwerk::Loader.for_gem
# loader.setup

# p loader

module ImgToScript
  class Error < StandardError; end
  # Your code goes here...

  Container.finalize!
end
