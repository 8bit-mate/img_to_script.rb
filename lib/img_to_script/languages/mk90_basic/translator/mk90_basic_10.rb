# frozen_string_literal: true

module ImgToScript
  module Languages
    module MK90Basic
      module Translator
        #
        # Translates abstract tokens to the MK90 BASIC v.1.0 statements.
        #
        class MK90Basic10 < Translator
          private

          # MK90 BASIC v1.0 - requires the "LET" keyword
          def _assign_value(token)
            MK90BasicToken.new(
              keyword: "LET",
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
