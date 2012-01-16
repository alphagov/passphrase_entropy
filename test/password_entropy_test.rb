# encoding: UTF-8

require "minitest/autorun"
require "password_entropy"

class PasswordEntropyTest < MiniTest::Unit::TestCase
  EPSILON = 1e-2

  def test_should_calculate_entropy_digits
    password = "0"
    entropy = 3.3219 # log2(10)
    assert_in_delta entropy, PasswordEntropy.entropy(password), EPSILON
  end

  def test_should_calculate_entropy_of_lower_case
    password = "a"
    entropy = 4.7004 # log2(26)
    assert_in_delta entropy, PasswordEntropy.entropy(password), EPSILON
  end

  def test_should_calculate_entropy_of_upper_case
    password = "A"
    entropy = 4.7004 # log2(26)
    assert_in_delta entropy, PasswordEntropy.entropy(password), EPSILON
  end

  def test_should_calculate_entropy_of_lower_case_with_digits
    password = "a0"
    entropy = 2 * 5.1699 # log2(26 + 10)
    assert_in_delta entropy, PasswordEntropy.entropy(password), EPSILON
  end

  def test_should_calculate_entropy_of_upper_case_with_digits
    password = "A0"
    entropy = 2 * 5.1699 # log2(26 + 10)
    assert_in_delta entropy, PasswordEntropy.entropy(password), EPSILON
  end

  def test_should_calculate_entropy_of_mixed_case_with_digits
    password = "Aa0"
    entropy = 3 * 5.9542 # log2(26 + 26 + 10)
    assert_in_delta entropy, PasswordEntropy.entropy(password), EPSILON
  end

  def test_should_calculate_entropy_of_keyboard_characters
    password = "Aa0~"
    entropy = 4 * 6.5699 # log2(95)
    assert_in_delta entropy, PasswordEntropy.entropy(password), EPSILON
  end

  def test_should_calculate_entropy_of_non_ascii_content
    password = "é" # 2 bytes of UTF-8
    entropy = 2 * 7.0 # log2(128)
    assert_in_delta entropy, PasswordEntropy.entropy(password), EPSILON
  end

  def test_should_calculate_entropy_of_empty_string
    assert_in_delta 0.000, PasswordEntropy.entropy(""), EPSILON
  end

  def test_should_not_modify_string
    password = "é"
    before = password.dup
    dont_care = PasswordEntropy.entropy(password)
    assert_equal before, password
  end
end
