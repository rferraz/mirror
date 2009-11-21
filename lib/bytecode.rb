module Bytecode
  
  class Push
    
    attr_reader :value
    
    def initialize(value)
      @value = value
    end
    
    def inspect
      "push #{@value}"
    end
    
  end
  
  class Load 
  
    attr_reader :name
    
    def initialize(name)
      @name = name
    end
    
    def inspect
      "load #{@name}"
    end
    
  end
  
  class Block
    
    attr_reader :arguments
    attr_reader :statements
    
    def initialize(arguments, statements)
      @arguments = arguments
      @statements = statements
    end
    
    def inspect
      "block #{@arguments.inspect}"
    end    
    
  end
  
  class Message
    
    attr_reader :arity
    attr_reader :selector
    
    def initialize(selector, arity)
      @selector = selector
      @arity = arity
    end
    
    def inspect
      "send #{@selector}"
    end    
    
    
  end
  
end