require "test/unit"
require "mirror_interpreter"

class MirrorTest < Test::Unit::TestCase
  
  EXPRESSIONS = File.readlines("mirror_expressions.txt")
  BUILT_EXPRESSIONS = File.readlines("built_mirror_expressions.txt")

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
      assert_equal eval(BUILT_EXPRESSIONS[i]), @parser.parse(line).build
    end
  end
  
end
