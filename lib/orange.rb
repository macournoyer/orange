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
  def self.compile(code)
    g = Orange::Generator.new
    OrangeParser.new.parse(code).compile(g)
    g
  end
end
