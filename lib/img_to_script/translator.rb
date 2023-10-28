# frozen_string_literal: true

module ImgToScript
  module Translator
    class Translator
      def translate(input)
        _translate(
          Array(input)
        )
      end
    end
  end
end
