require "rubygems"
require "treetop"

require "orange/runtime"
require "orange/generator"
require "orange/nodes"

if File.file?(File.dirname(__FILE__) + "/orange/grammar.rb")
  # Take compiled one
  require "orange/grammar"
else
  Treetop.load File.dirname(__FILE__) + "/orange/grammar.tt"
end

module Orange
  class ParserError < RuntimeError; end
  
  def self.compile(code)
    generator = Orange::Generator.new
    parser    = OrangeParser.new
    
    if node = parser.parse(code)
      node.compile(generator)
    else
      raise ParserError, parser.failure_reason
    end
    
    generator
  end
end
