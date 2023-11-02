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
          # _dec_line02
          # _dec_line03
          # _dec_line04
          # _dec_line05
          # _dec_line06
        end

        #
        # 1-st line of the decoder procedure.
        #
        # In this line the X & Y var's are defined. The X and Y variables are used to keep track of the current position
        # on the screen.
        #
        # Then the main loop starts. The loop iterates over each pixel value (represented by the variable S) in the
        # input data and translates the RLE-encoded values into DRAW/D commands that draw lines on the screen.
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
        # The IF statement is used to handle cases where the line would extend beyond the bounds of the image/screen.
        # In this case the program jumps to the 5-th line of the decoder, that handles this edge case.
        #
        def _dec_line02
          @tokens.append(
            AbstractToken::IfCondition.new(
              left: "ABS(S)+#{@major_axis_symbol}",
              operator: ">",
              right: @segment_size,
              require_nl: true
            )
          )

          @tokens.append(
            AbstractToken::GoTo.new(
              shortcut_on: true,
              require_nl: false
            )
          )


          condition_args = [
            "ABS(S)+#{@major_axis_symbol}",
            ">",
            @segment_size,
            "THEN",
            (model.formatter.n_line + model.formatter.line_step * 4).to_s
          ]

          @model.append_if(args: condition_args, require_nl: true)
        end

        #
        # 3-rd line of the decoder procedure.
        #
        # Draws a line if S is a positive number. Positive numbers represent black pixels.
        #
        def _dec_line03
          condition_args = ["S>0", "THEN", @part_line_pattern]
          @model.append_if(args: condition_args, require_nl: true)
        end

        #
        # 4-th line of the decoder procedure.
        #
        # Updates major axis position. Ends the main loop. Jumps to the end of the program.
        #
        def _dec_line04
          @model.append_let(args: ["#{@major_axis_symbol}=#{@major_axis_symbol}+ABS(S)"], require_nl: true)
          @model.append_next(args: %w[I])
          @model.append_goto(args: [(@model.formatter.n_line + @model.formatter.line_step * 3).to_s])
        end

        #
        # 5-th line of the decoder procedure.
        #
        # This part handles cases where the line would extend beyond the bounds of the image/screen. It draws a line
        # from the current position up to the end of the image/screen.
        #
        def _dec_line05
          @model.append_if(args: ["S>0", "THEN", @full_line_pattern], require_nl: true)
        end

        #
        # 6-th line of the decoder procedure.
        #
        # This part handles cases where the line would extend beyond the bounds of the image/screen. It updates the
        # current position on the screen and the run-length value S.
        #
        def _dec_line06
          @model.append_let(args: ["#{@minor_axis_symbol}=#{@minor_axis_symbol}+1"], require_nl: true)

          let_args = ["S", "=", "(", "ABS(S)", "+", @major_axis_symbol, "-", @image_size, ")", "*", "SGN(S)"]
          @model.append_let(args: let_args)

          @model.append_let(args: [@major_axis_symbol, "=", @major_axis_value.to_s])
          @model.append_goto(args: [(@model.formatter.n_line - @model.formatter.line_step * 4).to_s])
        end
      end
    end
  end
end
