# frozen_string_literal: true

module ImgToScript
  #
  # BASIC known by its widely usage of the GOTO construction.
  # It is a common practice to use statements like N GOTO N + m
  # (i.e. jump m lines away from the current line N).
  #
  # When a generator generates an abstract token, it doesn't know
  # anything about the current line or its number yet. It is only
  # when a formatter gets into the game, this values can be
  # calculated.
  #
  # Thus, at the generation step a placeholder is being used to mark
  # the current line number.
  #
  # Placeholders' job it to tell the formatter that the argument
  # should be replaced with the actual line number value.
  #
  # The optional attribute 'shift' allows use a relative jump from
  # the current line to a line that is above (a negative value) or
  # to a line that's behind (a positive value) of the current line.
  #
  # Shift value is in steps.
  #
  class CurrentLinePlaceholder
    attr_reader :shift

    #
    # Initialize a placeholder.
    #
    # @param [Integer] shift
    #   A relative shift of the current line number.
    #
    def initialize(shift = 0)
      @shift = shift
    end
  end
end
