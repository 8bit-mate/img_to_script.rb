# frozen_string_literal: true

module ImgToScript
  module Formatter
    module MK90Basic
      #
      # The aim of the minificator is to make the ouput as compact
      # as possible, and so to save space at the MPO-10 cart.
      #
      # This formatter:
      #   1. doesn't put spaces (as MK90's BASIC lexer ignores them);
      #   2. adds as many characters to a line as possible.
      #      This minimizes the number of CR+LF sequences.
      #
      class Minificator < MK90Basic
        private

        #
        # Append a token to the BASIC script.
        #
        def _append_token(token)
          @token = token

          # _merge_args unless @token.sliceable

          _ensure_args_not_empty

          @current_arg_idx = 0
          @script.push("") if @token.require_nl && @script.last != ""

          @args = Marshal.load(Marshal.dump(@token.args))

          _append_arg until @current_arg_idx == @args.length
        end

        def _evaluate_placeholders
          @token.args.each_with_index do |e, idx|
            @args[idx] = if e.is_a?(CurrentLinePlaceholder)
                           "PLACEHOLDER MUTHERFUKKER:#{@n_line + e.shift}"
                         else
                           @token.args[idx]
                         end
          end
        end

        #
        # Append next argument to the BASIC script.
        #
        def _append_arg
          _evaluate_placeholders

          @next_arg = @args[@current_arg_idx].to_s
          @current_line = @script[-1]

          if @current_arg_idx.zero?
            # The first arg. in the list should be handled differently.
            _handle_first_arg
          else
            # All the rest arguments in the list are processed in a batch.
            _handle_rest_arg
          end

          @current_arg_idx += 1
        end

        #
        # Append the first argument of the statement.
        #
        # If the argument is the first in the argument list, a keyword should be added before it.
        #
        def _handle_first_arg
          if @current_line.empty?
            @script.pop
            _append_to_new_line
            return
          end

          # @todo check sliceable

          # +1 in the sum is for a colon between statements.
          sum = _calc_statement_length

          if sum <= @max_chars_per_line
            # There is enough space in the current BASIC line to add a new keyword + the next arg. pair.
            _append_first_arg_to_current_line
          else
            # There is not enough space in the current BASIC line, create a new one.
            _append_to_new_line
          end
        end

        def _calc_statement_length
          # +1 in the sum is for a colon between statements.
          if @token.sliceable
            @current_line.length + @token.keyword.length + @next_arg.length + 1
          else
            arg_sum = @args.join(@token.separator).length
            @current_line.length + @token.keyword.length + arg_sum + 1
          end
        end

        #
        # Append all the rest arguments.
        #
        def _handle_rest_arg
          if @current_line.length + @next_arg.length + @token.separator.length <= @max_chars_per_line
            # There is enough space in the current BASIC line to add a new argument.
            @script[-1] += @token.separator + @next_arg.to_s
          else
            # There is not enough space in the current BASIC line, create a new one.
            _append_to_new_line
          end
        end

        #
        # Append a keyword + first argument pair to the current line.
        # Current line at this point is not empty, i.e. has some
        # prepending statements.
        #
        # Use a colon to separate a new statement from the previous one.
        #
        def _append_first_arg_to_current_line
          @script[-1] += ":#{@token.keyword}#{@next_arg}"
        end

        #
        # Append a new numbered BASIC line with the keyword + arg. pair.
        #
        def _append_to_new_line
          @n_line += @line_step
          _evaluate_placeholders

          @next_arg = @args[@current_arg_idx].to_s

          @script << @n_line.to_s + @token.keyword + @next_arg.to_s
        end

        #
        # Some BASIC statements are just keywords without arguments, e.g.: CLS.
        # This little hack ensures that there's always at least one "empty" argument
        # in the argument list. And now the algorithm won't crash ;)
        #
        def _ensure_args_not_empty
          @token.args = [""] if @token.args.empty?
        end

        #
        # If a statement isn't sliceable, we can merge its keyword and all the
        # arguments into one large  @token.keyword string.
        #
        # When we replace statement's argument list with a single "empty" argument,
        # because @token.args array always should have at least one empty element.
        #
        def _merge_args
          @token.keyword += @token.args.join(@token.separator)
          @token.args = [""]
        end
      end
    end
  end
end
