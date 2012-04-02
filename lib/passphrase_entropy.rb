require "zlib"

# Estimate the entropy of a passphrase. This is calculated as the number of bytes
# required to encode the passphrase on top of a Deflate stream of a preset
# dictionary.
#
class PassphraseEntropy

  attr_accessor :call_count

  # Instantiate a new PasswordEntropy calculator.
  # dictionary should be a String containing a list of words; this is
  # /usr/share/dict/words by default, which should be good for English systems.
  #
  def initialize(dictionary=default_dictionary)
    @dictionary = dictionary
    self.call_count = 0
  end

  # Estimate the entropy of s (in bytes)
  #
  def entropy(s)
    zlen(s) - baseline
  end

  def inspect(*args)
    to_s
  end

  # A singleton method that avoids reloading the dictionary over and over again.
  class << self
    attr_accessor :single

    def of(s)
      self.single = PassphraseEntropy.new if self.single.nil?
      self.single.entropy(s)
    end
    
    def call_count
      self.single.call_count
    end
  end

private
  def default_dictionary
    File.read("/usr/share/dict/words")
  end

  def zlen(s)
    z = Zlib::Deflate.new
    out = z.deflate(@dictionary + s, Zlib::FINISH)
    z.close
    self.call_count += 1
    out.bytesize
  end

  def baseline
    @baseline ||= zlen("")
  end
end
