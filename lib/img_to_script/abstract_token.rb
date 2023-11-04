# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Stores single command in an abstract representation.
    #
    class AbstractToken
      attr_reader :type, :require_nl

      def initialize(require_nl: false, **)
        @require_nl = require_nl
      end
    end
  end
end
