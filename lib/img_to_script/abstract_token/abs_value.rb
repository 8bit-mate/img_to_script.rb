# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Absolute value (modulus).
    #
    class AbsValue < AbstractToken
      attr_reader :expression

      def initialize(expression:, **)
        @type = :abs_value
        @expression = Array(expression)

        super
      end
    end
  end
end
