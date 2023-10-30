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
          def _clear_screen(token)
            MK90BasicToken.new(
              keyword: "CLS",
              args: [""],
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
              args: [
                token.x0,
                token.y0,
                token.x1,
                token.y1
              ],
              separator: ",",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _draw_pixel_by_abs_coords(token)
            MK90BasicToken.new(
              keyword: "DRAWH",
              args: [
                token.x,
                token.y
              ],
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

          def _move_point_to_abs_coords(token)
            MK90BasicToken.new(
              keyword: "DRAWO",
              args: [
                token.x,
                token.y
              ],
              separator: ",",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _go_to(token)
            MK90BasicToken.new(
              keyword: "GOTO",
              args: [
                token.line
              ],
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _loop_start(token)
            MK90BasicToken.new(
              keyword: "FOR",
              args: [
                token.var_name,
                "=",
                token.start_value,
                "TO",
                token.end_value
              ],
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
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

          def _if_branch(token)
            MK90BasicToken.new(
              keyword: "IF",
              args: [
                token.left,
                token.operator,
                token.right,
                "THEN"
              ],
              separator: "",
              require_nl: token.require_nl,
              sliceable: false
            )
          end

          def _wait(token)
            MK90BasicToken.new(
              keyword: "WAIT",
              args: [
                token.time
              ],
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
