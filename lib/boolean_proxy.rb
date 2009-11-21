class BooleanProxy < Proxy
  
  def if_true(block)
    block.value if delegate
  end
  
  def if_false(block)
    block.value unless delegate
  end
  
  def if_true_if_false(true_block, false_block)
    true_block.value if delegate
    false_block.value unless delegate
  end
  
end