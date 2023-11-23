# frozen_string_literal: true

module ImgToScript
  #
  # Base class.
  #
  # Translates abstract tokens to more specific target language
  # statements.
  #
  class Translator
    #
    # Translate the abstract tokens to the target language tokens.
    #
    # @param [Array<AbstractToken>] abstract_tokens
    #
    # @param [Hash{ Symbol => Object }] **kwargs
    #   Options.
    #
    # @return [Array<Object>]
    #
    def translate(abstract_tokens, **kwargs)
      _translate(
        Array(abstract_tokens, **kwargs)
      )
    end
  end
end
