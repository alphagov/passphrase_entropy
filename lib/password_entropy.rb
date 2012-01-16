require "singleton"

module PasswordEntropy

  class Pool
    def initialize(symbols)
      @pattern = Regexp.new(
        "\\A[" + symbols.map{ |s| Regexp.escape(s) }.join + "]+\\z",
        options=nil, language="n"
      )
      @size = symbols.length
    end

    def match?(string)
      string.dup.force_encoding(Encoding::ASCII_8BIT).match(@pattern)
    end

    def entropy_per_symbol
      Math.log2(@size)
    end
  end

  class NullPool
    include Singleton

    def match?(string)
      string.empty?
    end

    def entropy_per_symbol
      0
    end
  end

  POOLS = [NullPool.instance] + [
    digits = ("0".."9").to_a,
    lower  = ("a".."z").to_a,
    upper  = ("A".."Z").to_a,
    mixed  = lower + upper,
    lower + digits,
    upper + digits,
    mixed + digits,
    keyboard = (" ".."~").to_a,
    any = (1..255).map { |c| [c].pack("C") },
  ].map { |a| Pool.new(a) }

  def entropy(string)
    pool = POOLS.detect { |p| p.match?(string) }
    string.bytesize * pool.entropy_per_symbol
  end

  extend self
end
