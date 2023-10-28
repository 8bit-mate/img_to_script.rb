# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class ClearScreen < AbstractToken
      def initialize(**)
        @type = :clear_screen
        super
      end
    end
  end
end
