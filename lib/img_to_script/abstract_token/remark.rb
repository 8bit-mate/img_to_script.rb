# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class Remark < AbstractToken
      attr_reader :time

      def initialize(text:, **)
        @text = text
        @type = :remark

        super
      end
    end
  end
end
