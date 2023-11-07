# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Wrap an expression into parentheses.
    #
    class Parentheses < AbstractToken
      attr_reader :expression

      def initialize(expression:, **)
        @type = AbsTokenType::PARENTHESES
        @expression = expression

        super
      end
    end
  end
end
