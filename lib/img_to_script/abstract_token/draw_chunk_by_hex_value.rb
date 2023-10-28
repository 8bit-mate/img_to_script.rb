# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class DrawChunkByHexValue < AbstractToken
      attr_reader :hex_values

      def initialize(hex_values:, **)
        @xhex_values = Array(hex_values)
        @type = :draw_chunk_by_hex_value
        super
      end
    end
  end
end
