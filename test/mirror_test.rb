require "test/unit"
require File.join(File.dirname(__FILE__), "..", "mirror_interpreter")

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
    assert_not_nil @parser.parse(File.readlines(File.join(File.dirname(__FILE__), "test.mirror")).join)
  end
    
end
