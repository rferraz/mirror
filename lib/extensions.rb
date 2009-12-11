class Object
  
  def as_string
    to_s
  end
  
  def transcribe
    $stdout.print(self)
    self
  end
  
  def transcribe_and_break
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

class Boolean
  
  def if_true(block)
    if self
      BlockActivation.new(block) 
    else
      self
    end
  end
  
  def if_false(block)
    unless self
      BlockActivation.new(block)
    else
      self
    end
  end
  
  def if_true_if_false(true_block, false_block)
    if self
      BlockActivation.new(true_block)
    else
      BlockActivation.new(false_block)
    end
  end
  
end

class Fixnum
  
  def down_to_do(bound, block)
    block.returnable_with(:from => self, :to => bound) do
      if return_stack[:from] >= return_stack[:to]
        value(return_stack[:from])
        return_stack[:from] -= 1
      end
    end
    BlockActivation.new(block)
  end

  def to_do(bound, block)
    block.returnable_with(:from => self, :to => bound) do
      if return_stack[:from] <= return_stack[:to]
        value(return_stack[:from])
        return_stack[:from] += 1
      end
    end
    BlockActivation.new(block)
  end
  
  def sqrt
    Math.sqrt(self)
  end
  
  def compare_to(other)
    if self < other
      "lt"
    elsif self > other
      "gt"
    else
      "eq"
    end
  end
  
end

class Float

  def sqrt
    Math.sqrt(self)
  end

  def compare_to(other)
    if self < other
      "lt"
    elsif self > other
      "gt"
    else
      "eq"
    end
  end

end  