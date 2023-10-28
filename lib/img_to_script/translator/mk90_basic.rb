# frozen_string_literal: true

module ImgToScript
  module Translator
    module MK90Basic
      class MK90Basic < Translator
        include Mixin

        private

        def _translate(abstract_tokens)
          result = []

          abstract_tokens.each do |token|
            result.push(_translate_token(token))
          end

          result
        end

        def _translate_token(token)
          case token.type
          when :assign_value
            _assign_value(token)
          when :clear_screen
            _clear_screen(token)
          when :data_storage
            _data_storage(token)
          when :data_read
            _data_read(token)
          when :draw_line_by_abs_coords
            _draw_line_by_abs_coords(token)
          when :draw_pixel_by_abs_coords
            _draw_pixel_by_abs_coords(token)
          when :draw_chunk_by_hex_value
            _draw_chunk_by_hex_value(token)
          when :move_point_to_abs_coords
            _move_point_to_abs_coords(token)
          when :go_to
            _go_to(token)
          when :loop_start
            _loop_start(token)
          when :loop_end
            _loop_end(token)
          when :if_branch
            _if_branch(token)
          when :wait
            _wait(token)
          else
            rem_token = AbstractToken::Remark.new(
              text: "wrong abstract token type!",
              require_nl: true
            )
            _remark(rem_token)
          end
        end
      end
    end
  end
end
