module Bytecode

  class Implicit

    def inspect
      "implicit"
    end
    
    def to_sexp
      [:implicit]
    end
    
  end
  
  class Pop

    def inspect
      "pop"
    end
    
    def to_sexp
      [:pop]
    end
    
  end
  
  class Push
    
    attr_reader :value
    
    def initialize(value)
      @value = value
    end
    
    def inspect
      "push #{@value.inspect}"
    end
    
    def to_sexp
      [:push, @value]
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
    
    def to_sexp
      [:load, @name]
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
    
    def to_sexp
      [:block, @arguments, @statements.collect(&:to_sexp)]
    end
    
  end
  
  class Message
    
    attr_reader :arity
    attr_reader :selector
    attr_reader :selector_name
    
    def initialize(selector, arity)
      @selector = selector
      @selector_name = get_selector_name(selector)
      @arity = arity
    end
    
    def inspect
      "send #{@selector_name}"
    end    
    
    def to_sexp
      [:send, @selector]
    end
    
    protected

    def get_selector_name(selector)
      if selector == :-
        selector.to_s
      else
        [selector].flatten.collect(&:to_s).collect(&:underscore).join("_")
      end
    end

  end
  
end