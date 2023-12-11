# frozen_string_literal: true

module ImgToScript
  module Languages
    module MK90Basic
      module Translators
        #
        # Translates abstract tokens to the MK90 BASIC statements.
        #
        # Both v.1.0 & v.2.0 share the same syntax, but there are small
        # differences. This differences are defined in the child classes
        # MK90Basic10 & MK90Basic20.
        #
        class Translator < ImgToScript::Translator
          include Mixin

          private

          def _translate(abstract_tokens, **)
            result = []

            abstract_tokens.each do |token|
              result.push(_translate_token(token))
            end

            result
          end

          def _translate_token(token)
            case token.type
            when AbsTokenType::ABS_FUNC
              _abs_func(token)
            when AbsTokenType::ASSIGN_VALUE
              _assign_value(token)
            when AbsTokenType::CLEAR_SCREEN
              _clear_screen(token)
            when AbsTokenType::DATA_STORE
              _data_store(token)
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
            when AbsTokenType::MATH_GREATER_THAN
              _math_greater_than(token)
            when AbsTokenType::SIGN_FUNC
              _sign_func(token)
            when AbsTokenType::PARENTHESES
              _parentheses(token)
            when AbsTokenType::LOOP_BEGIN
              _loop_begin(token)
            when AbsTokenType::PROGRAM_END_LBL
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

          #
          # Replace placeholders, expand nested tokens in the
          # arguments, etc.
          #
          # @param [Array<Object>] args
          #   Original arguments.
          #
          # @return [Array<Object>]
          #   Translated arguments.
          #
          def _translate_arguments(args)
            result = []

            args.each do |arg|
              result.push(_translate_arg(arg))
            end

            result
          end

          #
          # Translate an argument based on its type.
          #
          # Some abstract tokens can have nested tokens as their
          # arguments. Other tokens can have Symbols as placeholders
          # for the variables names. Other arguments should be passed
          # as is (e.g. Integers and Strings).
          #
          # @param [Object] arg
          #
          # @return [Object]
          #
          def _translate_arg(arg)
            case arg
            when AbstractToken::AbstractToken
              _translate_token(arg)
            when Symbol
              arg.to_s.upcase
            else
              arg
            end
          end

          #
          # Return a token of a arithmetic operation.
          #
          # Operation should have a left part, a right part, and
          # the operator between the parts.
          #
          # @param [AbstractToken] token
          #
          # @param [String] operator
          #   E.g.: "+", "-", ">", "<", etc.
          #
          # @return [MK90BasicToken]
          #
          def _math_operation(token, operator)
            MK90BasicToken.new(
              keyword: "",
              args: _translate_arguments([
                                           token.left,
                                           operator,
                                           token.right
                                         ]),
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          #
          # Return a token of a function with parentheses.
          #
          # Function with an expression that's wrapped in parentheses.
          # E.g.: ABS(ex), SGN(ex). Keyword can be empty, in that case
          # only parentheses with the expression will be returned: (ex).
          #
          # @param [AbstractToken] token
          #
          # @param [String] keyword
          #   E.g.: "ABS", "SGN".
          #
          # @return [MK90BasicToken]
          #
          def _function(token, keyword)
            MK90BasicToken.new(
              keyword: keyword,
              args: _translate_arguments([
                                           "(",
                                           token.expression,
                                           ")"
                                         ]),
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          #
          # Return a token of a keyword statements.
          #
          # A statement that consists only of a keyword, and doesn't
          # take arguments, e.g.: CLS, END, STOP.
          #
          # @param [AbstractToken] token
          #
          # @param [String] keyword
          #
          # @return [MK90BasicToken]
          #
          def _single_keyword(token, keyword)
            MK90BasicToken.new(
              keyword: keyword,
              args: [""],
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end
        end
      end
    end
  end
end
