# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Draw a line by absolute coordinates.
    #
    class DrawLineByAbsCoords < AbstractToken
      attr_reader :x0, :y0, :x1, :y1

      def initialize(x0:, y0:, x1:, y1:, **)
        @type = :draw_line_by_abs_coords
        @x0 = x0
        @y0 = y0
        @x1 = x1
        @y1 = y1

        super
      end
    end
  end
end
