# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Right parenthesis.
    #
    class ParenthesisRight < AbstractToken
      def initialize(**)
        @type = :parenthesis_right

        super
      end
    end
  end
end
