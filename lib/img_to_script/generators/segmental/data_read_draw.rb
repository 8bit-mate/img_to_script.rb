# frozen_string_literal: true

module ImgToScript
  module Generators
    module Segmental
      module DataReadDraw
        X0_LBL = :a
        X1_LBL = :b

        Y0_LBL = :c
        Y1_LBL = :d

        READ_PATTERN_HORIZ = [X0_LBL, X1_LBL, Y_LBL].freeze
        READ_PATTERN_VERT = [Y0_LBL, Y1_LBL, X_LBL].freeze
      end
    end
  end
end
