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
          # Some tokens can have nested tokens in their arguments, e.g.:
          # LET X = ABS(X + L)
          #
          # The method 'expands' such arguments by recursively calling
          # the _translate_token method.
          #
          def _expand_args(args)
            result = []

            args.each do |arg|
              if arg.is_a?(ImgToScript::AbstractToken::AbstractToken)
                result.push(_translate_token(arg))
              else
                result.push(arg)
              end
            end

            result
          end

          #
          # Math. operation that has a left part, a right part
          # and the operator between the parts.
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
              args: _expand_args([
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
              args: _expand_args([
                                   "(",
                                   token.expression,
                                   ")"
                                 ]),
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _abs_value(token)
            _function(token, "ABS")
          end

          def _clear_screen(token)
            MK90BasicToken.new(
              keyword: "CLS",
              args: [""],
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _program_end(token)
            MK90BasicToken.new(
              keyword: "END",
              args: [""],
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
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
              args: token.var_list,
              separator: ",",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _draw_line_by_abs_coords(token)
            MK90BasicToken.new(
              keyword: "DRAWD",
              args: _expand_args([
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
              args: _expand_args([
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
              args: _expand_args([
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
              args: _expand_args([
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
              args: _expand_args([
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
              args: [
                token.var_name
              ],
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _if_condition(token)
            MK90BasicToken.new(
              keyword: "IF",
              args: _expand_args([
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
              args: _expand_args([
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
