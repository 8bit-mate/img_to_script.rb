# frozen_string_literal: true

module ImgToScript
  #
  # Base class.
  #
  # Formatters format array of target language tokens to an
  # executable script.
  #
  # A formatter's responsibility is to label BASIC lines, put
  # separators between the statements' and their arguments, etc.
  #
  class Formatter
    attr_reader :script

    include Dry::Configurable

    #
    # Format an array of the language tokens to an executable script.
    #
    # @param [Array<Object>] tokens
    #   Translator's output.
    #
    # @param [Hash{ Symbol => Object }] **kwargs
    #   Options.
    #
    # @return [Array<String>]
    #   Formatted script.
    #
    def format(tokens, **kwargs)
      _format(tokens, **kwargs)
    end
  end
end
