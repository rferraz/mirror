class BooleanProxy < Proxy
  
  def if_true(block)
    if delegate
      block.value 
    else
      nil
    end
  end
  
  def if_false(block)
    unless delegate
      block.value      
    else
      nil
    end
  end
  
  def if_true_if_false(true_block, false_block)
    if delegate
      true_block.value
    else
      false_block.value
    end
  end
  
end