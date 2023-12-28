# frozen_string_literal: true

module ImgToScript
  module Generators
    module RunLengthEncoding
      #
      # Base class for the RLE-based script generators.
      #
      class RunLengthEncoding < Generator
        private

        #
        # Encode pixels into the RLE data.
        #
        def _encode_pixels
          @run_length_data = RunLengthEncodingRb.encode(@pixels)
          run_lengths = []

          encode = lambda { |count:, pixel:|
            count = -count if pixel.to_color == "white"
            run_lengths.push(count.to_s)
          }

          @run_length_data.each { |e| encode.call(pixel: e.chunk, count: e.run_length) }

          _append_data(run_lengths)
        end

        def _append_data(arr)
          @tokens.append(
            AbstractToken::DataStore.new(
              data: arr,
              require_nl: true
            )
          )
        end

        #
        # Append RLE decoder procedure afther the DATA sequence.
        #
        def _append_decoder
          _dec_line01
          _dec_line02
          _dec_line03
          _dec_line04
          _dec_line05
          _dec_line06
        end

        #
        # 1-st line of the decoder procedure.
        #
        # In this line the X & Y variables are defined. The X and Y variables
        # are used to keep track of the current position on the screen.
        #
        # Then the main loop starts. The loop iterates over each pixel value
        # (represented by the variable READ_VAR) in the input data and translates
        # the RLE-encoded values into the "draw a line" commands that draw lines
        # on the screen.
        #
        def _dec_line01
          _init_x
          _init_y
          _start_loop
          _read_value
        end

        #
        # 2-nd line of the decoder procedure.
        #
        # The IF statement is used to check cases where the line would extend
        # beyond the bounds of the image/screen. In this case the program jumps
        # to the 5-th line (3 lines down from the current line) of the decoder,
        # that handles this edge case.
        #
        def _dec_line02
          expression = AbstractToken::MathGreaterThan.new(
            left: _sum_of_current_point_and_length,
            right: @segment_size
          )

          @tokens.append(
            AbstractToken::IfCondition.new(
              expression: expression,
              consequent: CurrentLinePlaceholder.new(4),
              require_nl: true
            )
          )
        end

        #
        # 3-rd line of the decoder procedure.
        #
        # Draws a line if S is a positive number. Positive numbers represent
        # black pixels. Negative numbers represent white pixels.
        #
        def _dec_line03
          @tokens.append(
            AbstractToken::IfCondition.new(
              expression: _read_var_positive,
              consequent: @part_line_pattern,
              require_nl: true
            )
          )
        end

        #
        # 4-th line of the decoder procedure.
        #
        # Updates major axis position. Ends the main loop. Jumps to the end
        # of the program.
        #
        def _dec_line04
          _update_current_point
          _end_loop
          _jump_to_the_end
        end

        #
        # 5-th line of the decoder procedure.
        #
        # This part handles cases where the line would extend beyond the
        # bounds of the image/screen. It draws a line from the current
        # position up to the end of the image/screen.
        #
        def _dec_line05
          @tokens.append(
            AbstractToken::IfCondition.new(
              expression: _read_var_positive,
              consequent: @full_line_pattern,
              require_nl: true
            )
          )
        end

        #
        # 6-th line of the decoder procedure.
        #
        # This part handles cases where the line would extend beyond the
        # bounds of the image/screen. It updates the current position on
        # the screen and the run-length value. When it jumps back to the
        # line length check (2nd line of the decoder).
        #
        def _dec_line06
          _increment_minor_axis
          _update_read_variable
          _reset_major_axis
          _jump_to_length_check
        end

        def _read_var_positive
          AbstractToken::MathGreaterThan.new(
            left: READ_VAR,
            right: 0
          )
        end

        def _init_x
          @tokens.append(
            AbstractToken::AssignValue.new(
              left: X_LBL,
              right: @x_offset,
              require_nl: true
            )
          )
        end

        def _init_y
          @tokens.append(
            AbstractToken::AssignValue.new(
              left: Y_LBL,
              right: @y_offset
            )
          )
        end

        def _start_loop
          @tokens.append(
            AbstractToken::LoopBegin.new(
              var_name: LOOP_VAR,
              start_value: 1,
              end_value: @run_length_data.length
            )
          )
        end

        def _read_value
          @tokens.append(
            AbstractToken::DataRead.new(
              var_list: READ_VAR
            )
          )
        end

        def _abs_length_value
          AbstractToken::AbsFunc.new(
            expression: READ_VAR
          )
        end

        def _sum_of_current_point_and_length
          AbstractToken::MathAdd.new(
            left: _abs_length_value,
            right: @major_axis_symbol
          )
        end

        def _update_current_point
          @tokens.append(
            AbstractToken::AssignValue.new(
              left: @major_axis_symbol,
              right: _sum_of_current_point_and_length,
              require_nl: true
            )
          )
        end

        def _end_loop
          @tokens.append(
            AbstractToken::LoopEnd.new(
              var_name: LOOP_VAR
            )
          )
        end

        def _jump_to_the_end
          @tokens.append(
            AbstractToken::GoTo.new(
              line: CurrentLinePlaceholder.new(3)
            )
          )
        end

        def _sign_func
          AbstractToken::SignFunc.new(
            expression: READ_VAR
          )
        end

        def _increment_minor_axis
          @tokens.append(
            AbstractToken::AssignValue.new(
              left: @minor_axis_symbol,
              right: AbstractToken::MathAdd.new(
                left: @minor_axis_symbol,
                right: 1
              ),
              require_nl: true
            )
          )
        end

        def _reset_major_axis
          @tokens.append(
            AbstractToken::AssignValue.new(
              left: @major_axis_symbol,
              right: @major_axis_value
            )
          )
        end

        def _jump_to_length_check
          @tokens.append(
            AbstractToken::GoTo.new(
              line: CurrentLinePlaceholder.new(-4)
            )
          )
        end

        def _sum_token
          AbstractToken::MathAdd.new(
            left: _abs_length_value,
            right: @major_axis_symbol
          )
        end

        def _sub_token
          AbstractToken::MathSub.new(
            left: _sum_token,
            right: @image_size
          )
        end

        def _mult_token
          AbstractToken::MathMult.new(
            left: AbstractToken::Parentheses.new(
              expression: _sub_token
            ),
            right: _sign_func
          )
        end

        def _update_read_variable
          @tokens.append(
            AbstractToken::AssignValue.new(
              left: READ_VAR,
              right: _mult_token
            )
          )
        end
      end
    end
  end
end
