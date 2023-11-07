# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Remark - a comment.
    #
    class Remark < AbstractToken
      attr_reader :text

      def initialize(text:, **)
        @type = AbsTokenType::REMARK
        @text = text

        super
      end
    end
  end
end
