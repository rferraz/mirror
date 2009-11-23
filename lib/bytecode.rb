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
    attr_reader :temporaries
    attr_reader :statements
    
    def initialize(arguments, temporaries, statements)
      @arguments = arguments
      @temporaries = temporaries
      @statements = statements
    end
    
    def inspect
      "block [#{@arguments.inspect} : #{@temporaries.inspect}]"
    end    
    
    def to_sexp
      [:block, @arguments, @statements.collect(&:to_sexp)]
    end
    
  end
  
  class Message
    
    attr_reader :arity
    attr_reader :selector
    attr_reader :selector_name
    attr_reader :selector_method
    
    def initialize(selector)
      @selector = selector
      @selector_name = get_selector_name(selector)
      @selector_method = get_selector_method(selector)
      @arity = get_selector_arity(selector)
    end
    
    def inspect
      "send #{@selector_name}"
    end    
    
    def to_sexp
      [:send, @selector]
    end
    
    protected

    def get_selector_arity(selector)
      if selector.is_a?(Array)
        selector.size
      elsif selector.is_a?(String)
        if selector[selector.size - 1].chr == ":"
          1
        else
          0
        end
      else
        1
      end
    end
    
    def get_selector_name(selector)
      if selector == :-
        selector.to_s
      else
        [selector].flatten.collect(&:to_s).join
      end
    end

    def get_selector_method(selector)
      if selector == "-"
        selector.to_s
      else
        [selector].flatten.collect(&:to_s).collect(&:underscore).join("_").gsub(":", "")
      end
    end

  end
  
end