class CodeGenerator
  
  def initialize(ast)
    @ast = ast
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
    Bytecode::Load.new(ast.name)
  end
  
  def generate_block(ast)
    Bytecode::Block.new(ast.arguments, ast.statements.collect { |statement| generate_any(statement) }.flatten)
  end
  
  def generate_message(ast)
    instructions = []
    ast.arguments.reverse.each do |argument|
      instructions += [generate_any(argument)].flatten
    end
    instructions += [generate_any(ast.target)].flatten
    instructions << Bytecode::Message.new(ast.selector, selector_arity(ast.selector))
    instructions
  end
  
  def generate_implicit(ast)
    Bytecode::Implicit.new
  end
  
  def generate_statement(ast)
    ([generate_any(ast.expression)] + [Bytecode::Pop.new]).flatten
  end
  
  protected
  
  def selector_arity(selector)
    if selector.is_a?(Array)
      selector.size
    else
      1
    end
  end
  
end