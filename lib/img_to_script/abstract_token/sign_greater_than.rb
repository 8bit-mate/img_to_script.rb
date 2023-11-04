# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # >.
    #
    class SignGreaterThan < AbstractToken
      def initialize(**)
        @type = :sign_greater_than

        super
      end
    end
  end
end
