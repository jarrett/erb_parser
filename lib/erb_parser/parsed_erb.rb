module ErbParser
  class ParsedErb
    # Accesses the parsed tokens as an array. Each element of the array is either a
    # String, representing plain text, or an ErbTag.
    def [](index)
      @tokens[index]
    end
    
    def initialize(treetop_ast)
      @treetop_ast = treetop_ast
      @tokens = treetop_ast.elements.map do |elem|
        case elem.type
        when :text
          elem.text_value
        when :erb_tag
          ErbTag.new elem
        else
          raise "Unexpected type: #{elem.type}"
        end
      end
    end
    
    # Returns the array of parsed tokens.
    attr_reader :tokens
    
    # Returns the raw Treetop AST.
    attr_reader :treetop_ast
  end
end