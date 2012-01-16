require "singleton"

module PasswordEntropy

  class Pool
    def initialize(*symbols)
      @symbols = []
      symbols.each do |s|
        add Array(s)
      end
    end

    def match?(string)
      string.dup.force_encoding(Encoding::ASCII_8BIT).match(pattern)
    end

    def entropy(string)
      return 0 if @symbols.empty?
      string.bytesize * Math.log2(@symbols.length)
    end

    def +(other)
      other.dup.tap { |o| o.add(@symbols) }
    end

    def add(symbols)
      @symbols = (@symbols + symbols).sort.uniq
      @pattern = nil
    end

  private
    def pattern
      @pattern ||= Regexp.new(
        "[" + @symbols.map{ |s| Regexp.escape(s) }.join + "]",
        options=nil, language="n"
      )
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
    pool = POOLS.select { |p| p.match?(string) }.inject(Pool.new([]), &:+)
    pool.entropy(string)
  end

  extend self
end
