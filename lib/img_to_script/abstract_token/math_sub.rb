# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Subtraction arithmetical operation.
    #
    class MathSub < AbstractToken
      attr_reader :left, :right

      def initialize(left:, right:, **)
        @type = :math_sub
        @left = left
        @right = right

        super
      end
    end
  end
end
