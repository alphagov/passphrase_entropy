require "passphrase_entropy/zlib"
require "singleton"

module PassphraseEntropy
  class Calculator
    include Singleton

    def entropy(s)
      zlen(s) - baseline
    end

  private
    def marshalled_file
      File.expand_path("../data/zlib.marshal.#{RUBY_VERSION}", __FILE__)
    end

    def dictionary
      File.read("/usr/share/dict/words")
    end

    def warmed_deflater
      unless File.exist?(marshalled_file)
        z = PassphraseEntropy::Zlib::Deflate.new
        z.deflate(dictionary)

        File.open(marshalled_file, "w") do |f|
          f << Marshal.dump(z)
        end
      end

      Marshal.load(File.read(marshalled_file))
    end

    def zlen(s)
      z = warmed_deflater
      out = z.deflate(s, PassphraseEntropy::Zlib::FINISH)
      z.close
      out.bytesize
    end

    def baseline
      @baseline ||= zlen("")
    end
  end
end
