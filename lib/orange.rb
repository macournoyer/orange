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
  x
  say "hi"
  say
  self.say = :nice
  items.each(:one) do |i, j|
    i.say("hi")
  end
  def :method do |arg1, arg2|
    puts "nice"
  end
  if (x > 1 && x < 4) do
    exit
  end
EOS