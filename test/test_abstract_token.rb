# frozen_string_literal: true

require_relative "test_helper"

require "rmagick/bin_magick"

class TestAbstractToken < Minitest::Test
  def test_cls
    Magick::BinMagick::Image.from_file(__dir__ << "/data/test_2.png")

    # let_token = ImgToScript::AbstractToken::AssignValue.new(expression: "X=X+1", require_nl: false)
    # cls_token = ImgToScript::AbstractToken::ClearScreen.new(require_nl: false)
    # data_token = ImgToScript::AbstractToken::DataStore.new(data: ["a"], require_nl: false)
    # goto_token = ImgToScript::AbstractToken::GoTo.new(line: ImgToScript::CurrentLinePlaceholder.new(-70),
    #                                                   require_nl: true)
    # draw = ImgToScript::AbstractToken::DrawLineByAbsCoords.new(x0: 10, y0: 20, x1: 30, y1: 40, require_nl: false)

    # trans = ImgToScript::Translator::MK90Basic::MK90Basic10.new
    # form = ImgToScript::Formatter::MK90Basic::Minificator.new

    # # arr = [let_token, cls_token, data_token, goto_token, goto_token, goto_token, goto_token, goto_token, goto_token, goto_token, goto_token]

    # arr = [goto_token, let_token, let_token, let_token, let_token, cls_token, draw]

    # p form.format(trans.translate(arr))

    # abs = ImgToScript::Generators::RunLengthEncoding::Horizontal.new.generate(image: image, scr_height: 64, scr_width: 120)
    # toks = ImgToScript::Languages::MK90Basic::Translator::MK90Basic20.new.translate(abs)
    # puts ImgToScript::Languages::MK90Basic::Formatter::Minificator.new.format(toks)
  end

  def test_tmp
    let_token = ImgToScript::AbstractToken::AssignValue.new(
      left: "X",
      # right: "****************************************************************************",
      right: ImgToScript::AbstractToken::AssignValue.new(
        left: "Y",
        right: "lel",
        require_nl: true
      ),
      require_nl: false
    )

    goto_token1 = ImgToScript::AbstractToken::GoTo.new(line: ImgToScript::CurrentLinePlaceholder.new(0),
                                                       require_nl: false)

    # let_token = ImgToScript::AbstractToken::AssignValue.new(
    #   left: "X",
    #   right: 10,
    #   require_nl: false
    # )

    toks = ImgToScript::Languages::MK90Basic::Translator::MK90Basic10.new.translate(
      [let_token, goto_token1]
    )

    p ImgToScript::Languages::MK90Basic::Formatter::Minificator.new.format(toks)

    image = Magick::BinMagick::Image.from_file(__dir__ << "/data/test_1.png")
    abs = ImgToScript::Generators::RunLengthEncoding::Vertical.new.generate(image: image, scr_height: 64,
                                                                            scr_width: 120)

    # abs.append(goto_token1)

    toks = ImgToScript::Languages::MK90Basic::Translator::MK90Basic10.new.translate(abs)
    form = ImgToScript::Languages::MK90Basic::Formatter::Minificator.new.configure do |config|
      config.line_step = 1
      config.line_offset = 1
    end
    puts form.format(toks)


    puts ImgToScript::Task.new.call(image: image, scr_height: 64,
                                 scr_width: 120)
  end
end
