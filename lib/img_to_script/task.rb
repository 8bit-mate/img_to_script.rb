# frozen_string_literal: true

module ImgToScript
  #
  # Handles conversion.
  #
  class Task
    include Import[
      generator: "generators.hex_mask.enhanced",
      translator: "languages.mk90_basic.translators.mk90_basic_10",
      formatter: "languages.mk90_basic.formatters.minificator"
    ]

    def run(image:, scr_width:, scr_height:, **)
      @formatter.format(
        @translator.translate(
          @generator.generate(
            image: image,
            scr_width: scr_width,
            scr_height: scr_height
          )
        )
      )
    end
  end
end
