require "rubygems"
require "treetop"

require "orange/runtime"
require "orange/generator"
require "orange/nodes"

if File.file?(File.dirname(__FILE__) + "/orange/grammar.rb")
  require "orange/grammar"
else
  Treetop.load File.dirname(__FILE__) + "/orange/grammar.tt"
end
