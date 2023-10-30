# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Read value(s) from an array of constants.
    #
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
