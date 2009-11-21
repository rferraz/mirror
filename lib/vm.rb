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
  end

  def universe
    @universe ||= Universe.new(self)
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
  
  def execute(instruction)
    type, argument = instruction
    case type
    when :push
      stack.push(argument)
    when :load
      stack.push(current_context[argument])
    when :block
      nesting = instruction.last
      block = BlockContext.new(self)
      while ((instruction = next_instruction).first != :block) && (instruction.last != nesting)
        type, argument = instruction
        if type == :argument
          block.add_argument(argument)
        else
          block.add_instruction(instruction)
        end
      end
      stack.push(block)
    when :send
      message = [argument].flatten.collect(&:to_s).collect(&:underscore).join("_")
      if message == "become"
        name = stack.pop
        value = stack.pop
        if current_context.is_a?(BlockContext)
          current_context.world[name] = value
        else
          current_context[name] = value
        end
      else
        target = stack.pop
        parameters = []
        if target.is_a?(SlotContainer) && target.has?(message)
          if target[message].is_a?(BlockContext)
            (argument.is_a?(Array) ? argument.size : 1).times { parameters.unshift(stack.pop) }
            target[message].value(target, parameters)
          else
            stack.push(target[message])
          end
        else
          message = "-" if message == "_"
          target.method(message).arity.times { parameters.unshift(stack.pop) }
          stack.push(target.send(message, *parameters))
        end
      end
    else
      raise "Unknown instruction " + type.to_s
    end
  end
    
end