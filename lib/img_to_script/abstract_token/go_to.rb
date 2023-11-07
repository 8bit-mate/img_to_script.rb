# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Go to BASIC line.
    #
    class GoTo < AbstractToken
      attr_reader :line

      def initialize(line:, **)
        @type = AbsTokenType::GO_TO
        @line = line

        super
      end
    end
  end
end
