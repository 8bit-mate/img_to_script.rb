# frozen_string_literal: true

module ImgToScript
  module Generator
    module Segmental
      module DataReadDraw
        #
        # Base class for the 'DATA..READ' draw method.
        #
        # The segment's coordinates are stored via the DATA statement. Three
        # coordinates are stored: two coordinates of the 'major' axis, and oneI
        # coordinate of the 'minor' axis.
        #
        # The FOR..NEXT loop is defined after the DATA statements. It loops
        # through the array of coordinates, reads three values in a row, and
        # passes the values to the statement that draws a line.
        #
        class DataReadDraw < Segmental
          private

          def _generate
            @data = []

            super
          end

          #
          # Append a loop to read values from DATA and pass them to the DRAWD
          # statement that draws a line.
          #
          def _append_decoder
            _append_data
            _loop_start
            _read
            _draw_line
            _loop_end
          end

          def _append_data
            @tokens.append(
              AbstractToken::DataStore.new(
                data: @data,
                require_nl: true
              )
            )
          end

          def _loop_start
            @tokens.append(
              AbstractToken::LoopBegin.new(
                start_value: 1,
                end_value: @n_black_segments,
                var_name: LOOP_VAR,
                require_nl: true
              )
            )
          end

          def _loop_end
            @tokens.append(
              AbstractToken::LoopEnd.new(
                var_name: LOOP_VAR
              )
            )
          end
        end
      end
    end
  end
end
