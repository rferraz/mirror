class VM
  
  def initialize(instructions)
    @instructions = instructions
    @root_context = BlockContext.new(universe)
  end
  
  def run
    reset_ip
    while has_instructions?
      execute(current_instruction)
      next_instruction
    end
    stack.pop
  rescue MirrorError => e
    puts e.message
  end

  def universe
    @universe ||= Universe.new(self, "Universe")
  end
    
  def offloads
    universe.offloads
  end
  
  def activate_block(block, arguments)
    arguments.reverse.each do |argument|
      stack.push(argument)
    end
    activate_block_context(current_context.receiver, block)
  end
  
  protected

  def ip
    @ip
  end
  
  def reset_ip
    @ip = 0
  end
  
  def has_instructions?
    @ip < @instructions.size
  end
  
  def next_instruction
    @ip += 1
  end
  
  def current_instruction
    @instructions[@ip]
  end
  
  def jump_to(new_ip)
    @ip = new_ip
  end
  
  def jump(count)
    @ip += count
  end

  def stack
    @stack ||= []
  end
  
  def contexts
    @contexts ||= [@root_context]
  end
  
  def current_context
    contexts.first
  end
  
  def enter_context(context)
    @contexts.unshift(context)
  end
  
  def leave_context
    @contexts.shift
  end
    
  def load(name)
    if current_context.block.home_context.has_local?(name)
      return current_context.block.home_context.get_local(name)
    end
    contexts.each do |context|
      if context.has_local?(name)
        return context.get_local(name)
      end
    end
    if current_context.receiver.has?(name)
      return current_context.receiver[name]
    end
  end
  
  def load_literal(name)
    contexts.each do |context|
      if context.receiver.has?(name)
        return context.receiver[name]
      end
    end
    raise current_context.receiver.inspect + " doesn't understand " + name
  end

  def store(name, value)
    if current_context.block.home_context.has_local?(name)
      return current_context.block.home_context.set_local(name, value)
    end
    contexts.each do |context|
      if context.has_local?(name)
        return context.set_local(name, value)
      end
    end
  end
  
  def get_arguments(count)
    parameters = []
    count.times { parameters.push(stack.pop) }
    parameters
  end
  
  def activate_block_context(target, block)
    enter_context(BlockContext.new(target, ip, block, get_arguments(block.arity)))
    jump_to(block.ip)
  end
  
  def send_raw_message(target, instruction)
    value = target.send(instruction.selector_method, *get_arguments(target.method(instruction.selector_method).arity))
    if value.is_a?(BlockActivation)
      if value.block.is_returnable?
        value.block.return
      else
        activate_block_context(value.block.receiver || current_context.receiver, value.block)
      end
    else
      stack.push(value)
    end
  end
  
  def handle_primitive(target, instruction)
    case instruction.selector_name
    when "+"
      stack.push(target + stack.pop)
      true
    when "-"
      stack.push(target - stack.pop)
      true
    when "*"
      stack.push(target * stack.pop)
      true
    when "/"
       stack.push(target / stack.pop)
       true
    when ">"
      stack.push(target > stack.pop)
      true
    when ">="
      stack.push(target >= stack.pop)
      true
    when "<"
      stack.push(target < stack.pop)
      true
    when "<="
      stack.push(target <= stack.pop)
      true
    when "%"
      stack.push(target % stack.pop)
      true
    when "^"
      stack.push(target ^ stack.pop)
      true
    when "="
      stack.push(target == stack.pop)
      true
    else
      false
    end
  end
    
  def execute(instruction)
    case instruction
    when Bytecode::Implicit
      stack.push(current_context.receiver)
    when Bytecode::Pop
      stack.pop
    when Bytecode::Push
      stack.push(instruction.value)
    when Bytecode::Load
      stack.push(load(instruction.name))
    when Bytecode::LoadLiteral
      stack.push(load_literal(instruction.name))
    when Bytecode::Store
      stack.push(store(instruction.name, stack.pop))
    when Bytecode::Jump
      jump(instruction.count)
    when Bytecode::JumpFalse
      jump(instruction.count) unless stack.pop
    when Bytecode::JumpTrue
      jump(instruction.count) if stack.pop
    when Bytecode::Block
      stack.push(BlockFrame.new(self, current_context, instruction.arity, ip, instruction.arguments, instruction.temporaries))
      jump(instruction.count)
    when Bytecode::Return
      block = current_context.block
      jump_to(current_context.last_ip)
      leave_context
      if block.is_returnable?
        stack.pop
        block.return
      end
      if block.return_self?
        stack.pop
        stack.push(block.receiver)
      end
    when Bytecode::Slot
      target = stack.pop
      if target.is_a?(World)
        if target.has?(instruction.selector_name)
          if target[instruction.selector_name].is_a?(BlockFrame)
            activate_block_context(target, target[instruction.selector_name])
          else
            stack.push(target[instruction.selector_name])
          end
        elsif instruction.is_unary? && target.has?(instruction.selector_unary_name)
          target[instruction.selector_unary_name] = stack.last          
        else
          send_raw_message(target, instruction)
        end
      elsif target.is_a?(BlockFrame) && instruction.selector == "value"
        target.value(*get_arguments(target.arity))
      else
        unless handle_primitive(target, instruction)
          send_raw_message(target, instruction)
        end
      end
    else
      raise "Unknown instruction " + instruction.class.name.to_s
    end
  end
    
end