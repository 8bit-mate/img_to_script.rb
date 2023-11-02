# frozen_string_literal: true

module ImgToScript
  module Generator
    module RunLengthEncoding
      #
      # RLE - vertical scanlines.
      #
      class Vertical < RunLengthEncoding
        private

        def _generate
          _transpose_image
          @pixels = @image.get_pixels(0, 0, @image.width, @image.height)
          _encode_pixels
          #_append_decoder

          @tokens
        end

        def _append_decoder
          @image_size = @image.width + @y_offset
          @segment_size = @image_size - 1

          @major_axis_symbol = "Y"
          @minor_axis_symbol = "X"

          @major_axis_value = @y_offset

          @part_line_pattern = "DRAWDX,Y,X,Y+S-1"
          @full_line_pattern = "DRAWDX,Y,X,#{@segment_size}"

          super
        end
      end
    end
  end
end
