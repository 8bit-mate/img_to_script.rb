# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Assign value to a variable.
    #
    class AssignValue < AbstractToken
      attr_reader :left, :right

      def initialize(left:, right:, **)
        @type = :assign_value
        @left = left
        @right = right

        super
      end
    end
  end
end
