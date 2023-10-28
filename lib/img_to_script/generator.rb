# frozen_string_literal: true

module ImgToScript
  module Generator
    #
    # Base class for script generators.
    #
    class Generator
      def generate(image, *); end
    end

    private

    #
    # Transpose image for vertical scanning.
    #
    def _transpose_image
      @image = @image.rotate(90).flop
    end
  end
end
