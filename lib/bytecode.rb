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
    
    attr_reader :selector
    
    def initialize(selector)
      @selector = selector
    end
    
    def inspect
      "slot #{selector_name}"
    end    
    
    def to_sexp
      [:slot, @selector]
    end
    
    def arity
      @arity ||= get_arity
    end
    
    def is_unary?
      @is_unary ||= (@selector_name =~ /^[a-zA-z]/ && @selector_name.count(":") == 1)
    end

    def selector_unary_name
      @selector_unary_name ||= @selector_name[0, @selector_name.size - 1]
    end
    
    def selector_name
      @selector_name ||= get_selector_name
    end

    def selector_method
      @selector_method ||= get_selector_method
    end

    protected

    def get_arity
      if @selector.is_a?(Array)
        @selector.size
      elsif @selector.is_a?(String)
        if @selector[selector.size - 1].chr == ":"
          1
        else
          0
        end
      else
        1
      end
    end
    
    def get_selector_name
      if @selector == :-
        @selector.to_s
      else
        [@selector].flatten.collect(&:to_s).join
      end
    end

    def get_selector_method
      if @selector == "-"
        @selector
      else
        [@selector].flatten.collect(&:to_s).collect(&:underscore).join("_").gsub(":", "")
      end
    end

  end
  
  class Jump
    
    attr_reader :count
    
    def initialize(count)
      @count = count
    end
    
    def inspect
      "jump #{@count}"
    end
    
    def to_sexp
      [:jump, @count]
    end
    
  end
    
  class JumpFalse
    
    attr_reader :count
    
    def initialize(count)
      @count = count
    end
    
    def inspect
      "jump false #{@count}"
    end
    
    def to_sexp
      [:jump_false, @count]
    end
    
  end
  
  class JumpTrue
    
    attr_reader :count
    
    def initialize(count)
      @count = count
    end
    
    def inspect
      "jump true #{@count}"
    end
    
    def to_sexp
      [:jump_true, @count]
    end
    
  end  
  
end