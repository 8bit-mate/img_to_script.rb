# frozen_string_literal: true

module ImgToScript
  module Language
    module MK90Basic
      module Translator
        #
        # Translates abstract tokens to the MK90 BASIC statements.
        #
        # Both v.1.0 & v.2.0 share the same syntax, but there are small
        # differences. This differences are defined in the child classes
        # MK90Basic10 < MK90Basic & MK90Basic20 < MK90Basic.
        #
        class Translator < ImgToScript::Translator
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
            when :abs_value
              _abs_value(token)
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
            when :math_add
              _math_add(token)
            when :go_to
              _go_to(token)
            when :loop_start
              _loop_start(token)
            when :loop_end
              _loop_end(token)
            when :if_condition
              _if_condition(token)
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
end