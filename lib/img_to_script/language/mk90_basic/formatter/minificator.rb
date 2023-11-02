# frozen_string_literal: true

module ImgToScript
  module Language
    module MK90Basic
      module Formatter
        #
        # The aim of the minificator is to make the ouput as compact
        # as possible, and so to save space at the MPO-10 cart.
        #
        # The minificator:
        #   1. doesn't put spaces (as MK90's BASIC lexer ignores them);
        #   2. adds as many characters to a line as possible.
        #      This minimizes the number of CR+LF sequences.
        #
        class Minificator < Formatter
          private

          #
          # Append a token to the BASIC script.
          #
          def _append_token(token)
            @token = token
            @placeholders_idx = _get_placeholders_idx

            _expand_args

            if @token.sliceable
              _process_sliceable_token
            else
              _process_non_sliceable_token
            end
          end

          def _get_placeholders_idx
            @token.args.each_index.select do |i|
              @token.args[i].is_a?(CurrentLinePlaceholder)
            end
          end

          def _process_sliceable_token
            @current_arg_idx = 0

            _append_arg until @current_arg_idx == @args.length
          end

          def _append_arg
            @next_arg = @args[@current_arg_idx].to_s

            if @current_arg_idx.zero?
              # The first arg. should be handled differently.
              _handle_first_sliceable_arg
            else
              # All the rest arguments are processed in a batch.
              _handle_rest_sliceable_args
            end

            @current_arg_idx += 1
          end

          def _handle_rest_sliceable_args
            if _get_current_line_content.length + @next_arg.length + @token.separator.length <= @max_chars_per_line
              # There is enough space in the current BASIC line to add a new argument.
              @script[-1] += @token.separator + @next_arg.to_s
            else
              # There is not enough space in the current BASIC line, create a new one.
              statement = "#{@token.keyword}#{@next_arg}"
              _update_line_num
              _append_to_new_line(statement)
            end
          end

          #
          # Append the first argument of the sliceable statement.
          #
          # If the argument is the first in the argument list, a keyword should be prepended.
          #
          def _handle_first_sliceable_arg
            statement = "#{@token.keyword}#{@next_arg}"

            if _get_current_line_content.empty?
              _append_first_arg_to_current_line(statement)
              return
            end

            if _calc_sliceable_statement_length <= @max_chars_per_line
              # There is enough space in the current BASIC line to add a new keyword + the next arg. pair.
              _append_first_arg_to_current_line(statement)
            else
              # There is not enough space in the current BASIC line, create a new one.
              _update_line_num
              _append_to_new_line(statement)
            end
          end

          def _append_first_arg_to_current_line(statement)
            _append_to_current_line(statement)
          end

          def _process_non_sliceable_token
            _evaluate_placeholders

            if @token.require_nl
              # Statement explicitly demands to be on a new line
              _append_non_sliceable_to_new_line
            else
              # Statement potentially can be added to a current line
              _try_to_append_non_sliceble_to_current_line
            end
          end

          def _try_to_append_non_sliceble_to_current_line
            if _get_current_line_content.empty?
              _append_non_sliceable_to_new_line
              return
            end

            if _calc_non_sliceable_statement_length <= @max_chars_per_line
              _append_non_sliceable_to_current_line
            else
              _append_non_sliceable_to_new_line
            end
          end

          def _get_current_line_content
            @script[-1] || ""
          end

          def _get_non_sliceable_statement
            @token.keyword + @args.join(@token.separator)
          end

          def _append_non_sliceable_to_current_line
            _append_to_current_line(_get_non_sliceable_statement)
          end

          def _append_non_sliceable_to_new_line
            _update_line_num
            _append_to_new_line(_get_non_sliceable_statement)
          end

          def _update_line_num
            @n_line += 1

            # Since line number has been changed, it is required to
            # re-evaluate placeholders with the updated value.
            _evaluate_placeholders
          end

          def _append_to_current_line(statement)
            if @script[-1]
              @script[-1] += ":#{statement}"
            else
              _update_line_num
              _append_to_new_line(statement)
            end
          end

          def _append_to_new_line(statement)
            new_line = "#{_select_line_label}#{statement}"

            if new_line.length > @max_chars_per_line
              # @todo WARN
            end

            @script << new_line
          end

          def _select_line_label
            @number_lines ? @n_line.to_s : ""
          end

          def _calc_non_sliceable_statement_length
            # +1 in the sum is for a colon between two statements.
            arg_sum = @args.join(@token.separator).length
            _get_current_line_content.length + @token.keyword.length + arg_sum + 1
          end

          def _calc_sliceable_statement_length
            # +1 in the sum is for a colon between statements.
            _get_current_line_content.length + @token.keyword.length + @next_arg.length + 1
          end

          def _evaluate_placeholders
            @placeholders_idx.each do |i|
              e = @token.args[i]
              @args[i] = (@n_line + e.shift).to_s
            end
          end

          def _add_new_empty_line
            @script.push("")
          end

          def _expand_args
            @args = []
            @token.args.each do |arg|
              if arg.is_a?(MK90Basic::MK90BasicToken)
                @args.append(Minificator.new.format(
                  Array(arg), number_lines: false
                ).first)
              else
                @args.append(arg)
              end
            end
          end
        end
      end
    end
  end
end
