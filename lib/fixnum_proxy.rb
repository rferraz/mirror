class FixnumProxy < Proxy
  
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
    Math.sqrt(delegate)
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
  
  def inspect
    delegate.inspect
  end
  
end