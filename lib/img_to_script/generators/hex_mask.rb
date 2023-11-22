# frozen_string_literal: true

module ImgToScript
  module Generators
    #
    # Each 8x1 pixels block of a binary image gets encoded as a hex value.
    #
    # The method natively supported only by the Elektronika MK90 BASIC with its
    # DRAWM statement.
    #
    module HexMask; end
  end
end
