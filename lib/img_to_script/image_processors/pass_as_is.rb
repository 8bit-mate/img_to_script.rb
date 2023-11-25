# frozen_string_literal: true

module ImgToScript
  module ImageProcessors
    #
    # Returns unedited image.
    #
    class PassAsIs < ImageProcessor
      private

      def _call(image:, **)
        image
      end
    end
  end
end
