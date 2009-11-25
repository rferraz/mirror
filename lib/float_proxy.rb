class FloatProxy < Proxy

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
  
end