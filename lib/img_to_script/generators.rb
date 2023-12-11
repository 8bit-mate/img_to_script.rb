# frozen_string_literal: true

module ImgToScript
  #
  # Namespace for generators.
  #
  # Generators generate array of abstract tokens that represent the image
  # in terms of simple operations, e.g.: draw a line, draw a pixel, etc.
  #
  module Generators
    X_LBL = :x
    Y_LBL = :y

    LOOP_VAR = :i
    READ_VAR = :l

    WAIT_LOOP_COUNT = 100
    WAIT_TIME = 1024

    X_OFFSET = 0
    Y_OFFSET = 0
    CLEAR_SCREEN = true
    PAUSE_PROGRAM = true
    PRORGAM_BEGIN_LBL = false
    PROGRAM_END_LBL = false
  end
end
