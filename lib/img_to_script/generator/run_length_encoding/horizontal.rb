# frozen_string_literal: true

module ImgToScript
  module Generator
    module RunLengthEncoding
      #
      # RLE - horizontal scanlines.
      #
      class Horizontal < RunLengthEncoding
        private

        def _generate
          @pixels = @image.get_pixels(0, 0, @image.width, @image.height)
          _encode_pixels
          _append_decoder

          @tokens
        end

        def _append_decoder
          @image_size = @image.width + @x_offset
          @segment_size = @image_size - 1

          @major_axis_symbol = "X"
          @minor_axis_symbol = "Y"

          @major_axis_value = @x_offset

          @part_line_pattern = "DRAWDX,Y,X+S-1,Y"
          @full_line_pattern = "DRAWDX,Y,#{@segment_size},Y"

          super
        end
      end
    end
  end
end
