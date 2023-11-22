# frozen_string_literal: true

module ImgToScript
  module Generators
    module Segmental
      module DataReadDraw
        #
        # DATA...READ (with horizontal scan lines).
        #
        class Horizontal < DataReadDraw
          include HorizontalMixin

          private

          def _generate
            @data = []

            super
          end

          def _read
            @tokens.append(
              AbstractToken::DataRead.new(
                var_list: READ_PATTERN_HORIZ
              )
            )
          end

          def _draw_line
            @tokens.append(
              AbstractToken::DrawLineByAbsCoords.new(
                x0: X0_LBL,
                y0: Y_LBL,
                x1: X1_LBL,
                y1: Y_LBL
              )
            )
          end

          #
          # Convert a chunk of black pixel(s) to three coordinates: x0, x1, y.
          #
          # @param [Integer] count
          #   Run-length of the pixel block.
          #
          def _encode_chunk(count)
            coordinates = _segment_coordinates(count)
            @data.push(coordinates[:x0], coordinates[:x1], coordinates[:y0])
          end
        end
      end
    end
  end
end
