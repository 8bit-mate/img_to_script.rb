# frozen_string_literal: true

module ImgToScript
  #
  # Base class.
  #
  # Formatters format array of target language tokens to an
  # executable script.
  #
  # A formatter's responsibility is to label BASIC lines, put
  # separators between the statements' and their arguments, etc.
  #
  class Formatter; end
end
