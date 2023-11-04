# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Marks begin of the program.
    #
    class ProgramBegin < AbstractToken
      def initialize(**)
        @type = :program_begin

        super
      end
    end
  end
end
