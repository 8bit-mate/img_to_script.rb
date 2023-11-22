# frozen_string_literal: true

module ImgToScript
  module Generators
    module Segmental
      module DataReadDraw
        #
        # DATA...READ (with vertical scan lines).
        #
        class Vertical < DataReadDraw
          include VerticalMixin

          private

          def _generate
            @data = []

            super
          end

          def _read
            @tokens.append(
              AbstractToken::DataRead.new(
                var_list: READ_PATTERN_VERT
              )
            )
          end

          def _draw_line
            @tokens.append(
              AbstractToken::DrawLineByAbsCoords.new(
                x0: X_LBL,
                y0: Y0_LBL,
                x1: X_LBL,
                y1: Y1_LBL
              )
            )
          end

          #
          # Convert a chunk of black pixel(s) to three coordinates: y0, y1, x.
          #
          # @param [Integer] count
          #   Run-length of the pixel block.
          #
          def _encode_chunk(count)
            coordinates = _segment_coordinates(count)
            @data.push(coordinates[:y0], coordinates[:y1], coordinates[:x0])
          end
        end
      end
    end
  end
end
