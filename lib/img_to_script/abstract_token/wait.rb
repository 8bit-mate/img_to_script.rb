# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Pause a program run.
    #
    class Wait < AbstractToken
      attr_accessor :time

      def initialize(time:, **)
        @type = :wait
        @time = time

        super
      end
    end
  end
end
