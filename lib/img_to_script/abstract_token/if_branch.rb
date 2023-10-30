# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # If condition.
    #
    class IfBranch < AbstractToken
      attr_reader :left, :operator, :right

      def initialize(left:, operator:, right:, **)
        @type = :if_branch
        @left = left
        @operator = operator
        @right = right

        super
      end
    end
  end
end
