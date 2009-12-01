class BooleanProxy < Proxy
  
  def if_true(block)
    if delegate
      BlockActivation.new(block) 
    else
      self
    end
  end
  
  def if_false(block)
    unless delegate
      BlockActivation.new(block)
    else
      self
    end
  end
  
  def if_true_if_false(true_block, false_block)
    if delegate
      BlockActivation.new(true_block)
    else
      BlockActivation.new(false_block)
    end
  end
  
end