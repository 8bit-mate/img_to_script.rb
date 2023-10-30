# frozen_string_literal: true

require_relative "test_helper"

require "rmagick/bin_magick"

class TestAbstractToken < Minitest::Test
  def test_cls
    image = Magick::BinMagick::Image.from_file(__dir__ << "/data/test_4.png")

    # let_token = ImgToScript::AbstractToken::AssignValue.new(expression: "X=X+1", require_nl: false)
    # cls_token = ImgToScript::AbstractToken::ClearScreen.new(require_nl: false)
    # data_token = ImgToScript::AbstractToken::DataStorage.new(data: ["a"], require_nl: false)
    # goto_token = ImgToScript::AbstractToken::GoTo.new(line: ImgToScript::CurrentLinePlaceholder.new(-70),
    #                                                   require_nl: true)
    # draw = ImgToScript::AbstractToken::DrawLineByAbsCoords.new(x0: 10, y0: 20, x1: 30, y1: 40, require_nl: false)

    # trans = ImgToScript::Translator::MK90Basic::MK90Basic10.new
    # form = ImgToScript::Formatter::MK90Basic::Minificator.new

    # # arr = [let_token, cls_token, data_token, goto_token, goto_token, goto_token, goto_token, goto_token, goto_token, goto_token, goto_token]

    # arr = [goto_token, let_token, let_token, let_token, let_token, cls_token, draw]

    # p form.format(trans.translate(arr))

    abs = ImgToScript::Generator::HexMask::Default.new.generate(image: image, scr_height: 64, scr_width: 120)
    toks = ImgToScript::Language::MK90Basic::Translator::MK90Basic20.new.translate(abs)
    puts ImgToScript::Language::MK90Basic::Formatter::Minificator.new.format(toks)
  end
end
