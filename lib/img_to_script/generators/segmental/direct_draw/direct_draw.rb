# frozen_string_literal: true

module ImgToScript
  module Generators
    module Segmental
      module DirectDraw
        #
        # Base class for the 'direct' draw method. Segments are being drawed by
        # calling the 'draw a pixel' and the 'draw a line' statements, and the
        # coordinates of the segments are *directly* hard-coded as the statement's
        # arguments. Hence the name.
        #
        class DirectDraw < Segmental
          private

          #
          # Convert a chunk of black pixel(s) to a respective BASIC statement:
          #
          # - for a sequence of black pixels: append 'draw a line' statement;
          # - for a single black pixel: append 'draw a dot' statement.
          #
          # @param [Integer] count
          #   Run-length of the pixel block.
          #
          def _encode_chunk(count)
            if count > 1
              _append_line(_segment_coordinates(count))
            else
              _append_dot(_segment_coordinates(count))
            end
          end

          #
          # Draw a dot by a pair of coordinates (x, y).
          #
          def _append_dot(coordinates)
            @tokens.append(
              AbstractToken::DrawPixelByAbsCoords.new(
                x: coordinates[:x0],
                y: coordinates[:y0]
              )
            )
          end

          #
          # Draw a line by a pairs of coordinates (x0, y0), (x1, y1).
          #
          def _append_line(coordinates)
            @tokens.append(
              AbstractToken::DrawLineByAbsCoords.new(
                x0: coordinates[:x0],
                y0: coordinates[:y0],
                x1: coordinates[:x1],
                y1: coordinates[:y1]
              )
            )
          end
        end
      end
    end
  end
end
