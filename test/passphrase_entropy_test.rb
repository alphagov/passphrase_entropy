# encoding: UTF-8

require "minitest/autorun"
require "passphrase_entropy"

class PassphraseEntropyTest < MiniTest::Unit::TestCase

  def setup
    @passphrase_entropy = PassphraseEntropy.new
  end

  def assert_better(better, worse)
    eb = @passphrase_entropy.entropy(better)
    ew = @passphrase_entropy.entropy(worse)
    assert(eb > ew, "Expected #{better} (#{eb}) to be better than #{worse} (#{ew})")
  end

  def test_adding_punctuation_should_improve_entropy
    assert_better "rubbish!", "rubbish"
  end

  def test_random_letters_should_be_better_than_words
    assert_better "sdfjhweu", "password"
  end

  def test_capital_letters_and_numbers_should_improve_entropy
    assert_better "Password1", "password"
  end

  def test_complex_passwords_should_be_better_than_simple_ones
    assert_better "Slightly^better 1", "Password1"
  end

  def test_should_agree_with_xkcd_936
    assert_better "correct horse battery staple", "Tr0ub4dor&3"
  end

  def test_mixed_symbols_should_be_better_than_words
    assert_better "~T3n Char$", "antidisestablishmentarianism"
  end
end
