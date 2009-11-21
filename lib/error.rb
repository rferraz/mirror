class Error < World
  
  def signal(value)
    raise(value)
  end
  
end