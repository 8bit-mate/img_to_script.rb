# frozen_string_literal: true

module ImgToScript
  module Generator
    class Generator
      def generate(image:, scr_width:, scr_height:, x_offset: 0, y_offset: 0)
        @image = image
        @scr_width = scr_width
        @scr_height = scr_height
        @x_offset = x_offset
        @y_offset = y_offset

        @tokens = [] # add new tokens here

        _clear_screen if true # @todo
        _generate
        _program_end
      end

      private

      #
      # Transpose image for vertical scanning.
      #
      def _transpose
        @image.rotate!(90)
        @image.flop!
      end

      #
      # Append a token to clear screen.
      #
      def _clear_screen
        @tokens.prepend(
          AbstractToken::ClearScreen.new(
            require_nl: false
          )
        )
      end

      #
      # Append a token to mark end of the program.
      #
      def _program_end
        @tokens.append(
          AbstractToken::ProgramEnd.new(
            require_nl: true
          )
        )
      end
    end
  end
end
