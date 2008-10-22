module Orange
  class ::Treetop::Runtime::SyntaxNode
    def value
      text_value
    end
    
    def codegen(context)
    end
  end
  Node = Treetop::Runtime::SyntaxNode
  
  class Script < Node
    def compile(generator)
      generator.preamble
      expressions.each { |e| e.codegen(generator) }
      generator.finish
    end
  end

  class Expression < Node
    def codegen(g)
      statements.map { |s| s.codegen(g) }
    end
  end
  
  class Assign < Node
    def codegen(g)
      g.assign var.value, expression.codegen(g).last
    end
  end
  
  class Call < Node
    def codegen(g)
      arg_values = arglist.args.map { |arg| arg.codegen(g) }
      g.call(func.value, *arg_values)
    end
  end
  
  class Def < Node
    def codegen(g)
      # TODO args
      g.function(func.value) do |gf|
        expressions.each { |e| e.codegen(gf) }
      end
    end
  end
  
  class If < Node
    def codegen(g)
      puts "if: #{condition.value}"
      expressions.each { |e| e.codegen(g) }
      puts "end"
    end
  end
  
  class Var < Node
    def codegen(g)
      g.load(value)
    end
  end
  
  class String < Node
    def codegen(g)
      g.new_string(value)
    end
  end
  
  class Number < Node
    def codegen(g)
      g.new_number(value)
    end
  end
end