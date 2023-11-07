# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Move point to the (x, y) position (in the absolute coordinates).
    #
    class MovePointToAbsCoords < AbstractToken
      attr_reader :x, :y

      def initialize(x:, y:, **)
        @x = x
        @y = y
        @type = AbsTokenType::MOVE_POINT_TO_ABS_COORDS

        super
      end
    end
  end
end
