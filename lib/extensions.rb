class Object
  
  def as_string
    to_s
  end
  
  def print
    $stdout.print(self)
  end

  def print_ln
    $stdout.print(self)
    $stdout.print("\n")
  end
  
end