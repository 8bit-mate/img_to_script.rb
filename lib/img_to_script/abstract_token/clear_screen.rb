# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Clear screen.
    #
    class ClearScreen < AbstractToken
      def initialize(**)
        @type = AbsTokenType::CLEAR_SCREEN

        super
      end
    end
  end
end
