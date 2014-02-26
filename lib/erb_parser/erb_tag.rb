module ErbParser
  class ErbTag
    def comment?
      @treetop_node.comment?
    end
    
    def initialize(treetop_node)
      @treetop_node = treetop_node
    end
    
    def interpolated?
      @treetop_node.interpolated?
    end
    
    def ruby_code
      @treetop_node.ruby_code
    end
    
    def to_s
      @treetop_node.text_value
    end
  end
end