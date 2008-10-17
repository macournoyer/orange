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
    def initialize
      @out = []
    end
    
    def <<(o)
      @out << o
    end
    
    def to_s
      @out.compact.join("\n")
    end
  end

  class Script < Node
    def codegen
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
      expression.codegen(context)
      puts "assign: #{var.value} = #{expression.value}"
    end
  end
  
  class Call < Node
    def codegen(context)
      puts "call: #{receiver ? receiver.value : 'self'}.#{message.value}(#{arglist.args.map { |a| a.value }.join(", ")})"
      arglist.codegen(context) if arglist.is_a?(Block)
      arglist.block.codegen(context) if arglist.respond_to?(:block)
    end
  end
  
  class Block < Node
    def codegen(context)
      puts "in block: (#{arglist.args.map { |a| a.value }.join(", ") if arglist})"
      expressions.each { |exp| exp.codegen(context) }
    end
  end
end