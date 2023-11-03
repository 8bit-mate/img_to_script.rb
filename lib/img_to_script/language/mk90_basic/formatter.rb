# frozen_string_literal: true

module ImgToScript
  module Language
    module MK90Basic
      module Formatter
        #
        # MK90 BASIC formatters base class.
        #
        class Formatter < ImgToScript::Formatter
          attr_reader :script

          include Dry::Configurable

          setting :line_offset, default: DEF_LINE_OFFSET
          setting :line_step, default: DEF_LINE_STEP
          setting :max_chars_per_line, default: MAX_CHARS_PER_LINE
          setting :number_lines, default: true

          def format(basic_tokens)
            _apply_config

            @n_line = @line_offset - @line_step
            @script = []

            basic_tokens.each do |token|
              _append_token(token)
            end

            @script
          end

          private

          def _apply_config
            @line_offset = config.line_offset
            @line_step = config.line_step
            @max_chars_per_line = config.max_chars_per_line
            @number_lines = config.number_lines
          end
        end
      end
    end
  end
end
