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
  x == 2
  say "hi"
  items.each :one do |i, j|
    i.say("hi")
  end
  if (1 == 2) do
    puts "cool"
  end
EOS