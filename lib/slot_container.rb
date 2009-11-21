class SlotContainer < BlankObject
  
  def initialize(vm)
    @vm = vm
    @slots = {}
  end
  
  def vm
    @vm
  end
  
  def set_to(name, value)
    @slots[name] = value
    @slots[name]
  end
  
  def [](name)
    if name == "self"
      self
    else
      @slots[name]
    end
  end
  
  def has?(name)
    @slots.has_key?(name)
  end
  
  def []=(name, value)
    @slots[name] = value
  end
  
end