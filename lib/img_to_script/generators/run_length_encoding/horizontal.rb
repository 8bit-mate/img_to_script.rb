# frozen_string_literal: true

module ImgToScript
  module Generators
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
        end

        def _append_decoder
          @image_size = @image.width + @x_offset
          @segment_size = @image_size - 1

          @major_axis_symbol = X_LBL
          @minor_axis_symbol = Y_LBL

          @major_axis_value = @x_offset

          @part_line_pattern = _part_line_pattern
          @full_line_pattern = _full_line_pattern

          super
        end

        #
        # Part-length line, i.e. a line that fills only
        # a part of the scan line.
        #
        # Formatted for the horizontal scan lines.
        #
        def _part_line_pattern
          AbstractToken::DrawLineByAbsCoords.new(
            x0: X_LBL,
            y0: Y_LBL,
            x1: _x1_expression,
            y1: Y_LBL
          )
        end

        #
        # Expression to evaluate x1 point.
        #
        def _x1_expression
          AbstractToken::MathSub.new(
            left: AbstractToken::MathAdd.new(
              left: X_LBL,
              right: READ_VAR
            ),
            right: 1
          )
        end

        #
        # Full-length line pattern, i.e. a line that fills
        # the whole scan line.
        #
        # Formatted for the horizontal scan lines.
        #
        def _full_line_pattern
          AbstractToken::DrawLineByAbsCoords.new(
            x0: X_LBL,
            y0: Y_LBL,
            x1: @segment_size,
            y1: Y_LBL
          )
        end
      end
    end
  end
end
