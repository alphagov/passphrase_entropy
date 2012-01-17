require "zlib"

class PassphraseEntropy
  def initialize(dictionary=default_dictionary)
    @dictionary = dictionary
  end

  def entropy(s)
    zlen(s) - baseline
  end

private
  def default_dictionary
    File.read("/usr/share/dict/words")
  end

  def zlen(s)
    z = Zlib::Deflate.new
    out = z.deflate(@dictionary + s, Zlib::FINISH)
    z.close
    out.bytesize
  end

  def baseline
    @baseline ||= zlen("")
  end
end
