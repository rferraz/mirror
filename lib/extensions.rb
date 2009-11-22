class Object
  
  def as_string
    to_s
  end
  
  def print
    $stdout.print(self)
    self
  end
  
  def print_ln
    $stdout.print(self)
    $stdout.print("\n")
    self
  end
  
end

class String
  
  def demodulize
    self.to_s.gsub(/^.*::/, '')
  end
  
  def underscore
    self.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end  
  
end