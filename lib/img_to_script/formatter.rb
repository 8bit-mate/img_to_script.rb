# frozen_string_literal: true

module ImgToScript
  #
  # Formatters format array of target language tokens to an
  # executable script.
  #
  # A formatter's responsibility is to label BASIC lines, put
  # separators between the statements' and their arguments, etc.
  #
  module Formatter
    #
    # Base class.
    #
    class Formatter; end
  end
end
