# frozen_string_literal: true

module ImgToScript
  #
  # Generators generate array of abstract tokens that represent the image
  # in terms of simple operations, e.g.: draw a line, draw a pixe, etc.
  #
  module Generator
    X_LBL = :x
    Y_LBL = :y

    LOOP_VAR = :i
    READ_VAR = :l
  end
end
