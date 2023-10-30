# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Remark - a comment.
    #
    class Remark < AbstractToken
      attr_reader :time

      def initialize(text:, **)
        @type = :remark
        @text = text

        super
      end
    end
  end
end
