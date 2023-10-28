# frozen_string_literal: true

require "test_helper"

class TestAbstractToken < Minitest::Test
  def test_cls
    cls_token = ImgToScript::AbstractToken::ClearScreen.new(require_nl: false)
    data_token = ImgToScript::AbstractToken::DataStorage.new(data: ["a"], require_nl: false)

    trans = ImgToScript::Translator::MK90Basic::MK90Basic.new
    
    arr = [cls_token, data_token]

    p trans.translate(arr)
  end
end
