# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class DrawPixelByAbsCoords < AbstractToken
      attr_reader :x, :y

      def initialize(x:, y:, **)
        @x = x
        @y = y
        @type = :draw_pixel_by_abs_coords

        super
      end
    end
  end
end
