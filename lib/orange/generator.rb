require "rubygems"
require "llvm"

module Orange
  class Generator
    include LLVM
    
    PCHAR = Type.pointer(Type::Int8Ty)
    INT   = Type::Int32Ty
    
    class Value
      STRUCT = LLVM::Type.struct([INT, INT, PCHAR])
      TYPES  = [:int, :string, :ptr]
      attr_reader :type, :value, :ptr
      
      def initialize(value, type)
        @value = value
        @type = type
      end
      
      def alloc(b)
        struct = b.alloca(STRUCT, 0)
        v = b.struct_gep(struct, 0)
        b.store(TYPES.index(@type).llvm, v)
        v = case @type
        when :int:    b.struct_gep(struct, 1)
        when :string: b.struct_gep(struct, 2)
        end
        b.store(@value, v)
        @ptr = struct
      end
      
      def load_str(b)
        
      end
    end
    
    def initialize(mod = LLVM::Module.new("orange"), function=nil)
      @module   = mod
      @locals   = {}
      
      @function = function || @module.get_or_insert_function("main", Type.function(INT, [INT, Type.pointer(PCHAR)]))
      @entry_block = @function.create_block.builder
    end
    
    def preamble
      define_external_functions
    end
    
    def new_string(value)
      @entry_block.create_global_string_ptr(value)
    end
    
    def new_number(value)
      value.llvm
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
    
    def function(name)
      func = @module.get_or_insert_function(name, Type.function(INT, []))
      generator = Generator.new(@module, func)
      yield generator
      generator.finish
    end
    
    def finish
      @entry_block.return(0.llvm)
    end
    
    def optimize
      PassManager.new.run(@module)
    end
    
    def run
      ExecutionEngine.get(@module)
      ExecutionEngine.run_function(@function, 0.llvm, 0.llvm)
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
  g.preamble
  g.function("test") do |gf|
    str = gf.new_string("ohaie\n")
    gf.assign("x", str)
    gf.call("printf", gf.load("x"))
  end
  g.call("test")
  g.finish
  puts g.inspect
  g.run.inspect
end