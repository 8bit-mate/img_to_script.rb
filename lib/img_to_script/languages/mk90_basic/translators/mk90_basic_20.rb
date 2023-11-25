# frozen_string_literal: true

module ImgToScript
  module Languages
    module MK90Basic
      module Translators
        #
        # Translates abstract tokens to the MK90 BASIC v.2.0 statements.
        #
        class MK90Basic20 < Translator
          private

          # MK90 BASIC v2.0 - doesn't require the "LET" keyword
          def _assign_value(token)
            MK90BasicToken.new(
              keyword: "",
              args: _translate_arguments([token.left, "=", token.right]),
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end
        end
      end
    end
  end
end
