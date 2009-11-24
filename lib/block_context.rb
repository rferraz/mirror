class BlockContext < BlankObject

  def initialize(vm, arguments, temporaries, statements)
    @vm = vm
    @arguments = arguments.collect(&:to_sym)
    @temporaries = temporaries.collect(&:to_sym)
    @statements = statements
  end
  
  def copy
    BlockContext.new(@vm, @arguments, @temporaries, @statements)
  end
  
  def arity
    @arguments.size
  end
  
  def value(*arguments)
    return_value = receiver
    reset_context_arguments(arguments)
    reset_temporaries
    reset_pointer
    vm.enter_context(self)
    while has_statements?
      if is_last_statement?
        return_value = vm.stack.last unless vm.stack.last.nil?
      end
      vm.execute_in_current_context(next_statement)
    end
    return_value
  ensure
    vm.leave_context
  end
  
  def method_missing(name, *args, &block)
    if respond_to?(name)
      super
    else
      if is_unary?(name.to_s)
        if receiver.has?(name)
          receiver.perform(name.to_s, *args, &block)
        else
          self[unary_name(name.to_s)] = args.first
        end
      else
        receiver.perform(name.to_s, *args, &block)
      end
    end
  end

  def has?(name)
    context_arguments.has_key?(name.to_sym)
  end
  
  def [](name)
    if has?(name)
      context_arguments[name.to_sym]
    else
      vm.walk_contexts(name)[name]
    end
  end
  
  def []=(name, value)
    if has?(name)
      context_arguments[name.to_sym] = value
    else
      vm.walk_contexts(name)[name] = value
    end
  end
  
  def context_arguments
    @context_arguments ||= {}
  end
  
  def temporaries
    @temporaries ||= {}
  end
  
  def inspect
    "<BlockContext: [" + @arguments.join(",") + " : " + @temporaries.join(",") + " " + context_arguments.inspect + "]>"
  end

  def receiver
    vm.get_last_object_context
  end

  protected

  def is_unary?(name)
    name =~ /^[a-zA-z]/ && name.count(":") == 1
  end
  
  def unary_name(name)
    name[0, name.size - 1]
  end
    
  def reset_context_arguments(incoming_arguments)
    context_arguments.merge!(Hash[*@arguments.zip(incoming_arguments).flatten])
  end
  
  def reset_temporaries
    context_arguments.merge!(Hash[@temporaries.zip([nil] * @temporaries.size)])
  end
  
  def reset_pointer
    @pointer = 0
  end

  def is_last_statement?
    @pointer == @statements.size - 1
  end
  
  def has_statements?
    @pointer < @statements.size
  end
  
  def next_statement
    @pointer += 1
    @statements[@pointer - 1]
  end
  
  def vm
    @vm
  end
  
end