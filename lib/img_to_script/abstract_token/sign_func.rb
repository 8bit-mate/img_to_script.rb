# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Sign function.
    #
    class SignFunc < AbstractToken
      attr_reader :expression

      def initialize(expression:, **)
        @type = :sign_func
        @expression = Array(expression)

        super
      end
    end
  end
end
