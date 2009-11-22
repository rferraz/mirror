class SlotContainer < BlankObject
  
  def initialize(vm, name, slots = {})
    @vm = vm
    @name = name
    @slots = slots
  end
  
  def vm
    @vm
  end
  
  def set_to(name, value)
    self[name] = value
  end

  def has?(name)
    @slots.has_key?(name)
  end
    
  def [](name)
    @slots[name]
  end
  
  def []=(name, value)
    @slots[name] = value
    @slots[name]
  end
  
  def inspect
    "<" + @name + ": " + @slots.inspect + ">"
  end
  
end