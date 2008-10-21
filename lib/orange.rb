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

g = Orange::Generator.new
OrangeParser.new.parse(<<-EOS).compile(g).to_s
  x = "ohaie"
  printf(x)
EOS
puts g.inspect
g.optimize
g.run
