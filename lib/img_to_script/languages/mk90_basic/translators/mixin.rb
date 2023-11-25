# frozen_string_literal: true

module ImgToScript
  module Languages
    module MK90Basic
      module Translators
        # rubocop:disable Metrics/ModuleLength

        #
        # Shared by both MK90 BAIC v.1.0 & v.2.0.
        #
        module Mixin
          def _abs_func(token)
            _function(token, "ABS")
          end

          def _clear_screen(token)
            _single_keyword(token, "CLS")
          end

          def _program_end(token)
            _single_keyword(token, "END")
          end

          def _data_store(token)
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

          def _math_greater_than(token)
            _math_operation(token, ">")
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

          def _loop_begin(token)
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

          def _parentheses(token)
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
                                           token.expression,
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
