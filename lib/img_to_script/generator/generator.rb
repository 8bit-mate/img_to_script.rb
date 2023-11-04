# frozen_string_literal: true

module ImgToScript
  module Generator
    #
    # Base class for generators.
    #
    class Generator
      include Dry::Configurable

      setting :x_offset, default: 0
      setting :y_offset, default: 0
      setting :clear_screen, default: true
      setting :pause_program, default: true

      #
      # Generate abstract tokens that render the image.
      #
      # @param [Magick::BinMagick::Image] image
      #   Binary image.
      #
      # @param [Integer] scr_width
      #   Target device horizontal screen resolution.
      #
      # @param [Integer] scr_height
      #   Target device vertical screen resolution.
      #
      # @return [Array<AbstractToken>]
      #
      def generate(image:, scr_width:, scr_height:)
        @image = image
        @scr_width = scr_width
        @scr_height = scr_height
        @x_offset = config.x_offset
        @y_offset = config.y_offset

        _generate_tokens
      end

      private

      def _generate_tokens
        @tokens = [] # append new tokens here

        _program_begin
        _clear_screen if config.clear_screen
        _generate
        _program_pause if config.pause_program
        _program_end
      end

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
        @tokens.append(
          AbstractToken::ClearScreen.new(
            require_nl: true
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

      #
      # Append a token to mark begin of the program.
      #
      def _program_begin
        @tokens.append(
          AbstractToken::ProgramBegin.new(
            require_nl: true
          )
        )
      end

      #
      # Append a sub-routine to pause the program.
      #
      def _program_pause
        # @todo
      end
    end
  end
end
