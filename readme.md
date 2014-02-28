# ErbParser

ErbParser is a Ruby gem for parsing ERB templates. It takes an ERB template as a string
and returns either an array of tokens or a transformed XML document, depending on your
preference.

## Basic usage synopsis

Pass in an ERB template as a string:

    result = ErbParser.parse(
      'Plain text <% 5.times {} %><%= 2 + 3 %><%# Comment %>
    )
    
    # 'Plain text'
    puts result[0]
    
    # ' 5.times {} '
    puts result[0].ruby_code
    
    puts result[0].to_s
    # '<% 5.times {} %>'
    
    # ' 2 + 3 '
    puts result[1].ruby_code
    
    # '<%= 2 + 3 %>'
    puts result[1].to_s
    
    # ' Comment '
    puts result[2].ruby_code
    
    # '<%# Comment" %>'
    puts result[2].to_s

The above usage sets `result` to an array of tokens.

## The `:transform` option

Often, you'll want to parse an ERB template, apply some transformation function to all
the ERB tags, and get back a new string. That's what the `:transform` option is for:

    result = ErbParser.parse(
      'This is a<% TSET %>',
      :transform => lambda { |t| t.ruby_code.reverse.downcase }
    )
    
    # 'This is a test '
    puts result

As in the above example, the `:transform` option must be a proc. The proc will be passed
an `ErbTag` as its only parameter. It must return a string. The returned string will be
inserted into the output where the ERB tag used to be.

## XML/HTML usage synopsis

Alternatively, you may pass in an XML/HTML document or fragment and have the ERB tags
transformed to valid XML elements:

    ErbParser.transform_xml(%Q(
      <p>
        Plain text
        <% 5.times {} %>
        <%= 2 + 3 %>
        <%# Comment %>
      </p>
    ))

The above would return a fragment equivalent to:

    <p>
      Plain text
      <erb> 5.times {} </erb>
      <erb interpolated="true"> 2 + 3 </erb>
      <erb comment="true">Comment</erb>
    </p>

### Customizing XML/HTML output

You can customize the XML tags that replace the ERB tags:
    
    # '<custom-tag> 5.times {} </custom-tag>'
    ErbParser.transform_xml '<% 5.times {} %>', :tag => 'custom-tag'
    
    # '<erb apple="orange"> Time.now.to_s </erb>'
    ErbParser.transform_xml '<%= Time.now.to_s %>', :interp_attr => {'apple' => 'orange'}
    
    # '<erb> Time.now.to_s </erb>'
    ErbParser.transform_xml '<%= Time.now.to_s %>', :interp_attr => false
    
    # '<erb apple="orange"> Comment </erb>'
    ErbParser.transform_xml '<%# Comment %>', :comment_attr => {'apple' => 'orange'}
    
    # '<erb> Comment </erb>'
    ErbParser.transform_xml '<%# Comment %>', :comment_attr => false

## FAQ

### Can ErbParser handle all valid Ruby code?

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

### What does ErbParser do with invalid ERB or Ruby code?

If you pass code containing a syntax error, the parsing behavior is undefined. You may get
an exception, or you may just get nonsensical results. It depends on the type of the
syntax error.