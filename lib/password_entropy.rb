require "singleton"
require "set"

module PasswordEntropy

  class Pool
    attr_reader :symbols

    def initialize(*ranges)
      @symbols = Set.new
      ranges.each do |r|
        add Array(r).join.bytes.to_a
      end
    end

    def match?(string)
      string.bytes.any? { |b| symbols.include?(b) }
    end

    def entropy(string)
      return 0 if symbols.empty?
      string.bytesize * Math.log2(symbols.length)
    end

    def +(other)
      other.dup.tap { |o| o.add(symbols) }
    end

    def add(symbols)
      @symbols += symbols
    end
  end

  POOLS = [
    ["0".."9"],
    ["a".."z"],
    ["A".."Z"],
    [" ".."/", ":".."@", "[".."`", "{".."~"],
    ["\x00".."\x1F"],
    ["\x80".."\xFF"],
  ].map { |a| Pool.new(*a) }

  def entropy(string)
    POOLS.inject(Pool.new) { |a, p|
      p.match?(string) ? a + p : a
    }.entropy(string)
  end

  extend self
end
