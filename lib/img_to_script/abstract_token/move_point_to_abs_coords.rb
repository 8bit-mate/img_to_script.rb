# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class MovePointToAbsCoords < AbstractToken
      attr_reader :x, :y

      def initialize(x:, y:, **)
        @x = x
        @y = y
        @type = :move_point_to_abs_coords
        
        super
      end
    end
  end
end
