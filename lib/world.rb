class World < SlotContainer

  def mirror_into(name)
    vm.universe.set_to(name, World.new(vm, name, @slots.dup))
  end
  
  protected
  
end
