# frozen_string_literal: true

module ImgToScript
  module Generator
    module HexMask
      #
      # Generates image rendering script using the DRAW/M statement with the 'enhancements'.
      #
      # To save space at the MPO-10 cart, it's possible to replacelong sequences of repeating chunks with a shorter
      # (in terms of number of chars required to store the statement) code, e.g.:
      #
      # xxDRAWMFFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFF  // 43 bytes -- 16 repeating chunks of 'AA'.
      # xxDRAWMFF:FORI=1TO16:DRAWMAA:NEXTI:DRAWMFF   // 42 bytes -- repeating chunks were replaced with a loop.
      #
      # Same principle could be applied to eliminate long sequences of white pixels, e.g.:
      # xxDRAWMFF00000000000000000000FF  // 31 bytes -- 10 repeating chunks of '00'.
      # xxDRAWMFF:DRAWOxxx,yy:DRAWMFF    // 29 bytes -- replaced with a manual shift.
      #
      # The algorithm is:
      # 1. apply RLE to the array of hex chunks (DRAW/M arguments);
      # 2. loop through the array of run-lengths: take an element (a 'chunk') and check if it's run-length is larger
      #    than an estimated value (MIN_REP_CHUNKS or MIN_REP_WH_CHUNKS);
      # 3. if true: add pending chunks to the BASIC code; then append a FOR-NEXT loop or DRAW/O.
      #    Clear pending chunks array and continue to loop through the array of run-lengths.
      # 4. otherwise: add current chunk to the array of pending chunks;
      # 5. after the loop: add pending chunks.
      #
      class Enhanced < HexMask
        MIN_REP_CHUNKS = 16   # min. number of the non-white repeating chunks that could be replaced with a loop.
        MIN_REP_WH_CHUNKS = 9 # min. number of the white repeating chunks that that could be replaced with a DRAW/O.

        private

        def _generate
          _init_instant_vars
          _process_rle_image
          _append_pending_chunks

          @tokens
        end

        #
        # Set up initional values for the instant variables.
        #
        def _init_instant_vars
          @x = 0 # It is always = 0, not the x/y_offset. The reason is that
          @y = 0 # we've already applied offset in the #_prepare_image method.

          @hex_img = _encode_img
          @rle_hex_img = _encode_hex_img

          @pending_chunks = []
          @run_length_index = 0
        end

        #
        # Loop through the RLE-encoded hex-image.
        #
        def _process_rle_image
          @rle_hex_img.each_with_index do |rle_item, idx|
            @chunk_count = rle_item.run_length
            @chunk = rle_item.chunk

            _calc_current_pos
            _process_chunk(idx)
          end
        end

        #
        # Choose action for a current chunk depending on its run-length
        # and its color hex value (white or non-white).
        #
        # @param [Integer] idx
        #   Index of the element in the RLE array.
        #
        def _process_chunk(idx)
          if @chunk_count >= MIN_REP_WH_CHUNKS && @chunk == "00"
            _process_white_segments(idx)
          elsif @chunk_count >= MIN_REP_CHUNKS && @chunk != "00"
            _process_non_white_segments
          else
            _upd_pending_chunks
            _upd_rle_index
          end
        end

        #
        # @return [Array<RunLengthEncodingRb::RLEElement>]
        #
        def _encode_hex_img
          RunLengthEncodingRb.encode(@hex_img)
        end

        #
        # Calculate current (X, Y) position.
        #
        def _calc_current_pos
          @y += @chunk_count
          return unless @y > @scr_height - 1

          # Reached the vertical end of the screen - re-calculate position:
          div_res = @y.div(@scr_height)
          rem = @y.remainder(@scr_height)
          @x += CHUNK_WIDTH * div_res
          @y = rem
        end

        def _upd_rle_index
          @run_length_index += @chunk_count
        end

        def _clr_pending_chunks
          @pending_chunks = []
        end

        #
        # Replace long sequences of repeating non-white chunks with a shorter FOR-NEXT loop.
        #
        def _process_non_white_segments
          _append_pending_chunks
          _clr_pending_chunks

          _append_start_loop(@chunk_count)
          _append_hex_values(Array(@chunk))
          _append_end_loop

          _upd_rle_index
        end

        def _append_hex_values(hex_values)
          @tokens.append(
            ImgToScript::AbstractToken::DrawChunkByHexValue.new(
              hex_values: hex_values,
              require_nl: false
            )
          )
        end

        def _append_start_loop(end_value)
          @tokens.append(
            ImgToScript::AbstractToken::LoopStart.new(
              var_name: "I",
              start_value: 1,
              end_value: end_value,
              require_nl: false
            )
          )
        end

        def _append_end_loop
          @tokens.append(
            ImgToScript::AbstractToken::LoopEnd.new(
              var_name: "I",
              require_nl: false
            )
          )
        end

        def _append_move_point(x, y)
          @tokens.append(
            ImgToScript::AbstractToken::MovePointToAbsCoords.new(
              x: x,
              y: y,
              require_nl: false
            )
          )
        end

        #
        # Replace long sequences of white chunks (0x00) with a shorter manual shift of the (X, Y) point.
        #
        # @param [Integer] idx
        #   Index of the element in the RLE array.
        #
        def _process_white_segments(idx)
          # If white segments are the last part of the image,
          # we don't need to store them in the BASIC script at all
          return if idx == @rle_hex_img.length - 1

          _append_pending_chunks
          _clr_pending_chunks

          _append_move_point(@x, @y)

          _upd_rle_index
        end

        #
        # Append accumulated pending chunks to the tokens array.
        #
        def _append_pending_chunks
          return if @pending_chunks == []

          _append_hex_values(@pending_chunks)
        end

        #
        # Update array of the pending chunks.
        #
        def _upd_pending_chunks
          @pending_chunks.concat _current_pending_chunks
        end

        #
        # Retun chunks that are pending at the current itteration.
        #
        # @return [Array<String>]
        #
        def _current_pending_chunks
          @hex_img.slice(@run_length_index, @chunk_count)
        end
      end
    end
  end
end
