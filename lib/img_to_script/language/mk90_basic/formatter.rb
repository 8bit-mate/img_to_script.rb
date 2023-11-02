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

          def initialize(
            line_offset: DEF_LINE_OFFSET,
            line_step: DEF_LINE_STEP,
            max_chars_per_line: MAX_CHARS_PER_LINE
          )
            @line_offset = line_offset
            @line_step = line_step
            @max_chars_per_line = max_chars_per_line

            @n_line = line_offset - line_step

            super()
          end

          def format(basic_tokens, number_lines: true)
            @number_lines = number_lines
            @script = []

            basic_tokens.each do |token|
              _append_token(token)
            end

            @script
          end
        end
      end
    end
  end
end
