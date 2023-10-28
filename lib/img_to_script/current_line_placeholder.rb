# frozen_string_literal: true

module ImgToScript
  class CurrentLinePlaceholder
    attr_reader :shift

    def initialize(shift = 0)
      @shift = shift
    end
  end
end
