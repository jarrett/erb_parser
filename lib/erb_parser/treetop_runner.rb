Treetop.load File.join(File.dirname(__FILE__), 'erb_grammar')

module ErbParser
  # This module doesn't do much. It just provides some boilerplate code to invoke Treetop.
  # The result is whatever Treetop returns.
  module TreetopRunner
    def self.run(str, options = {})
      treetop = ErbGrammarParser.new
      if result = treetop.parse(str, options)
        result
      else
        raise ParseError, treetop.failure_reason
      end
    end
    
    class ParseError < RuntimeError; end
  end
end