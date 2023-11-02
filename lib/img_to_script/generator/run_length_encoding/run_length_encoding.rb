# frozen_string_literal: true

module ImgToScript
  module Generator
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
            ImgToScript::AbstractToken::DataStorage.new(
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
        # (represented by the variable S) in the input data and translates the
        # RLE-encoded values into the "draw a line" commands that draw lines on
        # the screen.
        #
        def _dec_line01
          @tokens.append(
            AbstractToken::AssignValue.new(
              left: "X",
              right: @x_offset,
              require_nl: true
            )
          )

          @tokens.append(
            AbstractToken::AssignValue.new(
              left: "Y",
              right: @y_offset,
              require_nl: false
            )
          )

          @tokens.append(
            AbstractToken::LoopStart.new(
              var_name: "I",
              start_value: 1,
              end_value: @run_length_data.length,
              require_nl: false
            )
          )

          @tokens.append(
            AbstractToken::DataRead.new(
              var_list: "S",
              require_nl: false
            )
          )
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
          @tokens.append(
            AbstractToken::IfCondition.new(
              left: AbstractToken::MathAdd.new(
                left: AbstractToken::AbsValue.new(
                  expression: "S",
                  require_nl: false
                ),
                right: @major_axis_symbol,
                require_nl: false
              ),
              operator: ">",
              right: @segment_size,
              consequent: CurrentLinePlaceholder.new(3),
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
              left: "S",
              operator: ">",
              right: "0",
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
          @tokens.append(
            AbstractToken::AssignValue.new(
              left: @major_axis_symbol,
              right: AbstractToken::MathAdd.new(
                left: @major_axis_symbol,
                right: AbstractToken::AbsValue.new(
                  expression: "S",
                  require_nl: false
                ),
                require_nl: false
              ),
              require_nl: true
            )
          )

          @tokens.append(
            AbstractToken::LoopEnd.new(
              var_name: "I",
              require_nl: false
            )
          )

          @tokens.append(
            AbstractToken::GoTo.new(
              line: CurrentLinePlaceholder.new(3),
              require_nl: false
            )
          )
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
              left: "S",
              operator: ">",
              right: "0",
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
        # the screen and the run-length value S. When the program jumps
        # back to the line length check.
        #
        def _dec_line06
          @tokens.append(
            AbstractToken::AssignValue.new(
              left: @minor_axis_symbol,
              right: AbstractToken::MathAdd.new(
                left: @minor_axis_symbol,
                right: 1,
                require_nl: false
              ),
              require_nl: true
            )
          )

          sgn_tok = AbstractToken::SignFunc.new(
            expression: "S",
            require_nl: false
          )

          abs_tok = AbstractToken::AbsValue.new(
            expression: "S",
            require_nl: false
          )

          sum_tok = AbstractToken::MathAdd.new(
            left: abs_tok,
            right: @major_axis_symbol,
            require_nl: false
          )

          sub_tok = AbstractToken::MathSub.new(
            left: sum_tok,
            right: @image_size,
            require_nl: false
          )

          mult_tok = AbstractToken::MathMult.new(
            left: [
              AbstractToken::ParenthesisLeft.new(require_nl: false),
              sub_tok,
              AbstractToken::ParenthesisRight.new(require_nl: false),
            ],
            right: sgn_tok,
            require_nl: false
          )

          @tokens.append(
            AbstractToken::AssignValue.new(
              left: "S",
              right: mult_tok,
              require_nl: false
            )
          )

          @tokens.append(
            AbstractToken::AssignValue.new(
              left: @major_axis_symbol,
              right: @major_axis_value,
              require_nl: false
            )
          )

          @tokens.append(
            AbstractToken::GoTo.new(
              line: CurrentLinePlaceholder.new(-4),
              require_nl: false
            )
          )
        end
      end
    end
  end
end
