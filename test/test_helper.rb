require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'

$:.unshift(File.join(File.expand_path(File.dirname(__FILE__)), '../lib'))

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

require 'erb_parser'