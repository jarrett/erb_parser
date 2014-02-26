require 'test_helper'

class XmlTransformerTest < MiniTest::Unit::TestCase
  def test_replace_erb_tags_with_xml_elements
    result = ErbParser.transform_xml(
      '<p>Foo <%= "bar %>" & 1 %> baz. <% foo %> bar <%# baz %>.</p>'
    )
    assert_equal(
      '<p>Foo <erb interpolated="true"> &quot;bar %&gt;&quot; &amp; 1 </erb> baz. ' +
      '<erb> foo </erb> bar <erb comment="true"> baz </erb>.</p>',
      result
    )
  end
  
  def test_override_tag_attr
    result = ErbParser.transform_xml '<p>Foo <% bar %> baz.', :tag => 'erb-tag'
    assert_equal '<p>Foo <erb-tag> bar </erb-tag> baz.', result
  end
  
  def test_override_interp_attr_to_false
    result = ErbParser.transform_xml '<p>Foo <%= bar %> baz.', :interp_attr => false
    assert_equal '<p>Foo <erb> bar </erb> baz.', result
  end
  
  def test_override_interp_attr_to_key_value_pair
    result = ErbParser.transform_xml '<p>Foo <%= bar %> baz.', :interp_attr => {'int' => 'yes'}
    assert_equal '<p>Foo <erb int="yes"> bar </erb> baz.', result
  end
  
  def test_override_comment_attr_to_false
    result = ErbParser.transform_xml '<p>Foo <%# bar %> baz.', :comment_attr => false
    assert_equal '<p>Foo <erb> bar </erb> baz.', result
  end
  
  def test_override_comment_attr_to_key_value_pair
    result = ErbParser.transform_xml '<p>Foo <%# bar %> baz.', :comment_attr => {'comm' => 'yes'}
    assert_equal '<p>Foo <erb comm="yes"> bar </erb> baz.', result
  end
end