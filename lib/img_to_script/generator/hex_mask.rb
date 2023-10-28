# frozen_string_literal: true

module ImgToScript
  module Generator
    module HexMask
      class HexMask < Generator
        CHUNK_WIDTH = 8

        private

        #
        # Encode a binary image to a hex-mask encoded image.
        #
        # @return [Array<String>] hex_img
        #   An encoded image, represented as an array of hex-chunks.
        #
        def _encode_img
          binary_image = _prepare_image

          hex_img = []

          (0...binary_image.width).step(CHUNK_WIDTH).each do |x|
            (0...binary_image.height).each do |y|
              chunk = _grab_chunk(binary_image, x, y)
              hex_img.push(_bin_to_hex(chunk))
            end
          end

          hex_img
        end

        #
        # Prepare the image:
        #   1. ensure that image width should be divisible by 8 (CHUNK_WIDTH);
        #   2. ensure that image height is equal to 64 (::SCR_HEIGHT);
        #   3. offset the image according to the provided @x_offset / @y_offset.
        #
        # Steps 1 & 2 are required by the DRAW/M statement's algorithm.
        #
        def _prepare_image
          @image.extent(_new_width,
                        64, # @todo
                        @x_offset * -1,
                        @y_offset * -1)
        end

        #
        # Calculate new width for the image.
        #
        # The algorithm of the DRAW/M statement requires that image width should
        # be divisible by 8 (CHUNK_WIDTH).If the image doesn't comply with this
        # condition, it is required to extend the image width to a nearlest number
        # n: n.remainder(CHUNK_WIDTH) == 0.
        #
        # @return [Integer]
        #   New width.
        #
        def _new_width
          width = ((@image.width + @x_offset) / CHUNK_WIDTH.to_f).ceil * CHUNK_WIDTH
          width.clamp(CHUNK_WIDTH, 128) # @todo
        end

        # rubocop:disable Naming/MethodParameterName

        #
        # Grab a 8 x 1 rectangle from the image and convert its pixels to a binary string representation.
        #
        # @param [Magick::Image, Magick::BinMagick::Image] binary_image
        #
        # @param [Integer] x, y
        #   A current X,Y position at the image.
        #
        # @return [String]
        #   An 8-character string of 0's and 1's. Example: "11110011"
        #
        def _grab_chunk(binary_image, x, y)
          chunk_width = CHUNK_WIDTH
          chunk_heigth = 1
          pixels = binary_image.get_pixels(x, y, chunk_width, chunk_heigth)

          pixels.map { |pixel| pixel.to_color == "black" ? 1 : 0 }.join("")
        end

        # rubocop:enable Naming/MethodParameterName

        #
        # Convert a string of binary values to a two-digit hex representation.
        #
        # Example: "11110011" => "F3"
        #
        # @param [String] str
        #
        # @return [String]
        #
        def _bin_to_hex(str)
          format("%02x", str.to_i(2)).upcase
        end
      end
    end
  end
end
