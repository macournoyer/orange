require "rubygems"
require "treetop"

require "orange/runtime"
require "orange/nodes"
# require "orange/grammar"
Treetop.load "orange/grammar.tt"

parser = OrangeParser.new

  # ohaie
  # x = 2 + 1
  # you.say "hi"
puts parser.parse(<<-EOS).inspect #codegen.to_s
  items.each do
    i.to_s
    x = 2
  end
EOS