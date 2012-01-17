require "zlib"
require "singleton"

module PassphraseEntropy
  class Calculator
    include Singleton

    def entropy(s)
      zlen(s) - baseline
    end

  private
    def dictionary
      File.read("/usr/share/dict/words")
    end

    def zlen(s)
      z = Zlib::Deflate.new
      out = z.deflate(dictionary + s, Zlib::FINISH)
      z.close
      out.bytesize
    end

    def baseline
      @baseline ||= zlen("")
    end
  end
end
