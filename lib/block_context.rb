class BlockContext < BlankObject

  def initialize(vm, arguments, statements)
    @vm = vm
    @arguments = arguments
    @statements = statements
  end
  
  def arity
    @arguments.size
  end
  
  def value(*context_arguments)
    reset_pointer
    reset_context_arguments(context_arguments)
    vm.enter_context(self)
    while has_statements?
      vm.execute_in_current_context(next_statement)
    end
  ensure
    vm.leave_context
  end

  def has?(name)
    context_arguments.has_key?(name)
  end
  
  def [](name)
    if has?(name)
      context_arguments[name]
    else
      vm.walk_contexts(name)[name]
    end
  end
  
  def []=(name, value)
    if has?(name)
      context_arguments[name] = value
    else
      vm.walk_contexts(name)[name] = value
    end
  end
  
  def context_arguments
    @context_arguments ||= {}
  end
  
  def inspect
    "BlockContext"
  end

  protected
  
  def reset_context_arguments(context_arguments)
    @context_arguments = Hash[*@arguments.zip(context_arguments).flatten]
  end
  
  def reset_pointer
    @pointer = 0
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