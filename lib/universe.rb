class Universe < SlotContainer

  attr_reader :offloads
  
  def initialize(vm, name, slots = {})
    super
    initialize_offloads
    set_to("World", World.new(vm, "World"))
    set_to("Error", Error.new(vm, "Error"))
  end
  
  def offload(value)
    @offloads << value
  end
   
  protected
  
  def initialize_offloads   
    @offloads ||= []
  end
    
end