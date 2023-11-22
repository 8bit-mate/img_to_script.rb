# frozen_string_literal: true

module ImgToScript
  module Languages
    module MK90Basic
      module Formatter
        #
        # The aim of the minificator is to make the ouput as compact as
        # possible, and so to save space at the MPO-10 cart.
        #
        # The minificator:
        #   1. doesn't put spaces (as MK90's BASIC lexer ignores them);
        #   2. adds as many characters to a line as possible.
        #      This minimizes the number of CR+LF sequences.
        #
        class Minificator < Formatter
          SEP_BETWEEN_STATEMENTS = ":"

          private

          #
          # Append a token to the BASIC script.
          #
          def _append_token(token)
            @token = token
            @placeholders_idx = _get_placeholders_idx

            _format_token_arguments

            if @token.sliceable
              _process_sliceable_token
            else
              _process_non_sliceable_token
            end
          end

          #
          # Process a token with a statement that can be splitted and
          # continued on a next line.
          #
          def _process_sliceable_token
            @current_arg_idx = 0

            _append_arg until @current_arg_idx == @args.length
          end

          #
          # Append an argument of the sliceable statement.
          #
          def _append_arg
            @current_arg = @args[@current_arg_idx].to_s

            if @current_arg_idx.zero?
              # The first argument should be handled differently (since a
              # keyword should be prepended first).
              _append_arg_with_keyword
            else
              # The rest arguments are processed in a batch.
              _append_rest_sliceable_args
            end

            @current_arg_idx += 1
          end

          #
          # Append the keyword of a sliceable statement, when attach an
          # argument to it.
          #
          # There are two situations when this happens:
          # 1. the argument is the first in the arguments array;
          # 2. the statement was splitted and should be continued on a new line.
          #
          def _append_arg_with_keyword
            statement = "#{@token.keyword}#{@current_arg}"

            if @token.require_nl
              # Statement explicitly demands to be on a new line
              _append_to_new_line(statement)
              return
            end

            if _calc_sliceable_statement_keyword_length <= @max_chars_per_line
              # There is enough space in the current BASIC line to add a new keyword + the next arg. pair.
              _append_to_current_line(statement)
            else
              # There is not enough space in the current BASIC line, create a new one.
              _append_to_new_line(statement)
            end
          end

          def _append_rest_sliceable_args
            if _calc_current_line_plus_argument_length <= @max_chars_per_line
              # There is enough space in the current BASIC line to add another argument.
              _append_new_argument_to_current_line
            else
              # There is not enough space in the current BASIC line, create a new one.
              _append_arg_with_keyword
            end
          end

          #
          # Append current argument of the sliceable statement to a current line.
          #
          def _append_new_argument_to_current_line
            @script[-1] += @token.separator + @current_arg.to_s
          end

          #
          # Length of a current line with a current argument of the sliceable
          # statement.
          #
          # @return [Integer]
          #
          def _calc_current_line_plus_argument_length
            _get_current_line_content.length +
              @current_arg.length +
              @token.separator.length
          end

          #
          # Process a token with a statement that cannot be splitted, i.e. it
          # should be lined up within a single BASIC line.
          #
          def _process_non_sliceable_token
            _evaluate_placeholders

            if @token.require_nl
              # Statement explicitly demands to be on a new line.
              _append_to_new_line(_non_sliceable_statement)
            else
              # Statement potentially can be added to a current line.
              _try_to_append_non_sliceble_to_current_line
            end
          end

          #
          # Try to append a non-sliceable statement to a current line.
          #
          # There are situations when it can't be done:
          # 1. current line is empty (that means it is not numbered yet).
          # 2. there's no enough space in the current line to append the
          # statement.
          #
          def _try_to_append_non_sliceble_to_current_line
            if _get_current_line_content.empty?
              _append_to_new_line(_non_sliceable_statement)
              return
            end

            if _calc_non_sliceable_statement_length <= @max_chars_per_line
              _append_to_current_line(_non_sliceable_statement)
            else
              _append_to_new_line(_non_sliceable_statement)
            end
          end

          #
          # Return current BASIC line, i.e. the last element of the @script
          # array.
          #
          # @return [String]
          #
          def _get_current_line_content
            @script[-1] || ""
          end

          #
          # Return a formatted non-sliceable statement.
          #
          # @return [String]
          #
          def _non_sliceable_statement
            @token.keyword + @args.join(@token.separator)
          end

          def _update_line_num
            @n_line += @line_step

            # Since line number has been changed, it is required to
            # re-evaluate placeholders with the updated value.
            _evaluate_placeholders
          end

          #
          # Append statement to the current BASIC line.
          #
          # @param [String] statement
          #   Statement to append in a String formatted form, e.g.: "ABS(X+L)"
          #
          def _append_to_current_line(statement)
            @script[-1] += "#{SEP_BETWEEN_STATEMENTS}#{statement}"
          end

          #
          # Append statement to a new BASIC line.
          #
          # @param [String] statement
          #   Statement to append in a String formatted form, e.g.: "ABS(X+L)"
          #
          def _append_to_new_line(statement)
            # Since a new line is about to be created, the line number should
            # be updated first.
            _update_line_num

            new_line = "#{_select_line_label}#{statement}"
            @script << new_line
          end

          #
          # @return [String]
          #
          def _select_line_label
            @number_lines ? @n_line.to_s : ""
          end

          #
          # Full length of a non-sliceable statement.
          #
          # @return [Integer]
          #
          def _calc_non_sliceable_statement_length
            _get_current_line_content.length +
              _non_sliceable_statement.length +
              SEP_BETWEEN_STATEMENTS.length
          end

          #
          # Keyword + first argument length.
          #
          # @return [Integer]
          #
          def _calc_sliceable_statement_keyword_length
            _get_current_line_content.length +
              @token.keyword.length +
              @current_arg.length +
              SEP_BETWEEN_STATEMENTS.length
          end

          #
          # Evaluate current line number placeholders in the token's arguments.
          #
          def _evaluate_placeholders
            @placeholders_idx.each do |i|
              e = @token.args[i]
              @args[i] = @n_line + e.shift * @line_step
            end
          end

          #
          # For an argument what is a token (i.e. a nested token): pass the
          # argument to a new instance of the minificator, and append the
          # argument in a formatted form (a String).
          #
          # For the arguments of other types: append as is.
          #
          def _format_token_arguments
            @args = []
            @token.args.each do |arg|
              if arg.is_a?(MK90Basic::MK90BasicToken)
                @args.append(_format_nested_token(arg))
              else
                @args.append(arg)
              end
            end
          end

          #
          # Format a nested token.
          #
          # @return [String]
          #
          def _format_nested_token(token)
            arr = _minificator.format(
              Array(token)
            )

            case arr.length
            when 0
              # @todo: warn: minificator returned an empty arr!
              ""
            when 1
              # ok!
              arr.first
            else
              # @todo: warn: statement doesn't fit to a single line!
              arr.first
            end
          end

          #
          # Return a minificator instance to format a nested token.
          #
          # @return [Minificator]
          #   A new Minificator instance.
          #
          def _minificator
            Minificator.new.configure do |config|
              config.number_lines = false
            end
          end

          #
          # Return array of indexes of the placeholders.
          #
          # @return [Array<Integer>]
          #
          def _get_placeholders_idx
            @token.args.each_index.select do |i|
              @token.args[i].is_a?(CurrentLinePlaceholder)
            end
          end
        end
      end
    end
  end
end
