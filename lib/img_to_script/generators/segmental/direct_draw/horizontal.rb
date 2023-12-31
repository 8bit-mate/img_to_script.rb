# frozen_string_literal: true

module ImgToScript
  module Generators
    module Segmental
      module DirectDraw
        #
        # Horizontal scan lines.
        #
        class Horizontal < DirectDraw
          include HorizontalMixin
        end
      end
    end
  end
end
