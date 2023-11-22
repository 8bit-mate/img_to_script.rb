# frozen_string_literal: true

module ImgToScript
  module Generators
    module Segmental
      #
      # Base class for the segmental generators.
      #
      # Segmental generators are designed to scan an image vertically or horizontaly.
      # In each scan line the isolated black px. segments are being parced out to
      # get their coordinates (x0, y0), (x1, y1). Drawing lines using these coordinates
      # will render the image on the target device.
      #
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
        # (To make a vertical scan line: simply transpose the image before a scan.)
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
        # (white pixels), or gets processed to be appended to the result script
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
