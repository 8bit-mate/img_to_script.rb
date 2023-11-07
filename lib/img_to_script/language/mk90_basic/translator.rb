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
            when AbsTokenType::ABS_FUNC
              _abs_value(token)
            when AbsTokenType::ASSIGN_VALUE
              _assign_value(token)
            when AbsTokenType::CLEAR_SCREEN
              _clear_screen(token)
            when AbsTokenType::DATA_STORE
              _data_storage(token)
            when AbsTokenType::DATA_READ
              _data_read(token)
            when AbsTokenType::DRAW_LINE_BY_ABS_COORDS
              _draw_line_by_abs_coords(token)
            when AbsTokenType::DRAW_PIXEL_BY_ABS_COORDS
              _draw_pixel_by_abs_coords(token)
            when AbsTokenType::DRAW_CHUNK_BY_HEX_VALUE
              _draw_chunk_by_hex_value(token)
            when AbsTokenType::MOVE_POINT_TO_ABS_COORDS
              _move_point_to_abs_coords(token)
            when AbsTokenType::MATH_ADD
              _math_add(token)
            when AbsTokenType::MATH_SUB
              _math_sub(token)
            when AbsTokenType::MATH_MULT
              _math_mult(token)
            when AbsTokenType::GO_TO
              _go_to(token)
            when AbsTokenType::SIGN_GREATER_THAN
              _sign_greater_than(token)
            when AbsTokenType::SIGN_FUNC
              _sign_func(token)
            when :parenthesis
              _parenthesis(token)
            when AbsTokenType::LOOP_BEGIN
              _loop_start(token)
            when AbsTokenType::PROGRAM_END
              _program_end(token)
            when AbsTokenType::LOOP_END
              _loop_end(token)
            when AbsTokenType::IF_CONDITION
              _if_condition(token)
            when AbsTokenType::WAIT
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
