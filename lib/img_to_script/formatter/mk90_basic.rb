# frozen_string_literal: true

module ImgToScript
  module Formatter
    module MK90Basic
      class MK90Basic < Formatter
        attr_reader :script

        def initialize(
          line_offset: 1,
          line_step: 1,
          max_chars_per_line: 80
        )
          @line_offset = line_offset
          @line_step = line_step
          @max_chars_per_line = max_chars_per_line

          @n_line = line_offset - line_step

          super()
        end

        def format(basic_tokens)
          @script = [""]

          basic_tokens.each do |token|
            _append_token(token)
          end

          @script
        end
      end
    end
  end
end