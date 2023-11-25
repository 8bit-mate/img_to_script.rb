# frozen_string_literal: true

module ImgToScript
  module ImageProcessors
    #
    # Resizes the image and converts to binary.
    #
    class ForceResizeAndToBinary < ImageProcessor
      private

      #
      # Call image processor.
      #
      # @param [Magick::BinMagick::Image] image
      #
      # @param [Integer] scr_width
      #
      # @param [Integer] scr_height
      #
      # @return [Magick::BinMagick::Image] @image
      #
      def _call(image:, scr_width:, scr_height:, **)
        @image = image

        _resize_image(scr_width, scr_height) if @image.oversize?(scr_width, scr_height)
        _to_binary unless @image.binary?

        @image
      end

      #
      # Forcibly resize the image if it doesn't fit to the MK90's screen resolution.
      #
      def _resize_image(width, height)
        @image.fit_to_size!(width, height)
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
