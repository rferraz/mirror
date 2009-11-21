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
  rescue Exception => e
    puts e.message
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
  
  def walk_contexts(name)
    @contexts.reverse.each do |context|
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
  
  def stack_push_and_wrap(value)
    if value.is_a?(TrueClass) || value.is_a?(FalseClass)
      stack.push(BooleanProxy.new(self, value))
    else
      stack.push(value)
    end
  end
  
  def execute(instruction)
    type, argument = instruction
    case type
    when :push
      stack_push_and_wrap(argument)
    when :load
      stack_push_and_wrap(current_context[argument])
    when :block
      block = BlockContext.new(self)
      argument.first.each do |item|
        block.add_argument(item.last)
      end
      argument.last.each do |item|
        block.add_instruction(item)
      end
      stack_push_and_wrap(block)
    when :send
      message = [argument].flatten.collect(&:to_s).collect(&:underscore).join("_")
      if message == "become"
        name = stack.pop
        value = stack.pop
        current_context[name] = value
      else
        target = stack.pop
        parameters = []
        if target.is_a?(SlotContainer) && target.has?(message)
          if target[message].is_a?(BlockContext)
            enter_context(target)
            begin
              (argument.is_a?(Array) ? argument.size : 1).times { parameters.unshift(stack.pop) }
              target[message].value(parameters)
            ensure
              leave_context
            end
          else
            stack_push_and_wrap(target[message])
          end
        else
          message = "-" if message == "_"
          target.method(message).arity.times { parameters.unshift(stack.pop) }
          stack_push_and_wrap(target.send(message, *parameters))
        end
      end
    else
      raise "Unknown instruction " + type.to_s
    end
  end
    
end