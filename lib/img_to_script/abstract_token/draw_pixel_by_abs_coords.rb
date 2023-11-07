# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Draw a pixel by absolute coordinates.
    #
    class DrawPixelByAbsCoords < AbstractToken
      attr_reader :x, :y

      def initialize(x:, y:, **)
        @type = AbsTokenType::DRAW_PIXEL_BY_ABS_COORDS
        @x = x
        @y = y

        super
      end
    end
  end
end
