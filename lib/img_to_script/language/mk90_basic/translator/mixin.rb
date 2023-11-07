# frozen_string_literal: true

module ImgToScript
  module Language
    module MK90Basic
      module Translator
        # rubocop:disable Metrics/ModuleLength

        #
        # Shared by both MK90 BAIC v.1.0 & v.2.0.
        #
        module Mixin
          #
          # Some abstract tokens can have nested tokens as their
          # arguments. Other tokens can have Symbols as placeholders
          # for the variables names. And other arguments should be
          # passed as is (e.g. Integers and Strings).
          #
          # The method translates an array of arguments of mixed types
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
          # Math. operation that has a left part, a right part, and
          # the operator between the parts.
          #
          # @param [AbstractToken] token
          #
          # @param [String] operator
          #   E.g.: "+", "-", "*", "/"
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
          # Function with expression that's wrapped in parentheses.
          # E.g.: ABS(ex), SGN(ex). Keyword can be empty, in that case
          # only parentheses will be added: (ex).
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
          # Single keyword statements.
          #
          # A statement that consists only from a keyword, and doesn't
          # take arguments, e.g.: CLS, END, STOP, etc.
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

          def _abs_value(token)
            _function(token, "ABS")
          end

          def _clear_screen(token)
            _single_keyword(token, "CLS")
          end

          def _program_end(token)
            _single_keyword(token, "END")
          end

          def _sign_greater_than(token)
            MK90BasicToken.new(
              keyword: "",
              args: [">"],
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _data_storage(token)
            MK90BasicToken.new(
              keyword: "DATA",
              args: token.data,
              separator: ",",
              require_nl: token.require_nl,
              sliceable: true
            )
          end

          def _data_read(token)
            MK90BasicToken.new(
              keyword: "READ",
              args: _translate_arguments(token.var_list),
              separator: ",",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _draw_line_by_abs_coords(token)
            MK90BasicToken.new(
              keyword: "DRAWD",
              args: _translate_arguments([
                                           token.x0,
                                           token.y0,
                                           token.x1,
                                           token.y1
                                         ]),
              separator: ",",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _draw_pixel_by_abs_coords(token)
            MK90BasicToken.new(
              keyword: "DRAWH",
              args: _translate_arguments([
                                           token.x,
                                           token.y
                                         ]),
              separator: ",",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _draw_chunk_by_hex_value(token)
            MK90BasicToken.new(
              keyword: "DRAWM",
              args: token.hex_values,
              separator: "",
              require_nl: token.require_nl,
              sliceable: true
            )
          end

          def _math_add(token)
            _math_operation(token, "+")
          end

          def _math_sub(token)
            _math_operation(token, "-")
          end

          def _math_mult(token)
            _math_operation(token, "*")
          end

          def _move_point_to_abs_coords(token)
            MK90BasicToken.new(
              keyword: "DRAWO",
              args: _translate_arguments([
                                           token.x,
                                           token.y
                                         ]),
              separator: ",",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _go_to(token)
            MK90BasicToken.new(
              keyword: "GOTO",
              args: _translate_arguments([
                                           token.line
                                         ]),
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _loop_start(token)
            MK90BasicToken.new(
              keyword: "FOR",
              args: _translate_arguments([
                                           token.var_name,
                                           "=",
                                           token.start_value,
                                           "TO",
                                           token.end_value
                                         ]),
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _sign_func(token)
            _function(token, "SGN")
          end

          def _parenthesis(token)
            _function(token, "")
          end

          def _loop_end(token)
            MK90BasicToken.new(
              keyword: "NEXT",
              args: _translate_arguments(
                [
                  token.var_name
                ]
              ),
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _if_condition(token)
            MK90BasicToken.new(
              keyword: "IF",
              args: _translate_arguments([
                                           token.left,
                                           token.operator,
                                           token.right,
                                           "THEN",
                                           token.consequent
                                         ]),
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _wait(token)
            MK90BasicToken.new(
              keyword: "WAIT",
              args: _translate_arguments([
                                           token.time
                                         ]),
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _remark(token)
            MK90BasicToken.new(
              keyword: "REM",
              args: [
                token.text
              ],
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end
        end

        # rubocop:enable Metrics/ModuleLength
      end
    end
  end
end
