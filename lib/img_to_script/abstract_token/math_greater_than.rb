# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # left > right.
    #
    class MathGreaterThan < AbstractToken
      attr_reader :left, :right

      def initialize(left:, right:, **)
        @type = AbsTokenType::MATH_GREATER_THAN
        @left = left
        @right = right

        super
      end
    end
  end
end
