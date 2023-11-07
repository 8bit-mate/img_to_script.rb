# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Multiplication arithmetical operation.
    #
    class MathMult < AbstractToken
      attr_reader :left, :right

      def initialize(left:, right:, **)
        @type = AbsTokenType::MATH_MULT
        @left = left
        @right = right

        super
      end
    end
  end
end
