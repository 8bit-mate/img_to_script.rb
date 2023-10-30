# frozen_string_literal: true

module ImgToScript
  module Language
    module MK90Basic
      module Translator
        #
        # Translates abstract tokens to the MK90 BASIC v.2.0 statements.
        #
        class MK90Basic20 < Translator
          private

          # MK90 BASIC v2.0 - doesn't requires "LET" keyword
          def _assign_value(token)
            MK90BasicToken.new(
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
end