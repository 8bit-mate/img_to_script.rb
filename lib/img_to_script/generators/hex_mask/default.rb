# frozen_string_literal: true

module ImgToScript
  module Generators
    module HexMask
      #
      # Generates image rendering script with the DRAM/M statements only
      # (without 'enhacements').
      #
      class Default < HexMask
        private

        def _generate
          @tokens.append(
            AbstractToken::DrawChunkByHexValue.new(
              hex_values: _encode_img,
              require_nl: true
            )
          )
        end
      end
    end
  end
end
