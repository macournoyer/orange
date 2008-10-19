require "llvmruby"

module Orange
  class Generator
    include LLVM
    
    def initialize
      @module = Module.new("orange")
    end
  end
end