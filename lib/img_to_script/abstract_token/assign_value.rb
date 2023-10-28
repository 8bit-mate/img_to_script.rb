# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class AssignValue < AbstractToken
      attr_reader :expression

      def initialize(expression:, **)
        @type = :assign_value
        @expression = Array(expression)

        super
      end
    end
  end
end
