class Interpreter
  
  def initialize
    @parser = MirrorParser.new
  end
  
  def run(code)
    ast = MirrorParser.new.parse(code).build
    instructions = CodeGenerator.new(ast).generate
    VM.new(instructions).run
  end
  
  def self.run(code)
    new.run(code)
  end
  
end