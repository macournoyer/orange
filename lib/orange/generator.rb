require "rubygems"
require "llvm"

module Orange
  class Generator
    include LLVM
    
    PCHAR = Type.pointer(Type::Int8Ty)
    INT   = Type::Int32Ty
    
    def initialize
      @module = LLVM::Module.new("orange")
      
      @locals = {}
      
      define_external_functions
      
      @main = @module.get_or_insert_function("main", Type.function(INT, [INT, Type.pointer(PCHAR)]))
      @entry_block = @main.create_block.builder
    end
    
    def new_string(value)
      @entry_block.create_global_string_ptr(value)
    end
    
    def call(func, *args)
      f = @module.get_function(func)
      @entry_block.call(f, *args)
    end
    
    def assign(name, value)
      # HACK assume *char for now
      ptr = @entry_block.alloca(PCHAR, 0)
      @entry_block.store(value, ptr)
      @locals[name] = ptr
    end
    
    def load(name)
      @entry_block.load(@locals[name])
    end
    
    def finish
      @entry_block.return(0.llvm)
    end
    
    def optimize
      PassManager.new.run(@module)
    end
    
    def run
      ExecutionEngine.get(@module)
      ExecutionEngine.run_function(@main, 0.llvm, 0.llvm)
    end
    
    def to_file(file)
      @module.write_bitcode(file)
    end
    
    def inspect
      @module.inspect
    end
    
    private
      def define_external_functions
        @module.external_function("printf", Type.function(INT, [PCHAR], true))
      end
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Orange::Generator.new
  str = g.new_string("ohaie\n")
  g.assign("x", str)
  g.call("printf", g.load("x"))
  g.finish
  puts g.inspect
  g.run.inspect
end