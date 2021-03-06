require "test/unit"
require File.join(File.dirname(__FILE__), "..", "mirror")

class Object
  
  def transcribe
    self
  end
  
  def transcribe_and_break
    self
  end
  
end

class MirrorTest < Test::Unit::TestCase

  EXPRESSIONS = File.readlines(File.join(File.dirname(__FILE__), "mirror_expressions.txt"))
  BUILT_EXPRESSIONS = File.readlines(File.join(File.dirname(__FILE__), "built_mirror_expressions.txt"))
  GENERATED_EXPRESSIONS = File.readlines(File.join(File.dirname(__FILE__), "generated_mirror_expressions.txt"))

  def setup
    @parser = MirrorParser.new
  end
  
  def test_parsing
    EXPRESSIONS.each do |line|
      assert_not_nil @parser.parse(line)
    end
  end
  
  def test_building
    EXPRESSIONS.each_with_index do |line, i|
      assert_equal eval(BUILT_EXPRESSIONS[i]), @parser.parse(line).build.collect(&:to_sexp)
    end
  end
  
  def test_generating
    EXPRESSIONS.each_with_index do |line, i|
      assert_equal eval(GENERATED_EXPRESSIONS[i]), CodeGenerator.new(@parser.parse(line).build).generate.collect(&:to_sexp)
    end
  end
  
  def test_code
    Dir[File.join(File.dirname(__FILE__), "scripts", "*.mirror")].each do |name|
      lines = File.readlines(name)
      expected = eval(lines.shift.gsub(/^#\s*/, ""))
      assert_equal expected, Interpreter.run(false, lines.join)
    end
  end
    
end
