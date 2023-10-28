# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class Wait < AbstractToken
      attr_accessor :time

      def initialize(time:, **)
        @time = time
        @type = :wait
        super
      end
    end
  end
end
