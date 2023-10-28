# frozen_string_literal: true

module ImgToScript
  class CurrentLinePlaceholder
    attr_reader :shift

    #
    # @param [Integer] shift
    #   Relative shift of the current line number.
    #
    def initialize(shift = 0)
      @shift = shift
    end
  end
end
