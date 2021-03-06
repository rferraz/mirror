module Ast

  class Statement
    
    attr_reader :expression
    
    def initialize(expression)
      @expression = expression
    end
    
    def to_sexp
      @expression.to_sexp
    end
    
  end
  
  class Implicit
    
  end
  
  class Literal
    
    attr_reader :type
    attr_reader :value
    
    def initialize(type, value)
      @type = type
      @value = value
    end
    
    def to_sexp
      [:literal, @type, @value]
    end
    
  end

  class Variable
    
    attr_accessor :name
    
    def initialize(name)
      @name = name
    end
    
    def to_sexp
      [:variable, @name]
    end
    
  end
  
  class Block
    
    attr_reader :arguments
    attr_reader :temporaries
    attr_reader :statements
    
    def initialize(arguments, temporaries, *statements)
      @temporaries = temporaries
      @arguments = arguments
      @statements = statements
    end
    
    def to_sexp
      [:block, @arguments, @temporaries, @statements.collect(&:to_sexp)]
    end
    
  end

  class Message
    
    attr_reader :target
    attr_reader :selector
    attr_reader :arguments
    
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