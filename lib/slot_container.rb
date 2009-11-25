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
        self[message].copy.value(*args)
      else
        self[message]
      end
    elsif has?(unary_name(message.to_s))
      self[unary_name(message.to_s)] = args.first
      self[unary_name(message.to_s)]
    else
      raise MirrorError.new(self.inspect + " doesn't understand the message " + message)
    end
  end
  
  def inspect
    "<" + @name + ": " + @slots.inspect + ">"
  end
  
  def is_unary?(name)
    name =~ /^[a-zA-z]/ && name.count(":") == 1
  end
  
  def unary_name(name)
    name[0, name.size - 1]
  end
  
end