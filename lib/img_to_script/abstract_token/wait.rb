# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Pause a program run.
    #
    class Wait < AbstractToken
      attr_reader :time

      def initialize(time:, **)
        @type = AbsTokenType::WAIT
        @time = time

        super
      end
    end
  end
end
