## Can ErbParser handle all valid Ruby code?

No it cannot. Ruby has a very complex syntax. In a library like this, it would be a fool's
errand to try to handle every weird syntactic construct that could technically be
considered valid Ruby. Instead, this library is designed to handle only the constructs
that would commonly appear inside ERB tags. In other words, the basics of the language.

Just avoid exotic syntactic constructs, and you should be fine. (You shouldn't do anything
syntactically fancy in an ERB template anyway--it's bad coding style.) In particular, you
must avoid Ruby's weirder string literals, such as the following:

    %q!This is a valid string literal, but you must not use this syntax.!

Also be wary of tricky escape sequences. If you absolutely must use unusual syntax, and it
breaks ErbParser, consider moving the offending code into a class or module external to
the ERB template.

Nonetheless, the library *does* account for and allow the following string literal
formats:

    "string"
    'string'
    %q(string (string) string)
    %Q(string (string) string)
    %(string (string) string)
    %q{string {string} string}
    %Q{string {string} string}
    %{string {string} string}

This parser is *not* hardened against malicious input. But then, you shouldn't be
accepting ERB as untrusted input anyway, because ERB allows arbitrary code execution.

## What does ErbParser do with invalid ERB or Ruby code?

If you pass code containing a syntax error, the parsing behavior is undefined. You may get
an exception, or you may just get nonsensical results. It depends on the type of the
syntax error.