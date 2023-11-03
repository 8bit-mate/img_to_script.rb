# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Wrap an expression into parenthesis.
    #
    class Parenthesis < AbstractToken
      attr_reader :expression

      def initialize(expression:, **)
        @type = :parenthesis
        @expression = expression

        super
      end
    end
  end
end
