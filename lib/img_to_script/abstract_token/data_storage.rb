# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Store array of contants.
    #
    class DataStorage < AbstractToken
      attr_reader :data

      def initialize(data:, **)
        @type = :data_storage
        @data = Array(data)

        super
      end
    end
  end
end
