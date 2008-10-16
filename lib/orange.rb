require "rubygems"
require "treetop"

require "orange/runtime"
require "orange/nodes"
# require "orange/grammar"
Treetop.load "orange/grammar.tt"

parser = OrangeParser.new

puts parser.parse(<<-EOS).codegen.to_s
  # ohaie
  x = 2 + 1
  you.say "hi"
EOS