class BlockContext < BlankObject
  
  def initialize(vm)
    @vm = vm
    @arguments = []
    @instructions = []
  end
  
  def add_argument(argument)
    @arguments << argument
  end
  
  def add_instruction(instruction)
    @instructions << instruction
  end
  
  def value(*context_arguments)
    reset_pointer
    reset_context_arguments(context_arguments)
    vm.enter_context(self)
    while has_instructions?
      vm.execute_in_current_context(next_instruction)
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

  def has_instructions?
    @pointer < @instructions.size
  end
  
  def next_instruction
    @pointer += 1
    @instructions[@pointer - 1]
  end
  
  def vm
    @vm
  end
  
end