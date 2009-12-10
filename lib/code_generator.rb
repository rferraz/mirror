class CodeGenerator
  
  INLINABLE_SELECTORS = [
    ["ifTrue:"],
    ["ifFalse:"],
    ["ifTrue:", "ifFalse:"]
  ]
  
  def initialize(ast)
    @ast = ast
    @scoping = Scoping.new
  end

  def generate
    generate_statements_list(@ast)
  end
  
  def method_missing(method, *args, &block)
    if method.to_s =~ /^generate_(.*)$/
      raise "The class #{$1} is not a valid AST node"
    else
      super
    end
  end
  
  protected

  def generate_any(ast)
    send("generate_#{ast.class.name.demodulize.underscore}", ast)
  end
  
  def generate_literal(ast)
    value = case ast.type
    when :decimal
      ast.value.to_f
    when :integer
      ast.value.to_i
    else
      ast.value
    end
    [Bytecode::Push.new(value)]
  end
  
  def generate_variable(ast)
    if @scoping.in_scope?(ast.name)
      [Bytecode::Load.new(ast.name)]
    else
      [Bytecode::LoadLiteral.new(ast.name)]
    end
  end
  
  def generate_block(ast)
    reset_relocated_temporaries if @scoping.is_root?
    @scoping.enter_scope(ast.arguments + ast.temporaries)
    begin
      instructions = generate_statements_list(ast.statements)
      instructions.pop
    ensure
      @scoping.leave_scope
    end
    relocate_temporaries(ast.temporaries) unless ast.temporaries.empty?
    temporaries = @scoping.is_root? ? get_relocated_temporaries : []
    [Bytecode::Block.new(ast.arguments.size, instructions.size + 1, ast.arguments, temporaries)] + 
      instructions + [Bytecode::Return.new]
  end
  
  def generate_message(ast)
    if INLINABLE_SELECTORS.include?(ast.selector)
      inlined_instructions = inline(ast)
      return inlined_instructions unless inlined_instructions.empty?
    end
    instructions = []
    ast.arguments.reverse.each do |argument|
      instructions += generate_any(argument)
    end    
    selector_name = get_selector_name(ast.selector)
    if ast.target.is_a?(Ast::Implicit) && is_unary?(selector_name) && @scoping.in_scope?(unary_name(selector_name))
      instructions += [Bytecode::Store.new(unary_name(selector_name))]
    else
      instructions += generate_any(ast.target)
      instructions << Bytecode::Slot.new(ast.selector)
    end
    instructions
  end
  
  def generate_implicit(ast)
    [Bytecode::Implicit.new]
  end
  
  def generate_statement(ast)
    generate_any(ast.expression) + [Bytecode::Pop.new]
  end
  
  def inline(ast)
    case ast.selector
    when ["ifTrue:"]
      inline_simple_if(ast, true)
    when ["ifFalse:"]
      inline_simple_if(ast, false)
    when ["ifTrue:", "ifFalse:"]
      inline_full_if(ast)
    else
      []
    end
  end
  
  def inline_simple_if(ast, for_true)
    block = ast.arguments.first
    if block.is_a?(Ast::Block)
      block_instructions = inline_block(block)
      jump_instruction = for_true ? Bytecode::JumpFalse.new(block_instructions.size) : Bytecode::JumpTrue.new(block_instructions.size)
      generate_any(ast.target) + [jump_instruction] + block_instructions
    else
      []
    end
  end

  def inline_full_if(ast)
    true_block = ast.arguments.first
    false_block = ast.arguments.last
    if true_block.is_a?(Ast::Block) && false_block.is_a?(Ast::Block)
      true_block_instructions = inline_block(true_block)
      false_block_instructions = inline_block(false_block)
      generate_any(ast.target) + 
        [Bytecode::JumpFalse.new(true_block_instructions.size + 1)] + 
        true_block_instructions +
        [Bytecode::Jump.new(false_block_instructions.size)] + 
        false_block_instructions
    else
      []
    end
  end
  
  def inline_block(block)
    instructions = generate_any(block)
    instructions[1, instructions.size - 2]
  end
  
  def generate_statements_list(statements)
    statements.inject([]) { |memo, statement| memo += generate_any(statement) ; memo }
  end
  
  def is_unary?(name)
    name =~ /^[a-zA-z]/ && name.count(":") == 1
  end
  
  def unary_name(name)
    name[0, name.size - 1]
  end
  
  def get_selector_name(selector)
    if selector == :-
      selector.to_s
    else
      [selector].flatten.collect(&:to_s).join
    end
  end

  def relocate_temporaries(temporaries)
    @relocated_temporaries += temporaries
  end
  
  def get_relocated_temporaries
    @relocated_temporaries
  end
  
  def reset_relocated_temporaries
    @relocated_temporaries = []
  end
      
end