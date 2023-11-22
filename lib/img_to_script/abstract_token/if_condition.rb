# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # If condition.
    #
    class IfCondition < AbstractToken
      attr_reader :expression, :consequent

      def initialize(expression:, consequent:, **)
        @type = AbsTokenType::IF_CONDITION
        @expression = expression
        @consequent = consequent

        super
      end
    end
  end
end
