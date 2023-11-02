# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # If condition.
    #
    class IfCondition < AbstractToken
      attr_reader :left, :operator, :right

      def initialize(left:, operator:, right:, **)
        @type = :if_condition
        @left = left
        @operator = operator
        @right = right

        super
      end
    end
  end
end
