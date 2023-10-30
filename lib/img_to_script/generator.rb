# frozen_string_literal: true

module ImgToScript
  #
  # Generators generate array of abstract tokens that represent the image
  # in terms of simple operations, e.g.: draw a line, draw a pixe, etc.
  #
  module Generator
    #
    # Base class for script generators.
    #
    class Generator
      def generate(image:, scr_width:, scr_height:, x_offset: 0, y_offset: 0)
        @image = image
        @scr_width = scr_width
        @scr_height = scr_height
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
