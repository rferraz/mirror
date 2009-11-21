class Universe < SlotContainer
  
  def initialize(vm)
    super
    set_to("World", World.new(vm))
  end
  
end