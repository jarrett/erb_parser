require 'test_helper'

# Test the parsing expression grammar (PEG) directly.
class PegTest < MiniTest::Unit::TestCase
  include ErbParser
  
  STRING_LITERALS = [
      '"foo (bar) \" baz"',
      "'foo (bar) \\' baz'",
      '%q(string (string) string)',
      '%Q(string (string) string)',
      '%(string (string) string)',
      '%q{string {string} string}',
      '%Q{string {string} string}',
      '%{string {string} string}'
    ]
  
  def test_string_literals
    STRING_LITERALS.each do |literal|
      result = TreetopRunner.run(literal, root: :string_literal)
      assert_kind_of Treetop::Runtime::SyntaxNode, result
    end
  end
  
  def test_basic_tag
    result = TreetopRunner.run 'Text 1 <% puts "hello world" %> Text 2'
    
    assert_equal :text, result.elements[0].type
    assert_equal 'Text 1 ', result.elements[0].text_value
    
    assert_equal :erb_tag, result.elements[1].type
    assert_equal '<% puts "hello world" %>', result.elements[1].text_value
    assert_equal ' puts "hello world" ', result.elements[1].ruby_code
    assert !result.elements[1].interpolated?
    assert !result.elements[1].comment?
    
    assert_equal :text, result.elements[2].type
    assert_equal ' Text 2', result.elements[2].text_value
  end
  
  def test_interpolated_tag
    result = TreetopRunner.run 'Text 1 <%= "hello world" %> Text 2'
    
    assert_equal :text, result.elements[0].type
    assert_equal 'Text 1 ', result.elements[0].text_value
    
    assert_equal :erb_tag, result.elements[1].type
    assert_equal '<%= "hello world" %>', result.elements[1].text_value
    assert_equal ' "hello world" ', result.elements[1].ruby_code
    assert result.elements[1].interpolated?
    assert !result.elements[1].comment?
    
    assert_equal :text, result.elements[2].type
    assert_equal ' Text 2', result.elements[2].text_value
  end
  
  def test_comment_tag
    result = TreetopRunner.run 'Text 1 <%# puts "hello world" %> Text 2'
    
    assert_equal :text, result.elements[0].type
    assert_equal 'Text 1 ', result.elements[0].text_value
    
    assert_equal :erb_tag, result.elements[1].type
    assert_equal '<%# puts "hello world" %>', result.elements[1].text_value
    assert_equal ' puts "hello world" ', result.elements[1].ruby_code
    assert !result.elements[1].interpolated?
    assert result.elements[1].comment?
    
    assert_equal :text, result.elements[2].type
    assert_equal ' Text 2', result.elements[2].text_value
  end
  
  def test_tag_with_string_literal
    STRING_LITERALS.each do |literal|
      result = TreetopRunner.run("Text 1 <%= literal %> Text 2")
      assert_kind_of Treetop::Runtime::SyntaxNode, result
    end
  end
  
  def test_tag_with_closing_tag_in_string_literal
    result = TreetopRunner.run("Text 1 <%= %Q(Foo (bar) %> baz) %>")
    
    assert_equal :text, result.elements[0].type
    assert_equal 'Text 1 ', result.elements[0].text_value
    
    assert_equal :erb_tag, result.elements[1].type
    assert_equal '<%= %Q(Foo (bar) %> baz) %>', result.elements[1].text_value
    assert_equal ' %Q(Foo (bar) %> baz) ', result.elements[1].ruby_code
    assert result.elements[1].interpolated?
    assert !result.elements[1].comment?
  end
end