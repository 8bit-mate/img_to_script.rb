# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Absolute value (modulus).
    #
    class AbsFunc < AbstractToken
      attr_reader :expression

      def initialize(expression:, **)
        @type = AbsTokenType::ABS_FUNC
        @expression = expression

        super
      end
    end
  end
end
