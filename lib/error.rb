class MirrorError < StandardError; end
  
class Error < World
  
  def signal(value)
    raise(MirrorError.new(value))
  end
  
end