# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Marks loop end.
    #
    class LoopEnd < AbstractToken
      attr_reader :var_name

      def initialize(var_name:, **)
        @var_name = var_name
        @type = :loop_end

        super
      end
    end
  end
end
