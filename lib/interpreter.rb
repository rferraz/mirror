class Interpreter
  
  def initialize(standalone)
    @standalone = standalone
    @parser = MirrorParser.new
  end
  
  def run(code)
    ast = @parser.parse(code)
    if ast
      instructions = CodeGenerator.new(ast.build).generate
      vm = VM.new(instructions)
      vm.run
      vm.offloads
    else
      puts @parser.failure_reason
    end
  end
  
  def self.run(standalone, code)
    new(standalone).run(code)
  end
  
end