class Universe < SlotContainer
  
  def initialize(vm, name, slots = {})
    super
    set_to("World", World.new(vm, "World"))
    set_to("Error", Error.new(vm, "Error"))
  end
  
end