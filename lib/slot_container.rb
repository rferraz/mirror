class SlotContainer < BlankObject
  
  def initialize(vm, slots = {})
    @vm = vm
    @slots = slots
  end
  
  def vm
    @vm
  end
  
  def set_to(name, value)
    @slots[name] = value
    @slots[name]
  end
  
  def [](name)
    @slots[name]
  end
  
  def has?(name)
    @slots.has_key?(name)
  end
  
  def []=(name, value)
    @slots[name] = value
  end
  
  def inspect
    @slots.inspect
  end
  
end