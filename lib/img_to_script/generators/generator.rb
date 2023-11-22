# frozen_string_literal: true

module ImgToScript
  module Generators
    #
    # Base class for generators.
    #
    class Generator
      include Dry::Configurable

      setting :x_offset, default: 0
      setting :y_offset, default: 0
      setting :clear_screen, default: true
      setting :pause_program, default: true
      setting AbsTokenType::PROGRAM_BEGIN, default: false
      setting AbsTokenType::PROGRAM_END, default: false

      WAIT_LOOP_COUNT = 100
      WAIT_TIME = 1024

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

        @tokens
      end

      private

      def _generate_tokens
        @tokens = [] # append new tokens here

        _program_begin if config.program_begin
        _clear_screen if config.clear_screen
        _generate
        _program_pause if config.pause_program
        _program_end if config.program_end
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
        _loop_begin
        _wait
        _loop_end
      end

      def _loop_begin
        @tokens.append(
          AbstractToken::LoopBegin.new(
            start_value: 1,
            end_value: WAIT_LOOP_COUNT,
            var_name: LOOP_VAR,
            require_nl: true
          )
        )
      end

      def _wait
        @tokens.append(
          AbstractToken::Wait.new(
            time: WAIT_TIME
          )
        )
      end

      def _loop_end
        @tokens.append(
          AbstractToken::LoopEnd.new(
            var_name: LOOP_VAR
          )
        )
      end
    end
  end
end
