require 'cgi'

module ErbParser
  module XmlTransformer
    def self.transform(parsed_erb, options)
      options = {
        :tag          => 'erb',
        :interp_attr  => {'interpolated' => 'true'},
        :comment_attr => {'comment'      => 'true'}
      }.merge(options)
      
      parsed_erb.tokens.map do |elem|
        case elem
        when String
          elem
        when ErbTag
          if elem.interpolated?
            if options[:interp_attr].is_a?(Hash)
              attrs = options[:interp_attr]
            else
              attrs = {}
            end
          elsif elem.comment?
            if options[:comment_attr].is_a?(Hash)
              attrs = options[:comment_attr]
            else
              attrs = {}
            end
          else
            attrs = {}
          end
          content_tag options[:tag], CGI.escape_html(elem.ruby_code), attrs
        else
          raise "Unexpected element: #{elem.class.name}"
        end
      end.join
    end
  
    def self.content_tag(name, contents, attrs = {})
      if attrs.empty?
        attrs_str = ''
      else
        attrs_str = ' ' + attrs.map do |key, val|
          key = CGI.escape_html(key.to_s)
          val = CGI.escape_html(val.to_s)
          %Q(#{key}="#{val}")
        end.join(' ')
      end
      '<' + name.to_s + attrs_str + '>' + contents.to_s + '</' + name.to_s + '>'
    end
  end
end