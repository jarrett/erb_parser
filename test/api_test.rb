require 'test_helper'

# Test the gem's public API.
class ApiTest < MiniTest::Unit::TestCase
  def test_complex_document
    str = %Q(
      <p>The time is <%= Time.now.strftime("%m %d %Y") %>.</p>
      
      <% 5.times do |i| %>
        <p><%= %Q{A string with {nested} brackets and a closing tag %>. } * i %></p>
      <% end %> 
      
      <%# puts "This is a comment." %>
    )
    result = ErbParser.parse(str)

    assert_equal '<p>The time is', result[0].strip
    
    assert_kind_of ErbParser::ErbTag, result[1]
    assert_equal '<%= Time.now.strftime("%m %d %Y") %>', result[1].to_s
    assert_equal ' Time.now.strftime("%m %d %Y") ', result[1].ruby_code
    assert result[1].interpolated?
    assert !result[1].comment?
    
    assert_equal '.</p>', result[2].strip
    
    assert_kind_of ErbParser::ErbTag, result[3]
    assert_equal '<% 5.times do |i| %>', result[3].to_s
    assert_equal ' 5.times do |i| ', result[3].ruby_code
    assert !result[3].interpolated?
    assert !result[3].comment?
    
    assert_equal '<p>', result[4].strip
    
    assert_kind_of ErbParser::ErbTag, result[5]
    assert_equal '<%= %Q{A string with {nested} brackets and a closing tag %>. } * i %>', result[5].to_s
    assert_equal ' %Q{A string with {nested} brackets and a closing tag %>. } * i ', result[5].ruby_code
    assert result[5].interpolated?
    assert !result[5].comment?
    
    assert_equal '</p>', result[6].strip
    
    assert_kind_of ErbParser::ErbTag, result[7]
    assert_equal '<% end %>', result[7].to_s
    assert_equal ' end ', result[7].ruby_code
    assert !result[7].interpolated?
    assert !result[7].comment?
    
    assert_equal '', result[8].strip
    
    assert_kind_of ErbParser::ErbTag, result[9]
    assert_equal '<%# puts "This is a comment." %>', result[9].to_s
    assert_equal ' puts "This is a comment." ', result[9].ruby_code
    assert !result[9].interpolated?
    assert result[9].comment?
  end
  
  def test_transform_option
    str = 'foo<% bar %>baz'
    result = ErbParser.parse str, :map => lambda { |tag| tag.ruby_code.upcase.reverse }
    assert_equal 'foo RAB baz', result
    result = ErbParser.parse str, :transform => lambda { |tag| tag.ruby_code.upcase.reverse }
    assert_equal 'foo RAB baz', result
  end
end