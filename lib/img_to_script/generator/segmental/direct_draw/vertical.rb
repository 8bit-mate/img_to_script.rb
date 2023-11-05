# frozen_string_literal: true

module ImgToScript
  module Generator
    module Segmental
      module DirectDraw
        #
        # Vertical scan lines.
        #
        class Vertical < DirectDraw
          include VerticalMixin
        end
      end
    end
  end
end
