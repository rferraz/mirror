class Universe < SlotContainer
  
  def initialize(vm)
    super
    set_to("World", World.new(vm))
    set_to("Error", Error.new(vm))
  end
  
end