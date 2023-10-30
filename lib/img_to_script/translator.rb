# frozen_string_literal: true

module ImgToScript
  module Translator
    #
    # Translates abstract tokens to more specific target language
    # statements.
    #
    class Translator
      def translate(input)
        _translate(
          Array(input)
        )
      end
    end
  end
end
