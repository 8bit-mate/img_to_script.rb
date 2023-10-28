# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class AbstractToken
      attr_reader :type, :require_nl

      def initialize(require_nl:, **)
        @require_nl = require_nl
      end
    end
  end
end
