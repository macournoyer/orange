module Orange
  class ::Treetop::Runtime::SyntaxNode
    def value
      text_value
    end
    
    def codegen(context)
    end
  end
  Node = Treetop::Runtime::SyntaxNode
  
  class Context
    attr_reader :locals
    
    def initialize
      @out = []
      @locals = {}
    end
    
    def <<(o)
      @out << o
    end
    
    def to_s
      @out.compact.join("\n")
    end
  end

  class Script < Node
    def compile(generator)
      context = Context.new
      expressions.each do |exp|
        exp.codegen(context)
      end
      context
    end
  end

  class Expression < Node
    def codegen(context)
      statements.each { |s| s.codegen(context) }
    end
  end
  
  class Assign < Node
    def codegen(context)
      context.locals[var.value] = true
      expression.codegen(context)
      puts "setlocal: #{var.value} = #{expression.value}"
    end
  end
  
  class Call < Node
    def codegen(context)
      if receiver.nil? && context.locals[message.value]
        puts "getlocal: #{message.value}"
      else
        puts "call: #{receiver ? receiver.value : 'self'}.#{message.value}(#{arglist.args.map { |a| a.value }.join(", ")})"
        arglist.codegen(context) if arglist.is_a?(Block)
        arglist.block.codegen(context) if arglist.respond_to?(:block)
      end
    end
  end
  
  class Block < Node
    def codegen(context)
      puts "in block: (#{arglist.args.map { |a| a.value }.join(", ") if arglist})"
      expressions.each { |exp| exp.codegen(context) }
    end
  end
end