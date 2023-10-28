# frozen_string_literal: true

require "test_helper"

class TestAbstractToken < Minitest::Test
  def test_cls
    let_token = ImgToScript::AbstractToken::AssignValue.new(expression: "X=X+1", require_nl: false)
    cls_token = ImgToScript::AbstractToken::ClearScreen.new(require_nl: false)
    data_token = ImgToScript::AbstractToken::DataStorage.new(data: ["a"], require_nl: false)

    trans = ImgToScript::Translator::MK90Basic::MK90Basic10.new
    
    arr = [let_token, cls_token, data_token]

    p trans.translate(arr)
  end
end
