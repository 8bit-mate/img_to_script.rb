# frozen_string_literal: true

module ImgToScript
  module ImageProcessors
    #
    # Base class.
    #
    class ImageProcessor
      #
      # Call image processor.
      #
      # @param [Magick::BinMagick::Image] image
      #
      # @param [Integer] scr_width
      #
      # @param [Integer] scr_height
      #
      # @param [Hash{ Symbol => Object }] kwargs
      #
      # @return [Magick::BinMagick::Imageu] @image
      #
      def call(image:, scr_width:, scr_height:, **kwargs)
        _call(
          image: image,
          scr_width: scr_width,
          scr_height: scr_height,
          **kwargs
        )
      end

      private

      def _call(**); end
    end
  end
end
