# frozen_string_literal: true

module ImgToScript
  module Language
    module MK90Basic
      #
      # Designed to use with the MK90 BASIC translator & formatter.
      #
      class MK90BasicToken < LanguageToken
        attr_accessor :keyword, :args, :separator, :require_nl, :sliceable

        #
        # Initialize a new BASIC token.
        #
        # @param [String] keyword
        #   Statement keyword (e.g.: "PRINT", "FOR", "CLS").
        #
        # @param [Array<Numeric, String>] args
        #   Statement arguments (e.g.: %i[10 20 30 40]).
        #
        # @param [String] separator
        #   Separator between arguments. Commonly a comma or
        #   an 'empty' string (no separation between arguments).
        #
        # @param [Boolean] require_nl
        #   Defines if the statement should be placed on a new line.
        #
        # @param [Boolean] sliceable
        #   Defines if the statement allows to 'slice' its arguments,
        #   to move some of them on a new line if the expression doesn't
        #   fit into a current line. Examples:
        #
        #  sliceable = true:
        #                              | <- max. characters per line limit
        #   10 DATA 1, [omitted...], 8, 9, 10, 11
        #      =>                      |
        #   10 DATA 1, [omitted...], 8
        #   20 DATA 9, 10, 11          |
        #
        #  sliceable = false:
        #                              |
        #   10 [omitted...]:PRINT"HELLO, WORLD!"
        #      =>                      |
        #   10 [omitted...]            |
        #   20 PRINT"HELLO, WORLD!"    |
        #
        def initialize(keyword:, args:, separator:, require_nl:, sliceable:)
          @keyword = keyword
          @args = args
          @separator = separator
          @require_nl = require_nl
          @sliceable = sliceable

          super()
        end
      end
    end
  end
end
