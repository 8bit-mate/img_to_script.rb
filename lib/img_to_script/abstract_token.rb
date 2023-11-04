# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Stores single command in an abstract representation.
    #
    class AbstractToken
      attr_reader :type, :require_nl

      #
      # Init. a new abstract token.
      #
      # @option [Boolean] require_nl (false)
      #   If 'true', the formatter will put the statement, that is
      #   assotiated with the token, on a new line.
      #
      def initialize(require_nl: false, **)
        @require_nl = require_nl
      end
    end
  end
end
