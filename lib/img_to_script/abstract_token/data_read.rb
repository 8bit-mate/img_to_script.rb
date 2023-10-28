# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class DataRead < AbstractToken
      attr_accessor :var_list

      def initialize(var_list:, **)
        @var_list = var_list
        @type = :data_read
        super
      end
    end
  end
end
