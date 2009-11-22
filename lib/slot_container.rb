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
    self[name.to_sym] = value
  end

  def has?(name)
    @slots.has_key?(name.to_sym)
  end
    
  def [](name)
    @slots[name.to_sym]
  end
  
  def []=(name, value)
    @slots[name.to_sym] = value
    @slots[name.to_sym]
  end
  
  def perform(message, *args)
    if has?(message)
      if self[message].is_a?(BlockContext)
        self[message].value(self, *args)
      else
        self[message]
      end
    else
      raise MirrorError.new(target.inspect + " doesn't understand the message " + message)
    end
  end
  
  def inspect
    "<" + @name + ": " + @slots.inspect + ">"
  end
  
end