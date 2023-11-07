# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Store array of contants.
    #
    class DataStore < AbstractToken
      attr_reader :data

      def initialize(data:, **)
        @type = AbsTokenType::DATA_STORE
        @data = Array(data)

        super
      end
    end
  end
end
