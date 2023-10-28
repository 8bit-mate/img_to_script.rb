# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    class DataStorage < AbstractToken
      attr_accessor :data

      def initialize(data:, **)
        @data = data
        @type = :data_storage
        super
      end
    end
  end
end
