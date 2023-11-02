# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Left parenthesis.
    #
    class ParenthesisLeft < AbstractToken
      def initialize(**)
        @type = :parenthesis_left

        super
      end
    end
  end
end
