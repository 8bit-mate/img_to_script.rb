# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Draw 8x1 px block of pixels encoded by a hex value.
    #
    class DrawChunkByHexValue < AbstractToken
      attr_reader :hex_values

      def initialize(hex_values:, **)
        @type = AbsTokenType::DRAW_CHUNK_BY_HEX_VALUE
        @hex_values = Array(hex_values)

        super
      end
    end
  end
end
