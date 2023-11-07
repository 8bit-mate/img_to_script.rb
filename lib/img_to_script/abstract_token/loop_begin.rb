# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Begin a loop.
    #
    class LoopBegin < AbstractToken
      attr_reader :var_name, :start_value, :end_value

      def initialize(var_name:, start_value:, end_value:, **)
        @type = AbsTokenType::LOOP_BEGIN
        @var_name = var_name
        @start_value = start_value
        @end_value = end_value

        super
      end
    end
  end
end
