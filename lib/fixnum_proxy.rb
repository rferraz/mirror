class FixnumProxy < Proxy
  
  def down_to_do(lower_bound, block)
    self.downto(lower_bound) { |i| block.value(i) }
  end
  
end