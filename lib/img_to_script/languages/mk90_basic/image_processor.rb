# frozen_string_literal: true

module ImgToScript
  module Languages
    module MK90Basic
      #
      # Prepares image for the conversion.
      #
      class ImageProcessor
        #
        # Call image processor.
        #
        # @param [Magick::BinMagick::Image] image
        #
        # @return [Magick::BinMagick::Image] @image
        #
        def call(image)
          @image = image

          _resize_image if @image.oversize?(SCR_WIDTH, SCR_HEIGHT)
          _to_binary unless @image.binary?

          @image
        end

        private

        #
        # Forcibly resize the image if it doesn't fit to the MK90's screen resolution.
        #
        def _resize_image
          @image.fit_to_size!(SCR_WIDTH, SCR_HEIGHT)
        end

        #
        # Forcibly convert to binary.
        #
        def _to_binary
          @image.to_binary!
        end
      end
    end
  end
end
