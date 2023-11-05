# frozen_string_literal: true

module ImgToScript
  module Generator
    module Segmental
      module VerticalMixin
        private

        def _generate
          _transpose

          super
        end

        #
        # Return the segment's coordinates x0, y0, x1, y1.
        #
        # Formatted for the vertical scan lines.
        #
        # @param [Integer] segment_length
        #
        # @return [Hash{ Symbol => Integer }]
        #
        def _segment_coordinates(segment_length)
          {
            x0: @minor_axis + @x_offset,
            y0: @major_axis + @y_offset,
            x1: @minor_axis + @x_offset,
            y1: @major_axis + @y_offset + segment_length - 1
          }
        end
      end
    end
  end
end
