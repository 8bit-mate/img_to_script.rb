# frozen_string_literal: true

module ImgToScript
  module AbstractToken
    #
    # Marks end of the program.
    #
    class ProgramEnd < AbstractToken
      def initialize(**)
        @type = :program_end

        super
      end
    end
  end
end
