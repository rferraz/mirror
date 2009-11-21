class CodeGenerator
  
  def initialize(ast)
    @ast = ast
    @instructions = []
  end

  def generate
    @ast.each do |item|
      generate_any(item)
    end
    @instructions
  end
  
  def method_missing(method, *args, &block)
    if method.to_s =~ /^generate_(.*)$/
      raise "The class #{$1} is not a valid AST node"
    else
      super
    end
  end
  
  protected

  def add_instruction(*data)
    @instructions << data
  end
  
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
    add_instruction(:push, value)
  end
  
  def generate_variable(ast)
    add_instruction(:load, ast.name)
  end
  
  def generate_block(ast)
    add_instruction(:block, :start)
    ast.arguments.each do |item|
      add_instruction(:argument, item)
    end
    ast.statements.each do |item|
      generate_any(item)
    end
    add_instruction(:block, :end)
  end
  
  def generate_message(ast)
    ast.arguments.each do |item|
      generate_any(item)
    end
    generate_any(ast.target)
    add_instruction(:send, ast.selector)
  end
  
end