# frozen_string_literal: true

module ImgToScript
  module Generator
    module Segmental
      class Segmental < Generator
        SCAN_LINE_HEIGHT = 1

        private

        def _generate
          # Keeps track of all black segment in the image.
          # This value will be used in the depacker (in the DATA..READ scenario).
          @n_black_segments = 0

          @minor_axis = 0

          _scan_image
          _append_decoder
        end

        #
        # Loop through all scan lines in the image.
        #
        def _scan_image
          (0...@image.height).each do
            @major_axis = 0
            _process_scan_line(_encode_scan_line(_get_scan_line))
            @minor_axis += 1
          end
        end

        #
        # Grab a horizontal line from the image.
        #
        # @return [Array<Magick::Pixel>]
        #
        def _get_scan_line
          @image.get_pixels(@major_axis, @minor_axis, @image.width, SCAN_LINE_HEIGHT)
        end

        #
        # Encode scan line with the RLE.
        #
        # @param [Array<Magick::Pixel>] scan_line
        #   Scan line to encode.
        #
        # @return [Array<RunLengthEncodingRb::RLEElement>]
        #
        def _encode_scan_line(scan_line)
          RunLengthEncodingRb.encode(scan_line)
        end

        #
        # Process current RLE-encoded scan line.
        #
        # @return [Array<RunLengthEncodingRb::RLEElement>] encoded_scan_line
        #
        def _process_scan_line(encoded_scan_line)
          encoded_scan_line.each do |e|
            _process_scan_line_chunk(e)
            @major_axis += e.run_length
          end
        end

        #
        # Process a chunk of white or black pixels from the current scan line.
        #
        # Depending on the color value of the chunk, the chunk either gets ignored
        # (white pixels), or gets processed to be appended to the BASIC script
        # (black pixels) as a respective statement.
        #
        # @param [RunLengthEncodingRb::RLEElement] element
        #   An RLE element.
        #
        def _process_scan_line_chunk(element)
          pixel_color = element.chunk.to_color
          return unless pixel_color == "black"

          _encode_chunk(element.run_length)
          @n_black_segments += 1
        end

        #
        # Reserved for the DATA..READ scenario.
        #
        def _append_decoder; end
      end
    end
  end
end
