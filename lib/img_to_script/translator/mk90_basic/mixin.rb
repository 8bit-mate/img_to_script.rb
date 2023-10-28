# frozen_string_literal: true

module ImgToScript
  module Translator
    module MK90Basic
      module Mixin
        def _clear_screen(token)
          LanguageToken.new(
            keyword: "CLS",
            args: [""],
            separator: "",
            require_nl: token.require_nl,
            sliceable: false
          )
        end

        def _data_storage(token)
          LanguageToken.new(
            keyword: "DATA",
            args: token.data,
            separator: ",",
            require_nl: token.require_nl,
            sliceable: true
          )
        end

        def _data_read(token)
          LanguageToken.new(
            keyword: "READ",
            args: token.var_list,
            separator: ",",
            require_nl: token.require_nl,
            sliceable: false
          )
        end

        def _draw_line_by_abs_coords(token)
          LanguageToken.new(
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
          LanguageToken.new(
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
          LanguageToken.new(
            keyword: "DRAWM",
            args: [
              token.hex_values
            ],
            separator: "",
            require_nl: token.require_nl,
            sliceable: true
          )
        end

        def _move_point_to_abs_coords(token)
          LanguageToken.new(
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
          LanguageToken.new(
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
          LanguageToken.new(
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
          LanguageToken.new(
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
          LanguageToken.new(
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
          LanguageToken.new(
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
          LanguageToken.new(
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
    end
  end
end
