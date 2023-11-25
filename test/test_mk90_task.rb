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
  
  def test_custom_task
    image = Magick::BinMagick::Image.from_file(__dir__ << "/data/test_5.png")

    generator = ImgToScript::Generators::Segmental::DirectDraw::Horizontal.new.configure do |config|
      config.x_offset = 10
      config.y_offset = 15
      config.clear_screen = false
      config.pause_program = false
    end

    translator = ImgToScript::Languages::MK90Basic::Translators::MK90Basic10.new

    formatter = ImgToScript::Languages::MK90Basic::Formatters::Minificator.new.configure do |config|
      config.line_offset = 10
      config.line_step = 5
    end

    task = ImgToScript::Task.new(
      generator: generator,
      translator: translator,
      formatter: formatter
    )

    script = task.run(
      image: image,
      scr_width: 120,
      scr_height: 64
    )

    assert_equal ["10DRAWD10,15,17,15"], script
  end
end
