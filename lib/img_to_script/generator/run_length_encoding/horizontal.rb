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

          @part_line_pattern = AbstractToken::DrawLineByAbsCoords.new(
            x0: "X",
            y0: "Y",
            x1: AbstractToken::MathSub.new(
              left: AbstractToken::MathAdd.new(
                left: "X",
                right: READ_VAR,
                require_nl: false
              ),
              right: "1",
              require_nl: false
            ),
            y1: "Y",
            require_nl: false
          )

          @full_line_pattern = AbstractToken::DrawLineByAbsCoords.new(
            x0: "X",
            y0: "Y",
            x1: @segment_size,
            y1: "Y",
            require_nl: false
          )

          super
        end
      end
    end
  end
end
