module Ast
  
  class Literal
    
    def initialize(type, value)
      @type = type
      @value = value
    end
    
    def to_sexp
      [:literal, @type, @value]
    end
    
  end

  class Variable
    
    def initialize(name)
      @name = name
    end
    
    def to_sexp
      [:variable, @name]
    end
    
  end
  
  class Block
    
    def initialize(arguments, *statements)
      @arguments = arguments
      @statements = statements
    end
    
    def to_sexp
      [:block, @arguments, @statements.collect(&:to_sexp)]
    end
    
  end

  class Message
    
    def initialize(target, selector, *arguments)
      @target = target
      @selector = selector
      @arguments = arguments
    end
    
    def to_sexp
      [:send, @target.to_sexp, @selector, @arguments.collect(&:to_sexp)]
    end
    
  end
  
end