require 'treetop'
require 'erb_parser/nodes'
require 'erb_parser/treetop_runner'
require 'erb_parser/parsed_erb'
require 'erb_parser/erb_tag'
require 'erb_parser/xml_transformer'

module ErbParser
  def self.parse(str)
    ParsedErb.new TreetopRunner.run(str)
  end
  
  # Takes a string representing an XML document or fragment. Finds every ERB tag in the
  # XML and replaces it with the tag <erb>. The contents of the replacement tag will be
  # the inner Ruby code, escaped for XML. You can override the tag like so:
  # 
  #    ErbParser.transform_xml str, :tag => 'tag-name'
  # 
  # If the ERB tag is of the form +<%=+, the attribute +interpolated="true"+ will be
  # added. Else if the ERB tag is of the form +<#+, the attribute +comment="true"+ will be
  # added. You can override this behavior like so:
  #
  #    ErbParser.transform_xml str, :interp_attr => {'attr-name' => 'attr-value'}
  #    ErbParser.transform_xml str, :interp_attr => false
  #    
  #    ErbParser.transform_xml str, :comment_attr => {'attr-name' => 'attr-value'}
  #    ErbParser.transform_xml str, :comment_attr => false
  # 
  # The returned value is a string representing the transformed XML document or fragment.
  def self.transform_xml(str, options = {})
    XmlTransformer.transform(parse(str), options)   
  end
end