# frozen_string_literal: true

module ImgToScript
  module Translator
    module MK90Basic
      #
      # Translates abstract tokens to the MK90 BASIC v.1.0 statements.
      #
      class MK90Basic10 < MK90Basic
        private

        # MK90 BASIC v1.0 - requires "LET" keyword
        def _assign_value(token)
          LanguageToken::MK90BasicToken.new(
            keyword: "LET",
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
