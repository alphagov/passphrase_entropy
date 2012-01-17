PassphraseEntropy
=================

Estimate the entropy of a passphrase. This is calculated as the number of bytes
required to encode the passphrase on top of a Deflate stream of a preset
dictionary.

Inspired by [xkcd 936](http://xkcd.com/936/).

Usage
-----

    require "passphrase_entropy"

    pe = PassphraseEntropy.new
    # or customise the dictionary:
    pe = PassphraseEntropy.new(File.read("/usr/share/dict/words"))

    pe.entropy("password") # => 6
    pe.entropy("correct horse battery staple") # => 24
    pe.entropy("Tr0ub4dor&3") # => 21

You can decide on your acceptable level of complexity.

Notes
-----

It's a bit slow: the dictionary must be deflated every time. This could be
ameliorated by saving the state, but that would require a modified zlib
library. (It's easy to do with a pure Ruby zlib library, but Ruby is so much
slower in this case that the overall gain in speed is almost zero.)

Tested using the `web2` dictionary installed in Ubuntu Linux by:

    apt-get install dictionaries-common miscfiles

Results will vary depending on the dictionary used.
