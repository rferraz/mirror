class Interpreter
  
  def initialize
    @parser = MirrorParser.new
  end
  
  def run(code)
    ast = @parser.parse(code)
    if ast
      instructions = CodeGenerator.new(ast.build).generate
      VM.new(instructions).run
    else
      puts @parser.failure_reason
    end
  end
  
  def self.run(code)
    new.run(code)
  end
  
end