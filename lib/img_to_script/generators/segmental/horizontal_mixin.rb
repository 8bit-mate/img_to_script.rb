# frozen_string_literal: true

module ImgToScript
  module Generators
    module Segmental
      #
      # Methods specific to the horizontal scan lines.
      #
      module HorizontalMixin
        private

        #
        # Return the segment's coordinates x0, y0, x1, y1.
        #
        # Formatted for the horizontal scan lines.
        #
        # @param [Integer] segment_length
        #
        # @return [Hash{ Symbol => Integer }]
        #
        def _segment_coordinates(segment_length)
          {
            x0: @major_axis + @x_offset,
            y0: @minor_axis + @y_offset,
            x1: @major_axis + @x_offset + segment_length - 1,
            y1: @minor_axis + @y_offset
          }
        end
      end
    end
  end
end
