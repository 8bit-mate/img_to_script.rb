# frozen_string_literal: true

module ImgToScript
  #
  # Handles conversion.
  #
  class Task
    include Import[
      generator: "generators.hex_mask.enhanced",
      image_processor: "languages.mk90_basic.image_processor",
      translator: "languages.mk90_basic.translator.mk90_basic_10",
      formatter: "languages.mk90_basic.formatter.minificator"
    ]

    def call(image:, scr_width:, scr_height:, **)
      @formatter.format(
        @translator.translate(
          @generator.generate(
            image: @image_processor.call(image),
            scr_width: scr_width,
            scr_height: scr_height
          )
        )
      )
    end
  end
end
