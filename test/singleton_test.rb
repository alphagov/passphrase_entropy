require "minitest/autorun"
require "passphrase_entropy"

class SingletonTest < MiniTest::Unit::TestCase
  def test_using_singleton_api
    start = PassphraseEntropy.single ? PassphraseEntropy.single.call_count : 0
    PassphraseEntropy.of("this thing")
    assert_equal start + 1, PassphraseEntropy.single.call_count
    PassphraseEntropy.of("that thing")
    assert_equal start + 2, PassphraseEntropy.single.call_count
  end

  def test_that_using_singleton_is_faster_than_not
    test_set = [ "rubbish!", "rubbish" "sdfjhweu", "password" "Password1",
    "password" "Slightly^better 1", "Password1" "correct horse battery staple",
    "Tr0ub4dor&3" "~T3n Char$", "antidisestablishmentarianism" ]

    t0 = Time.now
    test_set.each do |s|
      pe = PassphraseEntropy.new
      pe.entropy(s)
    end
    without = Time.now - t0

    t1 = Time.now
    test_set.each do |s|
      PassphraseEntropy.of(s)
    end
    with = Time.now - t1

    assert with < without
  end
end
