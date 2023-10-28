# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class IfBranch < AbstractToken
      attr_reader :left, :operator, :right

      def initialize(left:, operator:, right:, **)
        @left = left
        @operator = operator
        @right = right
        @type = :if_branch
        
        super
      end
    end
  end
end
