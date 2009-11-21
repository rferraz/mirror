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
  
  def value(world, context_arguments)
    reset_pointer
    reset_context_arguments(context_arguments)
    reset_world(world)
    vm.enter_context(self)
    while has_instructions?
      vm.execute_in_current_context(next_instruction)
    end
  ensure
    vm.leave_context
  end
  
  def [](name)
    if context_arguments.has_key?(name)
      context_arguments[name]
    elsif world.has?(name)
      world[name]
    else
      vm.universe[name]
    end
  end

  def []=(name, value)
    if context_arguments.has_key?(name)
      context_arguments[name] = value
    elsif world.has?(name)
      world[name] = value
    else
      vm.universe[name] = value
    end
  end
  
  def world
    @world
  end

  def context_arguments
    @context_arguments ||= {}
  end
  
  protected
  
  def reset_world(world)
    @world = world
  end
  
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