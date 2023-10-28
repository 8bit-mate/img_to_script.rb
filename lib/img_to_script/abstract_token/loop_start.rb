# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class LoopStart < AbstractToken
      attr_reader :var_name, :start_value, :end_value

      def initialize(var_name:, start_value:, end_value:, **)
        @var_name = var_name
        @start_value = start_value
        @end_value = end_value
        @type = :loop_start
        
        super
      end
    end
  end
end
