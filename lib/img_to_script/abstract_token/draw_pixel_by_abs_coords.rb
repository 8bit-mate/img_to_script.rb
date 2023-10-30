# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Draw a pixel by absolute coordinates.
    #
    class DrawPixelByAbsCoords < AbstractToken
      attr_reader :x, :y

      def initialize(x:, y:, **)
        @type = :draw_pixel_by_abs_coords
        @x = x
        @y = y

        super
      end
    end
  end
end
