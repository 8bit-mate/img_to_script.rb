# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Marks begin of the program.
    #
    class ProgramStart < AbstractToken
      def initialize(**)
        @type = :program_start

        super
      end
    end
  end
end
