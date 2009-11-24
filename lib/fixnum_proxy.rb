class FixnumProxy < Proxy
  
  def down_to_do(lower_bound, block)
    self.downto(lower_bound) { |i| block.value(i) }
    self
  end

  def to_do(upper_bound, block)
    self.upto(upper_bound) { |i| block.value(i) }
    self
  end
  
end