# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class DataRead < AbstractToken
      attr_reader :var_list

      def initialize(var_list:, **)
        @type = :data_read
        @var_list = var_list

        super
      end
    end
  end
end
