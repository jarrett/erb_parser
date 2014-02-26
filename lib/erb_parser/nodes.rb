module ErbParser
  module ErbGrammar
    module Text
      def type
        :text
      end
    end
    
    module ErbTag
      def comment?
        !number_sign.empty?
      end
      
      def interpolated?
        !equal_sign.empty?
      end
      
      def ruby_code
        _ruby_code.text_value
      end
      
      def type
        :erb_tag
      end
    end
  end
end