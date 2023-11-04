# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # If condition.
    #
    class IfCondition < AbstractToken
      attr_reader :left, :operator, :right, :consequent

      def initialize(left:, operator:, right:, consequent:, **)
        @type = :if_condition
        @left = left
        @operator = operator
        @right = right
        @consequent = consequent

        super
      end
    end
  end
end