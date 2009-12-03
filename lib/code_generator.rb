class CodeGenerator
  
  def initialize(ast)
    @ast = ast
    @scoping = Scoping.new
  end

  def generate
    @ast.collect { |statement| generate_any(statement) }.flatten
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
    Bytecode::Push.new(value)
  end
  
  def generate_variable(ast)
    if @scoping.in_scope?(ast.name)
      Bytecode::Load.new(ast.name)
    else
      [Bytecode::Implicit.new, Bytecode::Slot.new(ast.name)]
    end
  end
  
  def generate_block(ast)
    @scoping.enter_scope(ast.arguments + ast.temporaries)
    begin
      instructions = ast.statements.collect { |statement| generate_any(statement) }.flatten
    ensure
      @scoping.leave_scope
    end
    instructions.pop
    [Bytecode::Block.new(ast.arguments.size, instructions.size + 1, ast.arguments, ast.temporaries)] + instructions + [Bytecode::Return.new]
  end
  
  def generate_message(ast)
    if ast.target.is_a?(Ast::Implicit) && is_unary?(get_selector_name(ast.selector)) && @scoping.in_scope?(unary_name(get_selector_name(ast.selector)))
      instructions = []
      ast.arguments.reverse.each do |argument|
        instructions += [generate_any(argument)].flatten
      end
      instructions + [Bytecode::Store.new(unary_name(get_selector_name(ast.selector)))]
    else
      instructions = []
      ast.arguments.reverse.each do |argument|
        instructions += [generate_any(argument)].flatten
      end
      instructions += [generate_any(ast.target)].flatten
      instructions << Bytecode::Slot.new(ast.selector)
      instructions
    end
  end
  
  def generate_implicit(ast)
    Bytecode::Implicit.new
  end
  
  def generate_statement(ast)
    ([generate_any(ast.expression)] + [Bytecode::Pop.new]).flatten
  end
  
  protected
  
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
    
end