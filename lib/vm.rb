class VM
  
  def initialize(instructions)
    @instructions = instructions
  end
  
  def run
    reset_pointer
    while has_instructions?
      execute(next_instruction)
    end
    stack.pop
  rescue MirrorError => e
    puts e.message
  end

  def universe
    @universe ||= Universe.new(self, "Universe")
  end
  
  def current_context
    contexts.last
  end
  
  def execute_in_current_context(instruction)
    execute(instruction)
  end
  
  def enter_context(context)
    @contexts.push(context)
  end
  
  def leave_context
    @contexts.pop
  end
  
  def walk_contexts(name)
    contexts.reverse.each do |context|
      return context if context.has?(name)
    end
    universe
  end
  
  protected
  
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
  
  def stack
    @stack ||= []
  end
  
  def contexts
    @contexts ||= [universe]
  end
  
  def get_last_object_context
    contexts.reverse.each do |context|
      return context unless context.is_a?(BlockContext)
    end
    universe
  end
  
  def stack_push_and_wrap(value)
    if value.is_a?(TrueClass) || value.is_a?(FalseClass)
      stack.push(BooleanProxy.new(self, value))
    elsif value.is_a?(Fixnum)
      stack.push(FixnumProxy.new(self, value))
    else
      stack.push(value)
    end
  end
  
  def execute(instruction)
    case instruction
    when Bytecode::Pop
      stack.pop
    when Bytecode::Push
      stack_push_and_wrap(instruction.value)
    when Bytecode::Load
      if instruction.name == "self"
        stack_push_and_wrap(current_context)
      else
        stack_push_and_wrap(walk_contexts(instruction.name)[instruction.name])
      end
    when Bytecode::Block
      stack_push_and_wrap(BlockContext.new(self, instruction.arguments, instruction.statements))
    when Bytecode::Message
      message = instruction.selector_name
      if message.to_sym == :become
        current_context[stack.pop] = stack.pop
      else
        target = stack.pop
        parameters = []
        if target.is_a?(SlotContainer) && target.has?(message)
          if target[message].is_a?(BlockContext)
            enter_context(target)
            begin
              instruction.arity.times { parameters.push(stack.pop) }
              target[message].value(parameters)
            ensure
              leave_context
            end
          else
            stack_push_and_wrap(target[message])
          end
        else
          begin
            target.method(message).arity.times { parameters.push(stack.pop) }
            stack_push_and_wrap(target.send(message, *parameters))
          rescue NameError, NoMethodError
            raise MirrorError.new(target.inspect + " doesn't understand the message " + message)
          end
        end
      end
    else
      raise "Unknown instruction " + instruction.class.name.to_s
    end
  end
    
end