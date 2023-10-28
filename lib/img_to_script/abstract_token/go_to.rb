# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class GoTo < AbstractToken
      attr_accessor :line

      def initialize(line:, **)
        @line = line
        @type = :go_to
        super
      end
    end
  end
end
