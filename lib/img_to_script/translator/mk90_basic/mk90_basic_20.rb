# frozen_string_literal: true

module ImgToScript
  module Translator
    module MK90Basic
      class MK90Basic20 < MK90Basic
        private

        # MK90 BASIC v2.0 - doesn't requires "LET" keyword
        def _assign_value(token)
          LanguageToken::BasicToken.new(
            keyword: "",
            args: token.expression,
            separator: "",
            require_nl: token.require_nl,
            sliceable: false
          )
        end
      end
    end
  end
end
