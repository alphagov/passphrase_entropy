require "passphrase_entropy/calculator"

module PassphraseEntropy

  def self.entropy(s)
    Calculator.instance.entropy(s)
  end

  def self.prewarm
    Calculator.instance.entropy("")
  end
end
