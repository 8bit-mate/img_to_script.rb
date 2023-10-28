# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class DrawLineByAbsCoords < AbstractToken
      attr_accessor :x0, :y0, :x1, :y1

      def initialize(x0:, y0:, x1:, y1:, **)
        @x0 = x0
        @y0 = y0
        @x1 = x1
        @y1 = y1
        @type = :draw_line_by_abs_coords
        super
      end
    end
  end
end
