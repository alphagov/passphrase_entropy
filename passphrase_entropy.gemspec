lib = File.expand_path("../lib/", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "passphrase_entropy/version"

spec = Gem::Specification.new do |s|
  s.name             = "passphrase_entropy"
  s.version          = PassphraseEntropy::VERSION
  s.author           = "Paul Battley"
  s.email            = "pbattley@gmail.com"
  s.summary          = "Estimate the entropy of a passphrase"
  s.files            = Dir["{lib,test}/**/*.rb"]
  s.require_path     = "lib"
  s.test_files       = Dir["test/*_test.rb"]
  s.has_rdoc         = true
  s.homepage         = "https://github.com/alphagov/passphrase_entropy"
end
