# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Addition arithmetical operation.
    #
    class MathAdd < AbstractToken
      attr_reader :left, :right

      def initialize(left:, right:, **)
        @type = :math_add
        @left = left
        @right = right

        super
      end
    end
  end
end
