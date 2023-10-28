# frozen_string_literal: true

module ImgToScript
  module Generator
    #
    # Base class for script generators.
    #
    class Generator
      def generate(image:, x_offset: 0, y_offset: 0)
        @image = image
        @x_offset = x_offset
        @y_offset = y_offset

        _generate
      end
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
