# frozen_string_literal: true

module ImgToScript
  #
  # Defines abstract tokens types.
  #
  module AbsTokenType
    ABS_FUNC = :abs_func
    ASSIGN_VALUE = :assign_value
    CLEAR_SCREEN = :clear_screen
    DATA_READ = :data_read
    DATA_STORE = :data_store
    DRAW_CHUNK_BY_HEX_VALUE = :draw_chunk_by_hex_value
    DRAW_LINE_BY_ABS_COORDS = :draw_line_by_abs_coords
    DRAW_PIXEL_BY_ABS_COORDS = :draw_pixel_by_abs_coords
    GO_TO = :go_to
    IF_CONDITION = :if_condition
    LOOP_BEGIN = :loop_begin
    LOOP_END = :loop_end
    MATH_ADD = :math_add
    MATH_GREATER_THAN = :math_greater_than
    MATH_MULT = :math_mult
    MATH_SUB = :math_sub
    MOVE_POINT_TO_ABS_COORDS = :move_point_to_abs_coords
    PARENTHESES = :parentheses
    PROGRAM_BEGIN = :program_begin
    PROGRAM_END = :program_end
    REMARK = :remark
    SIGN_FUNC = :sign_func
    SIGN_GREATER_THAN = :sign_greater_than
    WAIT = :wait
  end
end
