# frozen_string_literal: true

require_relative "test_helper"

require "rmagick/bin_magick"

class TestMk90Task < Minitest::Test
  def _task
    task = ImgToScript::Task.new

    task.generator.configure do |config|
      config.clear_screen = false
      config.pause_program = false
    end

    task
  end

  def test_hex_mask_enhanced_all_white_px
    image = Magick::BinMagick::Image.from_file(__dir__ << "/data/test_2.png")

    script = _task.run(
      image: image,
      scr_height: ImgToScript::Languages::MK90Basic::SCR_HEIGHT,
      scr_width: ImgToScript::Languages::MK90Basic::SCR_WIDTH
    )

    assert_equal [], script
  end

  def test_hex_mask_enhanced_all_black_px
    image = Magick::BinMagick::Image.from_file(__dir__ << "/data/test_3.png")

    script = _task.run(
      image: image,
      scr_height: ImgToScript::Languages::MK90Basic::SCR_HEIGHT,
      scr_width: ImgToScript::Languages::MK90Basic::SCR_WIDTH
    )

    assert_equal ["1FORI=1TO960:DRAWMFF:NEXTI"], script
  end
end
