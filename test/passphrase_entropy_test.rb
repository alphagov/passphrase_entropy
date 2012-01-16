# encoding: UTF-8

require "minitest/autorun"
require "passphrase_entropy"

class PassphraseEntropyTest < MiniTest::Unit::TestCase
  EPSILON = 1e-2

  def test_should_calculate_entropy_digits
    passphrase = "0"
    entropy = 3.3219 # log2(10)
    assert_in_delta entropy, PassphraseEntropy.entropy(passphrase), EPSILON
  end

  def test_should_calculate_entropy_of_lower_case
    passphrase = "a"
    entropy = 4.7004 # log2(26)
    assert_in_delta entropy, PassphraseEntropy.entropy(passphrase), EPSILON
  end

  def test_should_calculate_entropy_of_upper_case
    passphrase = "A"
    entropy = 4.7004 # log2(26)
    assert_in_delta entropy, PassphraseEntropy.entropy(passphrase), EPSILON
  end

  def test_should_calculate_entropy_of_lower_case_with_digits
    passphrase = "a0"
    entropy = 2 * 5.1699 # log2(26 + 10)
    assert_in_delta entropy, PassphraseEntropy.entropy(passphrase), EPSILON
  end

  def test_should_calculate_entropy_of_upper_case_with_digits
    passphrase = "A0"
    entropy = 2 * 5.1699 # log2(26 + 10)
    assert_in_delta entropy, PassphraseEntropy.entropy(passphrase), EPSILON
  end

  def test_should_calculate_entropy_of_mixed_case_with_digits
    passphrase = "Aa0"
    entropy = 3 * 5.9542 # log2(26 + 26 + 10)
    assert_in_delta entropy, PassphraseEntropy.entropy(passphrase), EPSILON
  end

  def test_should_calculate_entropy_of_keyboard_characters
    passphrase = "Aa0~"
    entropy = 4 * 6.5699 # log2(95)
    assert_in_delta entropy, PassphraseEntropy.entropy(passphrase), EPSILON
  end

  def test_should_calculate_entropy_of_non_ascii_content
    passphrase = "é" # 2 bytes of UTF-8
    entropy = 2 * 7.0 # log2(128)
    assert_in_delta entropy, PassphraseEntropy.entropy(passphrase), EPSILON
  end

  def test_should_calculate_entropy_of_empty_string
    assert_in_delta 0.000, PassphraseEntropy.entropy(""), EPSILON
  end

  def test_should_not_modify_string
    passphrase = "é"
    before = passphrase.dup
    dont_care = PassphraseEntropy.entropy(passphrase)
    assert_equal before, passphrase
  end
end
