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

  class LoadLiteral
  
    attr_reader :name
    
    def initialize(name)
      @name = name
    end
    
    def inspect
      "load literal #{@name}"
    end
    
    def to_sexp
      [:load_literal, @name]
    end
        
  end
  
  class Store 
  
    attr_reader :name
    
    def initialize(name)
      @name = name
    end
    
    def inspect
      "store #{@name}"
    end
    
    def to_sexp
      [:store, @name]
    end
        
  end
  
  class Return
    
    def inspect
      "return"
    end
    
    def to_sexp
      [:return]
    end
    
  end
  
  class Block
    
    attr_reader :arity
    attr_reader :count
    attr_reader :arguments
    attr_reader :temporaries
    
    def initialize(arity, count, arguments, temporaries)
      @arity = arity
      @count = count
      @arguments = arguments
      @temporaries = temporaries
    end
    
    def inspect
      "block #{@arity} #{@count}"
    end
    
    def to_sexp
      [:block, @arity, @count]
    end
    
  end
  
  class Slot
    
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
      "slot #{@selector_name}"
    end    
    
    def to_sexp
      [:slot, @selector]
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