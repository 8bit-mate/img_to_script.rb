# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # >.
    #
    class SignGreaterThan < AbstractToken
      def initialize(**)
        @type = AbsTokenType::SIGN_GREATER_THAN

        super
      end
    end
  end
end
