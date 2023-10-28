# frozen_string_literal: true

require "test_helper"

class TestImgToScript < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ImgToScript::VERSION
  end

  def test_container_keys_arr_is_not_empty
    refute_empty ::ImgToScript::Container.keys
  end
end
