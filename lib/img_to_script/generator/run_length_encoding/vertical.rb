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
          _transpose
          @pixels = @image.get_pixels(0, 0, @image.width, @image.height)
          _encode_pixels
          _append_decoder
        end

        def _append_decoder
          @image_size = @image.width + @y_offset
          @segment_size = @image_size - 1

          @major_axis_symbol = "Y"
          @minor_axis_symbol = "X"

          @major_axis_value = @y_offset

          @part_line_pattern = _part_line_pattern
          @full_line_pattern = _full_line_pattern

          super
        end

        #
        # Part-length line, i.e. a line that fills only
        # a part of the scan line.
        #
        # Formatted for the vertical scan lines.
        #
        def _part_line_pattern
          AbstractToken::DrawLineByAbsCoords.new(
            x0: "X",
            y0: "Y",
            x1: "X",
            y1: _y1_expression
          )
        end

        #
        # Expression to evaluate y1 point.
        #
        def _y1_expression
          AbstractToken::MathSub.new(
            left: AbstractToken::MathAdd.new(
              left: "Y",
              right: READ_VAR
            ),
            right: "1"
          )
        end

        #
        # Full-length line pattern, i.e. a line that fills
        # the whole scan line.
        #
        # Formatted for the vertical scan lines.
        #
        def _full_line_pattern
          AbstractToken::DrawLineByAbsCoords.new(
            x0: "X",
            y0: "Y",
            x1: "X",
            y1: @segment_size
          )
        end
      end
    end
  end
end
